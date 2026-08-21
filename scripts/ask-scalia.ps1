param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Question,

    [ValidateRange(1, 10)]
    [int]$TopK = 2,

    [ValidateRange(0.0, 1.0)]
    [double]$MinimumScore = 0.25
)

[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [Console]::OutputEncoding
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $PSScriptRoot
$envPath = Join-Path $rootPath ".env"
$indexPath = Join-Path $rootPath "data\knowledge-index.json"

function Import-DotEnv {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Warning "Fichier .env introuvable : $Path"
        return
    }

    foreach ($rawLine in Get-Content -Path $Path -Encoding UTF8) {
        $line = $rawLine.Trim()

        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }

        if ($line.StartsWith("#")) {
            continue
        }

        if (-not $line.Contains("=")) {
            continue
        }

        $parts = $line.Split("=", 2)

        $name = $parts[0].Trim()
        $value = $parts[1].Trim().Trim('"').Trim("'")

        # Une variable déjà positionnée dans le shell (ex. override ponctuel) est prioritaire sur le .env.
        if (-not [string]::IsNullOrEmpty([Environment]::GetEnvironmentVariable($name, "Process"))) {
            continue
        }

        [Environment]::SetEnvironmentVariable(
            $name,
            $value,
            "Process"
        )
    }
}

function Convert-ToDoubleVector {
    param(
        [Parameter(Mandatory = $true)]
        $Value
    )

    $vector = @($Value)

    # Corrige un éventuel tableau imbriqué :
    # [[0.1, 0.2, ...]] devient [0.1, 0.2, ...]
    while (
        $vector.Count -eq 1 -and
        $vector[0] -is [System.Array]
    ) {
        $vector = @($vector[0])
    }

    [double[]]$result = @(
        $vector |
            ForEach-Object {
                [double]$_
            }
    )

    return $result
}

function Get-CosineSimilarity {
    param(
        [Parameter(Mandatory = $true)]
        [object[]]$VectorA,

        [Parameter(Mandatory = $true)]
        [object[]]$VectorB
    )

    if ($VectorA.Count -ne $VectorB.Count) {
        throw "Les vecteurs n'ont pas la même dimension."
    }

    [double]$dotProduct = 0
    [double]$normA = 0
    [double]$normB = 0

    for ($i = 0; $i -lt $VectorA.Count; $i++) {
        [double]$valueA = $VectorA[$i]
        [double]$valueB = $VectorB[$i]

        $dotProduct += $valueA * $valueB
        $normA += $valueA * $valueA
        $normB += $valueB * $valueB
    }

    if ($normA -eq 0 -or $normB -eq 0) {
        return 0
    }

    return $dotProduct / (
        [Math]::Sqrt($normA) *
        [Math]::Sqrt($normB)
    )
}

Import-DotEnv -Path $envPath

$ollamaUrl = "http://localhost:11434"

if (-not [string]::IsNullOrWhiteSpace($env:OLLAMA_URL)) {
    $ollamaUrl = $env:OLLAMA_URL.TrimEnd("/")
}

$chatModel = "scalia:1.0.0"

if (-not [string]::IsNullOrWhiteSpace($env:CHAT_MODEL)) {
    $chatModel = $env:CHAT_MODEL
}
elseif (-not [string]::IsNullOrWhiteSpace($env:MODEL_NAME)) {
    $chatModel = $env:MODEL_NAME
}

$embeddingModel = "qwen3-embedding:0.6b"

if (-not [string]::IsNullOrWhiteSpace($env:EMBEDDING_MODEL)) {
    $embeddingModel = $env:EMBEDDING_MODEL
}

Write-Host ""
Write-Host "Scalia"
Write-Host "-----"
Write-Host "Question : $Question"
Write-Host ""

if (-not (Test-Path $indexPath)) {
    throw "L'index est introuvable : $indexPath. Lance d'abord .\scripts\index-knowledge.ps1"
}

Write-Host "Vérification d'Ollama..."

$version = Invoke-RestMethod `
    -Uri "$ollamaUrl/api/version" `
    -Method Get `
    -TimeoutSec 15

Write-Host "Ollama disponible, version : $($version.version)"
Write-Host ""

Write-Host "Chargement de l'index documentaire..."

$indexJson = Get-Content `
    -Path $indexPath `
    -Raw `
    -Encoding UTF8

$parsedIndex = $indexJson | ConvertFrom-Json

# Windows PowerShell 5.1 peut retourner le tableau JSON
# comme un seul objet. On normalise donc explicitement la collection.
while (
    $parsedIndex -is [System.Array] -and
    $parsedIndex.Count -eq 1 -and
    $parsedIndex[0] -is [System.Array]
) {
    $parsedIndex = $parsedIndex[0]
}

