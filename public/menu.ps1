# Check if running as administrator
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host "This script requires administrator privileges." -ForegroundColor Red
    Write-Host "Please right-click on the script file and select 'Run with PowerShell as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

trap {
    Write-Host "`nScript terminated: $_" -ForegroundColor Yellow
    exit
}

function Show-Menu {
    try {
        $options = @(
            @{Letter = "W"; Text = "Wipe Tools"},
            @{Letter = "V"; Text = "Veyon Service Manager"},
            @{Letter = "C"; Text = "Configuration Tools"},
            @{Letter = "X"; Text = "Exit"}
        )
        
        $currentSelection = 0
        
        while ($true) {
            Clear-Host
            Write-Host "============================" -ForegroundColor Cyan
            Write-Host "     Windows ToolBelt" -ForegroundColor Cyan
            Write-Host "============================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Navigation options:" -ForegroundColor Yellow
            Write-Host "- Use arrow keys and press Enter" -ForegroundColor Yellow
            Write-Host "- Type a number (1-4)" -ForegroundColor Yellow
            Write-Host "- Press the highlighted letter" -ForegroundColor Yellow
            Write-Host "- Press Ctrl+C to exit anytime" -ForegroundColor Yellow
            Write-Host ""
            
            for ($i = 0; $i -lt $options.Count; $i++) {
                if ($i -eq $currentSelection) {
                    Write-Host " > $($i+1). [" -NoNewline -ForegroundColor Green
                    Write-Host "$($options[$i].Letter)" -NoNewline -ForegroundColor Magenta
                    Write-Host "] $($options[$i].Text)" -ForegroundColor Green
                } else {
                    Write-Host "   $($i+1). [" -NoNewline
                    Write-Host "$($options[$i].Letter)" -NoNewline -ForegroundColor Magenta
                    Write-Host "] $($options[$i].Text)"
                }
            }
            
            $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            
            if ($key.VirtualKeyCode -eq 38) { # Up arrow
                if ($currentSelection -gt 0) { $currentSelection-- }
            }
            elseif ($key.VirtualKeyCode -eq 40) { # Down arrow
                if ($currentSelection -lt ($options.Count - 1)) { $currentSelection++ }
            }
            elseif ($key.VirtualKeyCode -eq 13) { # Enter
                return $currentSelection
            }
            elseif ($key.VirtualKeyCode -ge 49 -and $key.VirtualKeyCode -le 52) { # 1-4
                return ($key.VirtualKeyCode - 49)
            }
            else {
                $keyChar = $key.Character.ToString().ToUpper()
                for ($i = 0; $i -lt $options.Count; $i++) {
                    if ($options[$i].Letter -eq $keyChar) {
                        return $i
                    }
                }
            }
        }
    }
    catch {
        Write-Host "An unexpected error occurred: $_" -ForegroundColor Red
    }
}

function Invoke-Tool {
    param (
        [int]$selection
    )
    
    try {
        switch ($selection) {
            0 { # Wipe
                Write-Host "Launching Wipe Tools..." -ForegroundColor Cyan
                Invoke-RestMethod https://winwipe.gergo.cc/wipe | Invoke-Expression
            }
            1 { # Veyon
                Write-Host "Launching Veyon Manager..." -ForegroundColor Cyan
                Invoke-RestMethod https://winwipe.gergo.cc/veyon | Invoke-Expression
            }
            2 { # Configuration
                Write-Host "Work in progress, not yet available" -ForegroundColor Cyan
            }
            3 { # Exit
                return $false
            }
        }
        
        if ($selection -ne 3) {
            Write-Host ""
            Write-Host "Press any key to return to main menu..." -ForegroundColor Yellow
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        
        return ($selection -ne 3)
    }
    catch {
        Write-Host "Error launching tool: $_" -ForegroundColor Red
        Write-Host "Press any key to continue..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        return $true
    }
}

# Main program loop
try {
    $continue = $true
    while ($continue) {
        $selection = Show-Menu
        $continue = Invoke-Tool -selection $selection
    }
}
catch {
    Write-Host "An unexpected error occurred: $_" -ForegroundColor Red
}
finally {
    [Console]::TreatControlCAsInput = $true
}
