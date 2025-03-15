# Software Version Checker
# This script checks for installed software and their versions

function Get-SoftwareInfo {
    param (
        [string]$Name,
        [array]$Paths,
        [string]$Command,
        [string]$VersionArg
    )
    
    Write-Host "Checking for $Name..." -ForegroundColor Yellow
    
    # Check if software is installed via registry
    $regPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    
    $regResult = Get-ItemProperty $regPaths | Where-Object { $_.DisplayName -like "*$Name*" } | Select-Object DisplayName, DisplayVersion
    
    if ($regResult) {
        foreach ($item in $regResult) {
            Write-Host "  [Registry] $($item.DisplayName): $($item.DisplayVersion)" -ForegroundColor Green
        }
        return $true
    }
    
    # Check if executable exists in specified paths
    if ($Paths) {
        foreach ($path in $Paths) {
            if (Test-Path $path) {
                try {
                    if ($Command -and $VersionArg) {
                        $exePath = (Get-Command $Command -ErrorAction SilentlyContinue).Source
                        if ($exePath) {
                            $versionInfo = Invoke-Expression "$Command $VersionArg" -ErrorAction SilentlyContinue
                            Write-Host "  [Path] $Command: $versionInfo" -ForegroundColor Green
                            return $true
                        }
                    } else {
                        $fileInfo = Get-Item $path -ErrorAction SilentlyContinue
                        if ($fileInfo) {
                            $fileVersion = $fileInfo.VersionInfo.FileVersion
                            Write-Host "  [Path] $path: $fileVersion" -ForegroundColor Green
                            return $true
                        }
                    }
                } catch {
                    # Silently continue if there's an error
                }
            }
        }
    }
    
    # Try to check version using command if available
    if ($Command -and $VersionArg) {
        try {
            $commandExists = Get-Command $Command -ErrorAction SilentlyContinue
            if ($commandExists) {
                $versionInfo = Invoke-Expression "$Command $VersionArg" -ErrorAction SilentlyContinue
                Write-Host "  [Command] $Command: $versionInfo" -ForegroundColor Green
                return $true
            }
        } catch {
            # Silently continue if there's an error
        }
    }
    
    Write-Host "  Not found" -ForegroundColor Red
    return $false
}

# Clear screen
Clear-Host
Write-Host "SOFTWARE VERSION CHECKER" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan
Write-Host "Checking for installed software and their versions..." -ForegroundColor White
Write-Host ""

# Check Visual Studio
Get-SoftwareInfo -Name "Visual Studio" -Paths @(
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\devenv.exe",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Professional\Common7\IDE\devenv.exe",
    "${env:ProgramFiles(x86)}\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe",
    "${env:ProgramFiles}\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\devenv.exe",
    "${env:ProgramFiles}\Microsoft Visual Studio\2022\Professional\Common7\IDE\devenv.exe",
    "${env:ProgramFiles}\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
)

# Check Visual Studio Code
Get-SoftwareInfo -Name "Visual Studio Code" -Paths @(
    "${env:ProgramFiles}\Microsoft VS Code\Code.exe",
    "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe"
) -Command "code" -VersionArg "--version"

# Check Node.js
Get-SoftwareInfo -Name "Node.js" -Paths @(
    "${env:ProgramFiles}\nodejs\node.exe"
) -Command "node" -VersionArg "--version"

# Check Python 3
Get-SoftwareInfo -Name "Python 3" -Paths @(
    "${env:ProgramFiles}\Python3*\python.exe",
    "${env:LOCALAPPDATA}\Programs\Python\Python3*\python.exe"
) -Command "python" -VersionArg "--version"

# Check Google Chrome
Get-SoftwareInfo -Name "Google Chrome" -Paths @(
    "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
) -Command "chrome" -VersionArg "--version"

# Check Firefox
Get-SoftwareInfo -Name "Firefox" -Paths @(
    "${env:ProgramFiles}\Mozilla Firefox\firefox.exe",
    "${env:ProgramFiles(x86)}\Mozilla Firefox\firefox.exe"
) -Command "firefox" -VersionArg "--version"

# Check Brave
Get-SoftwareInfo -Name "Brave" -Paths @(
    "${env:ProgramFiles}\BraveSoftware\Brave-Browser\Application\brave.exe",
    "${env:LOCALAPPDATA}\BraveSoftware\Brave-Browser\Application\brave.exe"
) -Command "brave" -VersionArg "--version"

Write-Host ""
Write-Host "Scan complete!" -ForegroundColor Cyan
