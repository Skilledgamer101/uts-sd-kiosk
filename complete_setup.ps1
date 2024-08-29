<#
    .SYNOPSIS
    Sets up kiosk account on PC

    .DESCRIPTION
    Sets Assigned Access configuration and Group Policy changes to create a restricted and safe user experience for public user

#>

# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

###############################################################################################################################################################################
### Self-Elevate Script
###############################################################################################################################################################################

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-ExecutionPolicy Unrestricted -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

if ((Get-ExecutionPolicy -Scope Process) -ne 'Unrestricted') {
    $CommandLine = "-ExecutionPolicy Unrestricted -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
    Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
    Exit
}

Start-Transcript

###############################################################################################################################################################################
### Install Chocolatey
###############################################################################################################################################################################

$currProtocol = [Net.ServicePointManager]::SecurityProtocol
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$stopWatch = Measure-Command -Expression {
    if (-not (Test-Path "$($env:ProgramData)\chocolatey\bin\choco.exe")) {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')) -Verbose | Out-Host

    }
}
Write-Host "Chocolatey install completed in $($stopWatch.TotalSeconds) seconds"

###############################################################################################################################################################################
### Install Git, NuGet, GCDialog
###############################################################################################################################################################################

Write-Host "Installing Dependencies"
$installerName = "$($env:SystemRoot)\System32\WindowsPowerShell\v1.0\powershell.exe" # .exe or .msi etc here. 
$silentConfig = "-Command `"& {
    Install-PackageProvider -Name NuGet -Force;
    Install-Module -Name GCDialog -Force -Scope AllUsers;
    choco install -y git;
}`""

$stopWatch = Measure-Command -Expression {

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "$installerName"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = $silentConfig

    Write-Host 'Installing from installer:'$pinfo.FileName 
    Write-Host 'Installing with switches:'$pinfo.Arguments 

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $pinfo
    $process.Start()
    Write-Host 'Process ID During Install:'$process.Id
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    Write-Host "ExitCode: "$process.ExitCode
    $process.WaitForExit()
    Write-Host "-------------------------------------------------------------------"
    if ($process.ExitCode -gt 0) {
        Write-Host "STANDARD ERROR: $stderr"
    }
    else {
        Write-Host "STANDARD OUTPUT: $stdout"
    }
    Write-Host "------------------------------------------------------------------"
}

Write-Host "Dependency install completed in $($stopWatch.TotalSeconds) seconds"

###############################################################################################################################################################################
### Create Chocolatey Auto Update
###############################################################################################################################################################################

Write-Host "Creating AutoUpdate Tasks"
$updateArgs = "-Command `"&{choco update -y all}`""
$powerSh = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$action = New-ScheduledTaskAction -Execute $powerSh -Argument $updateArgs
$trigger = New-ScheduledTaskTrigger -DaysOfWeek Tuesday -WeeksInterval 1 -Weekly -At 7am
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest -LogonType ServiceAccount
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun -MultipleInstances Queue -ExecutionTimeLimit (New-TimeSpan -Minutes 60)
$deploymentType = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
Register-ScheduledTask -Force -TaskName "Update" -TaskPath "\Chocolatey\" -InputObject $deploymentType

###############################################################################################################################################################################
### Clone Repo
###############################################################################################################################################################################

Write-Host "Cloning git kiosk repo"
git clone https://github.com/Skilledgamer101/uts-sd-kiosk.git
Write-Host "Cloned git kiosk repo"
Set-Location uts-sd-kiosk
Write-Host "Currently in location" $PWD

# Move clear_everything.ps1 file to Kiosk Scripts directory so kioskUser0 can access it
New-Item -Path "C:\Kiosk Scripts" -ItemType Directory
Move-Item -Path "$PWD\clear_everything.ps1" -Destination "C:\Kiosk Scripts"

# Set Read & Execute permissions for kioskUser0
$destinationFile = "C:\Kiosk Scripts\clear_everything.ps1"
$acl = Get-Acl $destinationFile
$permission = "$env:COMPUTERNAME\kioskUser0","ReadAndExecute","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)
$acl.SetAccessRule($accessRule)
Set-Acl -Path $destinationFile -AclObject $acl

###############################################################################################################################################################################
### Set Assigned Access
###############################################################################################################################################################################

$scriptPath = "$PWD\setup_kiosk.ps1"

Write-Host "Setting Up Assigned Access"

$installerName = "$PWD\PSEXEC.EXE"
$silentConfig = "-i -s powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

