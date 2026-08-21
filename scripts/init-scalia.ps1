[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [Console]::OutputEncoding
$ErrorActionPreference = "Stop"

$rootPath = Split-Path -Parent $PSScriptRoot
$envPath = Join-Path $rootPath ".env"
$modelfilePath = Join-Path $rootPath "Modelfile"

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

        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith("#") -or -not $line.Contains("=")) {
            continue
        }

        $parts = $line.Split("=", 2)
        $name = $parts[0].Trim()
        $value = $parts[1].Trim().Trim('"').Trim("'")

        # Une variable déjà positionnée (ex. dans compose.yaml) est prioritaire sur le .env.
        if (-not [string]::IsNullOrEmpty([Environment]::GetEnvironmentVariable($name, "Process"))) {
            continue
        }

        [Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}

Import-DotEnv -Path $envPath

$ollamaUrl = if ($env:OLLAMA_URL) { $env:OLLAMA_URL.TrimEnd("/") } else { "http://localhost:11434" }
$baseModel = if ($env:BASE_MODEL) { $env:BASE_MODEL } else { throw "BASE_MODEL n'est pas défini." }
$modelName = if ($env:MODEL_NAME) { $env:MODEL_NAME } else { throw "MODEL_NAME n'est pas défini." }
$embeddingModel = if ($env:EMBEDDING_MODEL) { $env:EMBEDDING_MODEL } else { "qwen3-embedding:0.6b" }

Write-Host ""
Write-Host "Initialisation Scalia"
Write-Host "----------------------"
Write-Host "Ollama          : $ollamaUrl"
Write-Host "Modèle de base  : $baseModel"
Write-Host "Modèle Scalia   : $modelName"
Write-Host "Modèle embedding: $embeddingModel"
Write-Host ""

# Attente active de l'API (le healthcheck du service ollama devrait déjà l'assurer, en filet de sécurité).
Write-Host "Vérification d'Ollama..."
$maxAttempts = 30
$attempt = 0

while ($true) {
    $attempt++
    try {
        $version = Invoke-RestMethod -Uri "$ollamaUrl/api/version" -Method Get -TimeoutSec 10
        Write-Host "Ollama disponible, version : $($version.version)"
        break
    }
    catch {
        if ($attempt -ge $maxAttempts) {
            throw "Ollama n'a pas répondu après $maxAttempts tentatives : $($_.Exception.Message)"
        }
        Start-Sleep -Seconds 5
    }
}

function Invoke-OllamaPull {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Model
    )

    Write-Host ""
    Write-Host "Téléchargement du modèle $Model..."

    $body = @{ model = $Model; stream = $false } | ConvertTo-Json -Compress

    Invoke-RestMethod `
        -Uri "$ollamaUrl/api/pull" `
        -Method Post `
        -ContentType "application/json; charset=utf-8" `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -TimeoutSec 1800 |
        Out-Null

    Write-Host "Modèle $Model disponible."
}

Invoke-OllamaPull -Model $embeddingModel
Invoke-OllamaPull -Model $baseModel

Write-Host ""
Write-Host "Création du modèle $modelName à partir de $modelfilePath..."

if (-not (Test-Path $modelfilePath)) {
    throw "Modelfile introuvable : $modelfilePath"
}

$modelfileContent = Get-Content -Path $modelfilePath -Raw -Encoding UTF8

$createBody = @{
    model = $modelName
    modelfile = $modelfileContent
    stream = $false
} | ConvertTo-Json -Compress

Invoke-RestMethod `
    -Uri "$ollamaUrl/api/create" `
    -Method Post `
    -ContentType "application/json; charset=utf-8" `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($createBody)) `
    -TimeoutSec 300 |
    Out-Null

Write-Host "Modèle $modelName créé."

Write-Host ""
Write-Host "Indexation de la documentation (RAG)..."
Write-Host ""

& (Join-Path $PSScriptRoot "index-knowledge.ps1")

Write-Host ""
Write-Host "========================================"
Write-Host "Initialisation Scalia terminée avec succès."
