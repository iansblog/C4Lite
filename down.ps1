 $currentDirectory = Get-Location

# Define the date format for the backup folder
$date = Get-Date -Format "dd-MMM-yyyy-HH-mm"
$backupFolder = ".\Backup\$date"

# Create the backup folder
if (-Not (Test-Path -Path $backupFolder)) {
    New-Item -Path $backupFolder -ItemType Directory
    Write-Output "Backup directory '$backupFolder' created."
}

# Stop and remove the Docker Compose services
Write-Output "Stopping Docker Compose services..."
docker-compose down

# Backup files
$workspaceSdl = Join-Path $currentDirectory "dsl\workspace.dsl"
$workspaceJson = Join-Path $currentDirectory "dsl\workspace.json"

if (Test-Path -Path $workspaceSdl) {
    Copy-Item -Path $workspaceSdl -Destination $backupFolder
    Write-Output "workspace.dsl copied to '$backupFolder'."
}

if (Test-Path -Path $workspaceJson) {
    Copy-Item -Path $workspaceJson -Destination $backupFolder
    Write-Output "workspace.json copied to '$backupFolder'."
}

Write-Output "Backup completed. Files are stored in '$backupFolder'."
