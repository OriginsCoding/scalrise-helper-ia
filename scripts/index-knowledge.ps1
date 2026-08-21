[Console]::InputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [Console]::OutputEncoding
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $PSScriptRoot
$envPath = Join-Path $rootPath ".env"
$knowledgePath = Join-Path $rootPath "knowledge"
$dataPath = Join-Path $rootPath "data"
$indexPath = Join-Path $dataPath "knowledge-index.json"

function Import-DotEnv {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Warning "Fichier .env introuvable : $Path"
        return
    }

    foreach ($rawLine in Get-Content $Path -Encoding UTF8) {
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

function Split-MarkdownIntoChunks {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [int]$TargetSize = 1600,
        [int]$Overlap = 200,
        [int]$MinSize = 400
    )

    # Le frontmatter YAML (--- ... ---) n'est pas découpé, il ne sert qu'aux métadonnées du fichier.
    $body = $Content

    if ($Content -match '(?s)^---\r?\n.*?\r?\n---\r?\n(.*)$') {
        $body = $Matches[1]
    }

    $lines = $body -split "`r?`n"
    $sections = [System.Collections.Generic.List[string]]::new()
    $currentSection = [System.Text.StringBuilder]::new()

    foreach ($line in $lines) {
        if ($line -match '^#{1,6}\s' -and $currentSection.Length -gt 0) {
            $sections.Add($currentSection.ToString().Trim())
            $currentSection = [System.Text.StringBuilder]::new()
        }

        [void]$currentSection.AppendLine($line)
    }

    if ($currentSection.Length -gt 0) {
        $sections.Add($currentSection.ToString().Trim())
    }

    $sections = @($sections | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })

    # Regroupe gloutonnement les sections consécutives jusqu'à approcher TargetSize
    # (et non juste MinSize), pour limiter le nombre de chunks et garder du contexte.
    $mergedSections = [System.Collections.Generic.List[string]]::new()
    $buffer = ""

    foreach ($section in $sections) {
        if ([string]::IsNullOrEmpty($buffer)) {
            $buffer = $section
            continue
        }

        if (($buffer.Length + 2 + $section.Length) -le $TargetSize) {
            $buffer = "$buffer`r`n`r`n$section"
        }
        else {
            $mergedSections.Add($buffer)
            $buffer = $section
        }
    }

    if (-not [string]::IsNullOrEmpty($buffer)) {
        $mergedSections.Add($buffer)
    }

    # Rattache au chunk précédent tout reliquat resté sous MinSize (ex. dernière section isolée).
    $cleanedSections = [System.Collections.Generic.List[string]]::new()

    foreach ($section in $mergedSections) {
        if (
            $cleanedSections.Count -gt 0 -and
            $section.Length -lt $MinSize -and
            ($cleanedSections[$cleanedSections.Count - 1].Length + $section.Length) -le ($TargetSize * 1.3)
        ) {
            $cleanedSections[$cleanedSections.Count - 1] = "$($cleanedSections[$cleanedSections.Count - 1])`r`n`r`n$section"
        }
        else {
            $cleanedSections.Add($section)
        }
    }

    # Re-découpe les sections encore trop longues, avec un chevauchement entre morceaux successifs.
    $chunks = [System.Collections.Generic.List[string]]::new()

    foreach ($section in $cleanedSections) {
        if ($section.Length -le $TargetSize) {
            $chunks.Add($section)
            continue
        }

        $start = 0

        while ($start -lt $section.Length) {
            $length = [Math]::Min($TargetSize, $section.Length - $start)
            $chunks.Add($section.Substring($start, $length).Trim())

            if ($start + $length -ge $section.Length) {
                break
            }

            $start += ($TargetSize - $Overlap)
        }
    }

    return @($chunks | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

Import-DotEnv -Path $envPath

$ollamaUrl = if ($env:OLLAMA_URL) {
    $env:OLLAMA_URL.TrimEnd("/")
} else {
    "http://localhost:11434"
}

$embeddingModel = if ($env:EMBEDDING_MODEL) {
    $env:EMBEDDING_MODEL
} else {
    "qwen3-embedding:0.6b"
}

# Taille cible ~400 tokens, chevauchement ~12 %, en-dessous de MinChunkSize on fusionne avec la section suivante.
$chunkSize = if ($env:CHUNK_SIZE) { [int]$env:CHUNK_SIZE } else { 1600 }
$chunkOverlap = if ($env:CHUNK_OVERLAP) { [int]$env:CHUNK_OVERLAP } else { 200 }
$minChunkSize = if ($env:MIN_CHUNK_SIZE) { [int]$env:MIN_CHUNK_SIZE } else { 400 }

Write-Host ""
Write-Host "Configuration"
Write-Host "-------------"
Write-Host "Ollama : $ollamaUrl"
Write-Host "Modèle : $embeddingModel"
Write-Host "Documentation : $knowledgePath"
Write-Host "Chunk : taille $chunkSize / chevauchement $chunkOverlap / min $minChunkSize"
Write-Host ""

# Vérification d'Ollama
Write-Host "Vérification de l'API Ollama..."

$version = Invoke-RestMethod `
    -Uri "$ollamaUrl/api/version" `
    -Method Get `
    -TimeoutSec 15

Write-Host "Ollama disponible, version : $($version.version)"
Write-Host ""

if (-not (Test-Path $knowledgePath)) {
    throw "Le dossier knowledge est introuvable : $knowledgePath"
}

New-Item `
    -ItemType Directory `
    -Force `
    -Path $dataPath |
    Out-Null

$files = @(
    Get-ChildItem `
        -Path $knowledgePath `
        -Recurse `
        -File `
        -Filter "*.md"
)

if ($files.Count -eq 0) {
    throw "Aucun fichier Markdown trouvé dans knowledge."
}

Write-Host "Fichiers trouvés : $($files.Count)"
Write-Host ""

$documents = [System.Collections.Generic.List[object]]::new()

foreach ($file in $files) {
    Write-Host "========================================"
    Write-Host "Fichier : $($file.FullName)"

    $content = Get-Content `
        -Path $file.FullName `
        -Raw `
        -Encoding UTF8

    if ([string]::IsNullOrWhiteSpace($content)) {
        Write-Warning "Fichier vide, ignoré."
        continue
    }

    Write-Host "Taille : $($content.Length) caractères"

    $chunks = @(
        Split-MarkdownIntoChunks `
            -Content $content `
            -TargetSize $chunkSize `
            -Overlap $chunkOverlap `
            -MinSize $minChunkSize
    )

    if ($chunks.Count -eq 0) {
        Write-Warning "Aucun chunk généré, fichier ignoré."
        continue
    }

    Write-Host "Découpage : $($chunks.Count) chunk(s)"

$relativePath = $file.FullName.Substring($rootPath.Length)
$relativePath = $relativePath.TrimStart([char[]]"\/")
$relativePath = $relativePath.Replace("\", "/")

    $chunkNumber = 0

    foreach ($chunkText in $chunks) {
        $chunkNumber++

        Write-Host "  Chunk $chunkNumber/$($chunks.Count) : $($chunkText.Length) caractères — envoi à $embeddingModel..."

        # On force explicitement le contenu en chaîne de caractères.
        [string]$documentText = $chunkText

        $requestBodyObject = @{
            model = $embeddingModel

            # Tableau contenant une chaîne : format accepté par /api/embed.
            input = @($documentText)

            truncate = $true
            keep_alive = "10m"
        }

        $requestBody = $requestBodyObject |
            ConvertTo-Json -Depth 5 -Compress

        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        $response = Invoke-RestMethod `
            -Uri "$ollamaUrl/api/embed" `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body $requestBody `
            -TimeoutSec 180

        $stopwatch.Stop()

        Write-Host "  Réponse reçue en $([Math]::Round($stopwatch.Elapsed.TotalSeconds, 2)) secondes."

        if (
            $null -eq $response.embeddings -or
            $response.embeddings.Count -eq 0
        ) {
            throw "Ollama n'a retourné aucun embedding pour $($file.Name) (chunk $chunkNumber)."
        }

        [double[]]$embedding = @(
            $response.embeddings[0] |
                ForEach-Object {
                    [double]$_
                }
        )

        $document = [PSCustomObject]@{
            source = $relativePath
            title = $file.BaseName
            chunk = $chunkNumber
            chunkCount = $chunks.Count
            content = $chunkText
            embedding = $embedding
        }

        $documents.Add($document)
    }

    Write-Host "$($chunks.Count) chunk(s) ajouté(s) à l'index."
    Write-Host ""
}

if ($documents.Count -eq 0) {
    throw "Aucun document n'a été indexé. Vérifie le contenu des fichiers Markdown."
}

Write-Host "Sérialisation de l'index JSON..."

# -InputObject évite que PowerShell déroule la collection dans le pipeline.
$json = ConvertTo-Json `
    -InputObject $documents.ToArray() `
    -Depth 5

Write-Host "Écriture dans : $indexPath"

[System.IO.File]::WriteAllText(
    $indexPath,
    $json,
    [System.Text.UTF8Encoding]::new($false)
)

Write-Host ""
Write-Host "========================================"
Write-Host "Index créé avec succès."
Write-Host "Documents indexés : $($documents.Count)"
Write-Host "Taille : $((Get-Item $indexPath).Length) octets"
Write-Host "Fichier : $indexPath"