if ($parsedIndex -is [System.Array]) {
    [object[]]$documents = $parsedIndex
}
else {
    [object[]]$documents = @($parsedIndex)
}

if ($documents.Count -eq 0) {
    throw "L'index documentaire est vide."
}

Write-Host "Documents disponibles : $($documents.Count)"

foreach ($document in $documents) {
    $dimension = @($document.embedding).Count

    Write-Host "- $($document.source) : $dimension dimensions"
}

Write-Host ""

Write-Host "Analyse de la question avec $embeddingModel..."

$embeddingRequestObject = @{
    model = $embeddingModel
    input = @([string]$Question)
    truncate = $true
    keep_alive = "10m"
}

$embeddingRequestJson = $embeddingRequestObject |
    ConvertTo-Json -Depth 5 -Compress

$embeddingResponse = Invoke-RestMethod `
    -Uri "$ollamaUrl/api/embed" `
    -Method Post `
    -ContentType "application/json; charset=utf-8" `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($embeddingRequestJson)) `
    -TimeoutSec 180

if (
    $null -eq $embeddingResponse.embeddings -or
    $embeddingResponse.embeddings.Count -eq 0
) {
    throw "Le modèle d'embeddings n'a retourné aucun vecteur."
}

[double[]]$questionEmbedding = Convert-ToDoubleVector `
    -Value $embeddingResponse.embeddings[0]

Write-Host "Vecteur reçu : $($questionEmbedding.Count) dimensions"
Write-Host ""
Write-Host "Recherche dans la documentation..."

$searchResults = @()

