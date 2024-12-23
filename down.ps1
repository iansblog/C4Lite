$currentDirectory = Get-Location

# Define the date format for the backup folder
$date = Get-Date -Format "dd-MMM-yyyy-HH-mm"
$backupFolder = ".\Backup\$date"

function Create-FolderIfNotExists {
    param (
        [string]$folderPath
    )
    if (-Not (Test-Path -Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory | Out-Null
        Write-Output "Backup directory '$folderPath' created."
    }
}

function Copy-FileIfExists {
    param (
        [string]$sourcePath,
        [string]$destinationPath
    )
    if (Test-Path -Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
        Write-Output "File or directory '$sourcePath' copied to '$destinationPath'."
    } else {
        Write-Output "File or directory '$sourcePath' not found. No backup created."
    }
}

# Create the backup folder
Create-FolderIfNotExists -folderPath $backupFolder

# Stop and remove the Docker Compose services
Write-Output "Stopping Docker Compose services..."
docker-compose down

# DSL Backup section
$DSLbackupFolder = ".\Backup\$date\DSL"
Create-FolderIfNotExists -folderPath $DSLbackupFolder

$workspaceSdl = Join-Path $currentDirectory "dsl\workspace.dsl"
$workspaceJson = Join-Path $currentDirectory "dsl\workspace.json"

Copy-FileIfExists -sourcePath $workspaceSdl -destinationPath $DSLbackupFolder
Copy-FileIfExists -sourcePath $workspaceJson -destinationPath $DSLbackupFolder

Write-Output "DSL Backup completed. Files are stored in '$DSLbackupFolder'."

# MkDocs Backup section
$mkdocsBackupFolder = ".\Backup\$date\mkdocs"
Create-FolderIfNotExists -folderPath $mkdocsBackupFolder

$mkdocsSource = Join-Path $currentDirectory "mkdocs"
Copy-FileIfExists -sourcePath $mkdocsSource -destinationPath $mkdocsBackupFolder

Write-Output "Backup completed. Files are stored in '$backupFolder'."
