# Calcule les vecteurs des questions de référence de Scalia (eval/reference-questions.json)
# avec le même modèle et la même requête que le back (AIChatService.embed), et les écrit
# dans data/reference-questions-embedded.json.
#
# Lancé automatiquement à la fin de index-knowledge.ps1 : l'index et les questions doivent
# toujours être calculés ensemble, avec le même modèle. Peut aussi être lancé seul après
# avoir ajouté des questions, sans réindexer la documentation.
#
# Ensuite, copier data/knowledge-index.json et data/reference-questions-embedded.json dans
# patrimonio-back/knowledge/ puis lancer le test Go TestScaliaReferenceQuestions.

[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [Console]::OutputEncoding
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $PSScriptRoot
$envPath = Join-Path $rootPath ".env"
$questionsPath = Join-Path $rootPath "eval/reference-questions.json"
$outputPath = Join-Path $rootPath "data/reference-questions-embedded.json"

# Mêmes règles que index-knowledge.ps1 : une variable déjà définie dans le shell est prioritaire.
if (Test-Path $envPath) {
    foreach ($rawLine in Get-Content $envPath -Encoding UTF8) {
        $line = $rawLine.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#") -or -not $line.Contains("=")) {
            continue
        }
        $parts = $line.Split("=", 2)
        $name = $parts[0].Trim()
        if (-not [string]::IsNullOrEmpty([Environment]::GetEnvironmentVariable($name, "Process"))) {
            continue
        }
        [Environment]::SetEnvironmentVariable($name, $parts[1].Trim().Trim('"').Trim("'"), "Process")
    }
}

$ollamaUrl = if ($env:OLLAMA_URL) { $env:OLLAMA_URL.TrimEnd("/") } else { "http://localhost:11434" }
$embeddingModel = if ($env:EMBEDDING_MODEL) { $env:EMBEDDING_MODEL } else { "qwen3-embedding:0.6b" }

if (-not (Test-Path $questionsPath)) {
    throw "Fichier des questions de référence introuvable : $questionsPath"
}

$reference = Get-Content -Path $questionsPath -Raw -Encoding UTF8 | ConvertFrom-Json
$embedded = [System.Collections.Generic.List[object]]::new()

Write-Host ""
Write-Host "Questions de référence : $($reference.questions.Count) — modèle $embeddingModel"

foreach ($item in $reference.questions) {
    # Même requête que le back : la question seule, sans métadonnées.
    $body = @{
        model = $embeddingModel
        input = @([string]$item.question)
        truncate = $true
        keep_alive = "10m"
    } | ConvertTo-Json -Depth 5 -Compress

    $response = Invoke-RestMethod `
        -Uri "$ollamaUrl/api/embed" `
        -Method Post `
        -ContentType "application/json; charset=utf-8" `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -TimeoutSec 180

    if ($null -eq $response.embeddings -or $response.embeddings.Count -eq 0) {
        throw "Ollama n'a retourné aucun vecteur pour la question : $($item.question)"
    }

    [double[]]$embedding = @($response.embeddings[0] | ForEach-Object { [double]$_ })

    $embedded.Add([PSCustomObject]@{
        question = [string]$item.question
        expected = @($item.expected)
        known_issue = if ($item.known_issue) { [string]$item.known_issue } else { "" }
        embedding = $embedding
    })
    Write-Host "  ok : $($item.question)"
}

$output = [PSCustomObject]@{
    embedding_model = $embeddingModel
    questions = $embedded.ToArray()
}

[System.IO.File]::WriteAllText(
    $outputPath,
    (ConvertTo-Json -InputObject $output -Depth 6 -Compress),
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host "Vecteurs des questions écrits dans : $outputPath"