foreach ($document in $documents) {
    if ($null -eq $document.embedding) {
        continue
    }

[double[]]$documentEmbedding = Convert-ToDoubleVector `
    -Value $document.embedding

    if ($questionEmbedding.Count -ne $documentEmbedding.Count) {
    Write-Warning (
        "Document ignoré : {0}. Question : {1} dimensions, document : {2} dimensions." -f
        $document.source,
        $questionEmbedding.Count,
        $documentEmbedding.Count
    )

    continue
}

    $score = Get-CosineSimilarity `
        -VectorA $questionEmbedding `
        -VectorB $documentEmbedding

    $searchResults += [PSCustomObject]@{
        source = [string]$document.source
        title = [string]$document.title
        content = [string]$document.content
        score = [double]$score
    }

    # BOOST DES QUESTIONS GÉNÉRALES SUR SCALRISE
$isGeneralQuestion = $Question -match '(?i)\b(site|plateforme|scalrise|application|fonctionnalités?|modules?)\b|à quoi (ça|cela) sert|que (peut|peux) faire'

if ($isGeneralQuestion) {
    foreach ($result in $searchResults) {
        if ($result.source -eq 'knowledge/general/presentation-scalrise.md') {
            $result.score = [double]$result.score + 0.15
        }
    }
}
}

$sortedResults = @(
    $searchResults |
        Where-Object {
            $_.score -ge $MinimumScore
        } |
        Sort-Object -Property score -Descending
)

if ($sortedResults.Count -eq 0) {
    Write-Host ""
    Write-Host "Scalia :"
    Write-Host "Je ne dispose pas encore d'informations suffisantes dans la documentation Scalrise pour répondre à cette question."
    exit 0
}

$firstResult = $sortedResults[0]

# On utilise toujours le document le plus pertinent.
$selectedDocuments = @($firstResult)

# On ajoute le deuxième document s'il est proche du premier
# ou s'il reste suffisamment pertinent.
if ($sortedResults.Count -ge 2 -and $TopK -gt 1) {
    $secondResult = $sortedResults[1]
    $scoreDifference = $firstResult.score - $secondResult.score

    if (
        $scoreDifference -lt 0.08 -or
        $secondResult.score -ge 0.52
    ) {
        $selectedDocuments += $secondResult
    }
}

Write-Host ""
Write-Host "Documents sélectionnés :"

foreach ($document in $selectedDocuments) {
    $formattedScore = [Math]::Round($document.score, 4)

    Write-Host "- $($document.source) — score : $formattedScore"
}

$contextParts = @()
$sourceNumber = 1

foreach ($document in $selectedDocuments) {
    $contextParts += @"
SOURCE $sourceNumber
Priorité : $sourceNumber
Score de pertinence : $([Math]::Round($document.score, 4))
Titre : $($document.title)
Fichier : $($document.source)

$($document.content)
"@

    $sourceNumber++
}

$context = $contextParts -join "`r`n`r`n------------------------------`r`n`r`n"

$systemMessage = @"
Tu es Scalia, l'assistant officiel de Scalrise.

Tu dois répondre uniquement à partir de la documentation Scalrise fournie.

Règles obligatoires :
- N'invente aucune fonctionnalité, aucun bouton, menu ou écran.
- Si la documentation ne permet pas de répondre, dis-le clairement.
- Réponds en français avec une réponse courte et précise.
- Utilise en priorité le document le plus spécifique à la question.
- Une page détaillée est prioritaire sur une présentation générale du module.
- Réponds en 2 à 4 phrases maximum.
- Donne directement la réponse utile.
- Ne répète pas toutes les informations du document.
- Mentionne une restriction Free ou Premium uniquement si elle change directement la réponse à la question.
- N'ajoute pas une règle d'abonnement sans lien direct avec la demande.
- Si la documentation ne confirme pas précisément une information, indique-le au lieu de la déduire.
- Réponds d'abord directement à la question en une phrase.
- Réponds généralement en 2 à 4 phrases maximum.
- Ne liste pas toutes les fonctionnalités d'une page si l'utilisateur demande seulement si la fonctionnalité existe.
- Mentionne les principales restrictions Free ou Premium en une seule phrase.
- Ne détaille davantage que si l'utilisateur demande « comment », « quelles fonctionnalités » ou « explique ».
- Termine toujours une phrase avant d'atteindre la limite de génération.

Règles relatives aux abonnements :
- Les limites Free et Premium sont des informations essentielles.
- Si une fonctionnalité dépend de l'abonnement, tu dois toujours le préciser.
- Ne réponds jamais simplement « oui » si l'accès dépend du plan utilisateur.
- Pour une question sur une limite, indique clairement ce qui est disponible
  gratuitement et ce qui nécessite Premium.
- Si le plan de l'utilisateur n'est pas connu, présente les deux situations.

Avant de répondre, vérifie mentalement :
1. Existe-t-il une restriction Free ou Premium dans la documentation ?
2. Existe-t-il une limite de quantité ?
3. La réponse change-t-elle selon l'abonnement ?

Ne donne aucun conseil financier, fiscal ou juridique personnalisé.
"@

$userMessage = @"
DOCUMENTATION SCALRISE
======================

$context

QUESTION DE L'UTILISATEUR
=========================

$Question

CONSIGNE DE RÉPONSE
===================

Réponds directement à la question.

Si la documentation mentionne une limite, un abonnement Free ou Premium,
tu dois obligatoirement l'inclure dans ta réponse.
"@

$chatRequestObject = @{
    model = $chatModel

    messages = @(
        @{
            role = "system"
            content = $systemMessage
        },
        @{
            role = "user"
            content = $userMessage
        }
    )

    stream = $false
    think = $false
    keep_alive = "30m"

    options = @{
        temperature = 0.1
        num_ctx = 2048
        num_predict = 160
    }
}

$chatRequestJson = $chatRequestObject |
    ConvertTo-Json -Depth 20 -Compress

Write-Host ""
Write-Host "Génération de la réponse avec $chatModel..."
Write-Host ""

$chatResponse = Invoke-RestMethod `
    -Uri "$ollamaUrl/api/chat" `
    -Method Post `
    -ContentType "application/json; charset=utf-8" `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($chatRequestJson)) `
    -TimeoutSec 300

if (
    $null -eq $chatResponse.message -or
    [string]::IsNullOrWhiteSpace($chatResponse.message.content)
) {
    throw "Scalia n'a retourné aucune réponse."
}

Write-Host "Scalia :"
Write-Host ""
Write-Host "Performances :"
Write-Host "Durée totale : $([Math]::Round($chatResponse.total_duration / 1000000000, 2)) s"
Write-Host "Chargement : $([Math]::Round($chatResponse.load_duration / 1000000000, 2)) s"
Write-Host "Analyse du contexte : $([Math]::Round($chatResponse.prompt_eval_duration / 1000000000, 2)) s"
Write-Host "Génération : $([Math]::Round($chatResponse.eval_duration / 1000000000, 2)) s"
Write-Host "Tokens générés : $($chatResponse.eval_count)"
if ($chatResponse.eval_duration -gt 0) {
    $tokensPerSecond =
        $chatResponse.eval_count /
        ($chatResponse.eval_duration / 1000000000)

    Write-Host "Vitesse : $([Math]::Round($tokensPerSecond, 2)) tokens/s"
}
Write-Host $chatResponse.message.content
Write-Host ""
