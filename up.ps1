$currentDirectory = Get-Location
$PORT = 80

function Wait-ForService {
    param (
        [string]$url,
        [int]$maxRetries = 30,
        [int]$delay = 5
    )
    $retryCount = 0
    Write-Output "Waiting for the service at $url to start..."
    while ($retryCount -lt $maxRetries) {
        try {
            $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
            if ($response.StatusCode -eq 200) {
                Write-Output "Service is up and running at $url."
                Start-Process $url
                return $true
            }
        } catch {
            Write-Output "Service not yet available. Retrying in $delay seconds... ($retryCount/$maxRetries)"
        }
        Start-Sleep -Seconds $delay
        $retryCount++
    }
    Write-Output "Failed to access the service after $maxRetries attempts."
    return $false
}

function Supports-ARM {
    # This function checks if the system supports ARM architecture
    $cpuInfo = Get-WmiObject Win32_Processor
    foreach ($cpu in $cpuInfo) {
        if ($cpu.Name -like "*ARM*" -or $cpu.Caption -like "*ARM*") {
            return $true
        }
    }
    return $false
}

# Navigate to the directory containing the docker-compose.yml file
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptDirectory

# Start Docker Compose services based on the processor architecture
if (Supports-ARM) {
    Write-Output "ARM architecture detected. Starting Docker Compose services with docker-compose-ARM.yml..."
    docker-compose -f docker-compose-ARM.yml up -d
} else {
    Write-Output "Starting Docker Compose services with docker-compose.yml..."
    docker-compose up -d
}

# Open DSL directory in Visual Studio Code
$dslPath = Join-Path $currentDirectory "dsl"
if (Test-Path -Path $dslPath) {
    Set-Location -Path $dslPath
    code .
    Write-Output "Opened Visual Studio Code in '$dslPath'."
} else {
    Write-Output "DSL directory '$dslPath' not found."
}

# Return to the initial directory
Set-Location -Path $currentDirectory

# Open mkdocs/docs directory in Visual Studio Code 
$mkdocsDocsPath = Join-Path $currentDirectory "mkdocs/docs" 
if (Test-Path -Path $mkdocsDocsPath) { 
    Set-Location -Path $mkdocsDocsPath 
    code . 
    Write-Output "Opened Visual Studio Code in '$mkdocsDocsPath'." 
} else { 
    Write-Output "mkdocs/docs directory '$mkdocsDocsPath' not found." } 
    
# Return to the initial directory 
Set-Location -Path $currentDirectory

# Wait for the site to start and open it
$url = "http://localhost:$PORT"
Wait-ForService -url $url
