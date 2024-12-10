$currentDirectory = Get-Location
$PORT = 8080

# Navigate to the directory containing the docker-compose.yml file
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $scriptDirectory

# Run the Docker Compose file
docker-compose up -d

# Navigate to the working
$dslPath = Join-Path $currentDirectory "\dsl"
cd $dslPath
# Open Visual Studio Code in the current directory
code .

cd $currentDirectory

# Check if the site is running before opening the URL
$url = "http://localhost:$PORT"
$maxRetries = 30  # Max number of retries
$delay = 5        # Delay in seconds between retries
$retryCount = 0

Write-Output "Waiting for the site to start..."
while ($retryCount -lt $maxRetries) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
        if ($response.StatusCode -eq 200) {
            Write-Output "Site is up and running."
            Start-Process $url
            Write-Output "You can access the site at $url"
            break
        }
    } catch {
        Write-Output "Site is not yet available. Retrying in $delay seconds..."
        Start-Sleep -Seconds $delay
        $retryCount++
    }
}

if ($retryCount -eq $maxRetries) {
    Write-Output "Failed to access the site after multiple attempts."
}
