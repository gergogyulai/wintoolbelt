# ██╗    ██╗██╗███╗   ██╗██╗    ██╗██╗██████╗ ███████╗
# ██║    ██║██║████╗  ██║██║    ██║██║██╔══██╗██╔════╝
# ██║ █╗ ██║██║██╔██╗ ██║██║ █╗ ██║██║██████╔╝█████╗  
# ██║███╗██║██║██║╚██╗██║██║███╗██║██║██╔═══╝ ██╔══╝  
# ╚███╔███╔╝██║██║ ╚████║╚███╔███╔╝██║██║     ███████╗
#  ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝╚═╝     ╚══════╝
# WARNING: This script will permanently delete data from your user account.
# Ensure you have backed up any important files before proceeding.

# Ask for confirmation
$confirmation = Read-Host "For the best results close everything before executing. Are you sure you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Operation cancelled."
    exit
}

$execconfirmation = Read-Host "WARNING: This script will permanently delete data from your user account. Are you sure you want to continue? (Y/N)"
if ($execconfirmation -ne "Y") {
    Write-Host "Operation cancelled."
    exit
}

# Define the current user's home directory
$UserProfile = $env:USERPROFILE

# ----- 1. Clean specified folders (Desktop, Documents, Downloads, Pictures, Music) -----
$foldersToClean = @("Desktop", "Documents", "Downloads", "Pictures", "Music")
foreach ($folder in $foldersToClean) {
    $folderPath = Join-Path $UserProfile $folder
    if (Test-Path $folderPath) {
        Write-Host "Cleaning contents of $folderPath..."
        # Remove all items (files and subdirectories) within the folder
        Remove-Item -Path (Join-Path $folderPath "*") -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Host "Folder not found: $folderPath"
    }
}

# ----- 2. Remove all files in the user's home directory -----
# (Files directly in the root that are not inside allowed folders)
Get-ChildItem -Path $UserProfile -File | ForEach-Object {
    Write-Host "Removing file: $($_.FullName)"
    Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
}

# ----- 3. Remove all directories in the user profile except the keep list -----
$keepFolders = @("Desktop", "Documents", "Downloads", "Pictures", "Music", "AppData")
Get-ChildItem -Path $UserProfile -Directory | ForEach-Object {
    if ($keepFolders -notcontains $_.Name) {
        Write-Host "Removing directory: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ----- 4. Remove all browser profiles -----

# -- Chrome profiles --
$chromeUserDataPath = Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data"
if (Test-Path $chromeUserDataPath) {
    Write-Host "Removing Chrome profiles in $chromeUserDataPath..."
    Get-ChildItem -Path $chromeUserDataPath -Directory | ForEach-Object {
        Write-Host "Removing Chrome profile folder: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "Chrome user data folder not found at $chromeUserDataPath"
}

# -- Firefox profiles --
$firefoxProfilesPath = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"
if (Test-Path $firefoxProfilesPath) {
    Write-Host "Removing Firefox profiles in $firefoxProfilesPath..."
    Get-ChildItem -Path $firefoxProfilesPath -Directory | ForEach-Object {
        Write-Host "Removing Firefox profile folder: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "Firefox profiles folder not found at $firefoxProfilesPath"
}

# -- Brave profiles --
$braveUserDataPath = Join-Path $env:LOCALAPPDATA "BraveSoftware\Brave-Browser\User Data"
if (Test-Path $braveUserDataPath) {
    Write-Host "Removing Brave profiles in $braveUserDataPath..."
    Get-ChildItem -Path $braveUserDataPath -Directory | ForEach-Object {
        Write-Host "Removing Brave profile folder: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "Brave user data folder not found at $braveUserDataPath"
}

# -- Edge profiles --
$edgeUserDataPath = Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data"
if (Test-Path $edgeUserDataPath) {
    Write-Host "Removing Edge profiles in $edgeUserDataPath..."
    Get-ChildItem -Path $edgeUserDataPath -Directory | ForEach-Object {
        Write-Host "Removing Edge profile folder: $($_.FullName)"
        Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Host "Edge user data folder not found at $edgeUserDataPath"
}

# ----- 5. Remove VS Code configuration -----

# Remove VS Code configuration from AppData (typically under %APPDATA%\Code)
$vscodeAppDataPath = Join-Path $env:APPDATA "Code"
if (Test-Path $vscodeAppDataPath) {
    Write-Host "Removing VS Code configuration folder: $vscodeAppDataPath"
    Remove-Item $vscodeAppDataPath -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "VS Code configuration folder not found at $vscodeAppDataPath"
}

# Optionally, remove the .vscode folder from the user profile (commonly used for extensions and settings)
$vscodeUserPath = Join-Path $UserProfile ".vscode"
if (Test-Path $vscodeUserPath) {
    Write-Host "Removing VS Code user folder: $vscodeUserPath"
    Remove-Item $vscodeUserPath -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "VS Code user folder not found at $vscodeUserPath"
}

Write-Host "Wiping process completed."
