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

# Stop Docker Compose services based on the processor architecture
if (Supports-ARM) {
    Write-Output "ARM architecture detected. Stopping Docker Compose services with docker-compose-ARM.yml..."
    docker-compose -f docker-compose-ARM.yml down
} else {
    Write-Output "Stopping Docker Compose services with docker-compose.yml..."
    docker-compose down
}

# Create the backup folder
Create-FolderIfNotExists -folderPath $backupFolder

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

# Return to the initial directory
Set-Location -Path $currentDirectory
