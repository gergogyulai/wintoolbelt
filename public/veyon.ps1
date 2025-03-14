# Check if running as administrator at startup
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Exit immediately if not running as administrator
if (-not (Test-Admin)) {
    Write-Host "This script requires administrator privileges." -ForegroundColor Red
    Write-Host "Please right-click on the script file and select 'Run with PowerShell as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Configure Ctrl+C handling
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

# Add a simple trap for all terminating errors
trap {
    Write-Host "`nScript terminated: $_" -ForegroundColor Yellow
    exit
}

function Show-Menu {
    try {
        Clear-Host
        Write-Host "============================" -ForegroundColor Cyan
        Write-Host "     Veyon Service Manager" -ForegroundColor Cyan
        Write-Host "============================" -ForegroundColor Cyan
        Write-Host ""
        
        $options = @(
            @{Letter = "S"; Text = "Start VeyonService"},
            @{Letter = "T"; Text = "Stop VeyonService"},
            @{Letter = "E"; Text = "Enable VeyonService"},
            @{Letter = "D"; Text = "Disable VeyonService"},
            @{Letter = "X"; Text = "Exit"}
        )
        
        $currentSelection = 0
        
        while ($true) {
            Clear-Host
            Write-Host "============================" -ForegroundColor Cyan
            Write-Host "     Veyon Service Manager" -ForegroundColor Cyan
            Write-Host "============================" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Navigation options:" -ForegroundColor Yellow
            Write-Host "- Use arrow keys and press Enter" -ForegroundColor Yellow
            Write-Host "- Type a number (1-5)" -ForegroundColor Yellow
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
            
            # Get key input
            $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            
            # Handle different types of input
            # Arrow key navigation
            if ($key.VirtualKeyCode -eq 38) { # Up arrow
                if ($currentSelection -gt 0) {
                    $currentSelection--
                }
            }
            elseif ($key.VirtualKeyCode -eq 40) { # Down arrow
                if ($currentSelection -lt ($options.Count - 1)) {
                    $currentSelection++
                }
            }
            elseif ($key.VirtualKeyCode -eq 13) { # Enter
                return $currentSelection
            }
            # Number keys 1-5
            elseif ($key.VirtualKeyCode -ge 49 -and $key.VirtualKeyCode -le 53) { # 1-5
                $selection = $key.VirtualKeyCode - 49
                return $selection
            }
            # Letter shortcuts
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

function Perform-ServiceAction {
    param (
        [int]$selection
    )
    
    try {
        switch ($selection) {
            0 { # Start
                try {
                    Write-Host "Starting VeyonService..." -ForegroundColor Cyan
                    Start-Service -Name "VeyonService" -ErrorAction Stop
                    Write-Host "VeyonService started successfully!" -ForegroundColor Green
                } catch {
                    Write-Host "Error starting VeyonService: $_" -ForegroundColor Red
                }
            }
            1 { # Stop
                try {
                    Write-Host "Stopping VeyonService..." -ForegroundColor Cyan
                    Stop-Service -Name "VeyonService" -ErrorAction Stop
                    Write-Host "VeyonService stopped successfully!" -ForegroundColor Green
                } catch {
                    Write-Host "Error stopping VeyonService: $_" -ForegroundColor Red
                }
            }
            2 { # Enable
                try {
                    Write-Host "Enabling VeyonService..." -ForegroundColor Cyan
                    Set-Service -Name "VeyonService" -StartupType Automatic -ErrorAction Stop
                    Write-Host "VeyonService enabled successfully!" -ForegroundColor Green
                } catch {
                    Write-Host "Error enabling VeyonService: $_" -ForegroundColor Red
                }
            }
            3 { # Disable
                try {
                    Write-Host "Disabling VeyonService..." -ForegroundColor Cyan
                    Set-Service -Name "VeyonService" -StartupType Disabled -ErrorAction Stop
                    Write-Host "VeyonService disabled successfully!" -ForegroundColor Green
                } catch {
                    Write-Host "Error disabling VeyonService: $_" -ForegroundColor Red
                }
            }
            4 { # Exit
                return $false
            }
        }
        
        if ($selection -ne 4) {
            Write-Host ""
            Write-Host "Press any key to continue..." -ForegroundColor Yellow
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        
        return ($selection -ne 4)
    }
    catch {
        Write-Host "Error performing service action: $_" -ForegroundColor Red
        return $true
    }
}

# Main program loop
try {
    $continue = $true
    while ($continue) {
        $selection = Show-Menu
        $continue = Perform-ServiceAction -selection $selection
    }
}
catch {
    Write-Host "An unexpected error occurred: $_" -ForegroundColor Red
}
finally {
    # Clean up
    [Console]::TreatControlCAsInput = $true
}