$stopWatch = Measure-Command -Expression {

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = $installerName
    $pinfo.Arguments = $silentConfig
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.CreateNoWindow = $true

    Write-Host 'Using PsExec:' $pinfo.FileName 
    Write-Host 'Arguments:' $pinfo.Arguments 

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $pinfo
    $process.Start()
    Write-Host 'Process ID During Install:' $process.Id

    # Capture output and errors
    $stdout = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()

    $process.WaitForExit()

    Write-Host "ExitCode: " $process.ExitCode
    Write-Host "-------------------------------------------------------------------"
    if ($process.ExitCode -gt 0) {
        Write-Host "ERROR in Assigned Access Setup! Check the setup_kiosk.ps1 file!"
        Write-Host "STANDARD ERROR:"
        Write-Host $stderr
        exit 1
    }
    else {
        Write-Host "Assigned Access Setup Successful!"
        Write-Host "STANDARD OUTPUT:"
        Write-Host $stdout
        
    }
    Write-Host "------------------------------------------------------------------"
}

Write-Host "Assigned Access setup completed in $($stopWatch.TotalSeconds) seconds"

###############################################################################################################################################################################
### Set Clear Everything BG Task
###############################################################################################################################################################################
Write-Host "-------------------------------------------------------------------"
Write-Host "Setting clear everything task"
Write-Host "Updating XML file"
# Define the path to your XML file
$xmlPath = "$PWD\Clear Everything.xml"
$scriptPath = "C:\Kiosk Scripts\clear_everything.ps1"

# Load the XML file
[xml]$xmlContent = Get-Content -Path $xmlPath

# Define the new values
$newArguments = "-file `"$scriptPath`" -WindowStyle Hidden"

# Get the new UserId value for the kiosk account using Get-LocalUser
$user = Get-LocalUser -Name "kioskUser0"
$userId = $user.SID.Value

# Update the <Arguments> element
$xmlContent.Task.Actions.Exec.Arguments = $newArguments

# Update the <UserId> element
$xmlContent.Task.Principals.Principal.UserId = $userId

# Save the modified XML content back to the file
$xmlContent.Save($xmlPath)

Write-Host "XML file updated successfully."
Write-Host "Registering clear everything scheduled task."
Register-ScheduledTask -Xml (Get-Content -Path "$PWD\Clear Everything.xml" -Raw) -TaskName "Clear Everything"
Write-Host "Registered clear everything scheduled task."
Write-Host "-------------------------------------------------------------------"

###############################################################################################################################################################################
### Set Shortcuts
###############################################################################################################################################################################

Write-Host "-------------------------------------------------------------------"
Write-Host "Setting Browser Shortcuts to Private Mode and Alternate File Explorer Shortcut"

& ".\UpdateShortcut.ps1" -ShortcutPath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -NewTargetPath "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" -Arguments "https://uts.mcmaster.ca --inprivate" | Out-Host
& ".\UpdateShortcut.ps1" -ShortcutPath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" -NewTargetPath "C:\Program Files\Google\Chrome\Application\chrome.exe" -Arguments "https://uts.mcmaster.ca --incognito" | Out-Host
& ".\UpdateShortcut.ps1" -ShortcutPath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\explorer.lnk" -NewTargetPath "%WINDIR%\explorer.exe" | Out-Host

Write-Host "Successfully Set Shortcuts"
Write-Host "-------------------------------------------------------------------"

###############################################################################################################################################################################
### Set Group Policies and Reg Values
###############################################################################################################################################################################

Write-Host "-------------------------------------------------------------------"
Write-Host "Setting Group Policies and Reg Values for kioskUser0"

# Define the path to the user's registry hive
$userRegistryPath = "C:\Users\kioskUser0"
$ntuserDatPath = Join-Path -Path $userRegistryPath -ChildPath "NTUSER.DAT"

# Load the user's registry hive
$hiveName = "KioskUser0Hive"
reg load "HKU\$hiveName" $ntuserDatPath

# Define registry paths and values
$regPath = "HKU\$hiveName\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"

# Create registry path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}

# Set the registry values using reg command

# No creating files in root folders
reg add "$regPath" /v "NoCreateRoot" /t REG_DWORD /d 1 /f

# Turn off update notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 2 /f

# Auto download updates and schedule their install outside office hours
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 4 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallDay /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v ScheduledInstallTime /t REG_DWORD /d 3 /f

# Device based licensing
reg add "HKLM\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" /v O365ProPlusRetail.DeviceBasedLicensing /t REG_SZ /d 1

# Stop Edge from auto creating shortcuts on desktop
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v CreateDesktopShortcutDefault /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v RemoveDesktopShortcutDefault /t REG_DWORD /d 1 /f

# Set PC to never sleep/turn off display
powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0
powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0

# Add uts sd accounts as local admins
Add-LocalGroupMember -Group "Administrators" -Member "ADS\utssdf1"
Add-LocalGroupMember -Group "Administrators" -Member "ADS\utssdf2"

# Unload the user's registry hive
reg unload "HKU\$hiveName"

# Inform the user to log off and log back in for changes to take effect
Write-Host "Registry settings for kioskUser0 have been updated. Please restart for the changes to take effect."

Write-Host "Successfully Set Group Policies and Reg Values"
Write-Host "-------------------------------------------------------------------"

Stop-Transcript
Start-Sleep -Seconds 60


    
