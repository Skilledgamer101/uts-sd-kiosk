<#
.SYNOPSIS
  Displays a message box that will timeout after a set number of seconds.
.DESCRIPTION
  When calling this script it creates a message box with custom settings
  and displays the message. There is a countdown timer displayed on the
  message box to inform the user when the message will timeout.
 
  If the user presses Button1 then the text on Button1 is returned.
  If the user presses Button2 then the text on Button2 is returned.
  If the message box times out then the string TIMEOUT is returned.
 
  Type 'Get-Help Start-GCTimeoutDialog -Online' for extra information.
.PARAMETER Title
  The title of the message box.
 
  Default title is "Timeout".
.PARAMETER Message
  The message to display on the message box.
 
  Default message is "Timeout Message".
.PARAMETER Button1Text
The text to display on the left hand button.
This text is returned if the user clicks the button.
Button1 is the default accept button so ENTER will press Button1
 
Default Button1Text is "OK".
.PARAMETER Button2Text
  The text to display on the right hand button.
  This text is returned if the user clicks the button.
  Button2 is the default cancel button so ESC will press Button2
 
  Default Button2Text is "Cancel".
.PARAMETER Seconds
  The timeout value for the message box.
  If the message box is displayed for this amount of time then
  it will close and the string TIMEOUT will be returned.
 
  Default timeout value is 30 seconds.
.EXAMPLE
Start-GCTimeoutDialog -Title "Shutdown" -Message "This system will shutdown in 50 minutes." -Seconds 3000
#> 
function Start-GCTimeoutDialog {
    [CmdletBinding(HelpUri = 'https://github.com/grantcarthew/GCPowerShell')]
    [OutputType([String])]
    Param (
    [Parameter(Mandatory=$false)]
    [String]
    $Title = "Timeout",
  
    [Parameter(Mandatory=$false)]
    [String]
    $Message = "Timeout Message",
  
    [Parameter(Mandatory=$false)]
    [String]
    $Button1Text = "OK",
  
    [Parameter(Mandatory=$false)]
    [String]
    $Button2Text = "Cancel",
  
    [Parameter(Mandatory=$false)]
    [Int]
    $Seconds = 30
    )
    Write-Verbose -Message "Function initiated: $($MyInvocation.MyCommand)"
  
    Add-Type -AssemblyName PresentationCore
    Add-Type -AssemblyName PresentationFramework
  
    $window = $null
    $button1 = $null
    $button2 = $null
    $label = $null
    $timerTextBox = $null
    $timer = $null
    $timeLeft = New-TimeSpan -Seconds $Seconds
    $oneSec = New-TimeSpan -Seconds 1
  
    # Windows Form
    $window = New-Object -TypeName System.Windows.Window
    $window.Title = $Title
    $window.SizeToContent = "Height"
    $window.MinHeight = 160
    $window.Width = 310
    $window.WindowStartupLocation = "CenterScreen"
    $window.Topmost = $true
    $window.ShowInTaskbar = $false
    $window.ResizeMode = "NoResize"
  
    # Form Layout
    $grid = New-Object -TypeName System.Windows.Controls.Grid
    $topRow = New-Object -TypeName System.Windows.Controls.RowDefinition
    $topRow.Height = "*"
    $middleRow = New-Object -TypeName System.Windows.Controls.RowDefinition
    $middleRow.Height = "Auto"
    $bottomRow = New-Object -TypeName System.Windows.Controls.RowDefinition
    $bottomRow.Height = "Auto"
    $grid.RowDefinitions.Add($topRow)
    $grid.RowDefinitions.Add($middleRow)
    $grid.RowDefinitions.Add($bottomRow)
    $buttonStack = New-Object -TypeName System.Windows.Controls.StackPanel
    $buttonStack.Orientation = "Horizontal"
    $buttonStack.VerticalAlignment = "Bottom"
    $buttonStack.HorizontalAlignment = "Right"
    $buttonStack.Margin = "0,5,5,5"
    [System.Windows.Controls.Grid]::SetRow($buttonStack,2)
    $grid.AddChild($buttonStack)
    $window.AddChild($grid)
  
    # Button One
    $button1 = New-Object -TypeName System.Windows.Controls.Button
    $button1.MinHeight = 23
    $button1.MinWidth = 75
    $button1.VerticalAlignment = "Bottom"
    $button1.HorizontalAlignment = "Right"
    $button1.Margin = "0,0,0,0"
    $button1.Content = $Button1Text
    $button1.Add_Click({$window.Tag=$Button1Text;$window.Close()})
    $button1.IsDefault = $true
    $buttonStack.AddChild($button1)
  
    # Button Two
    $button2 = New-Object -TypeName System.Windows.Controls.Button
    $button2.MinHeight = 23
    $button2.MinWidth = 75
    $button2.VerticalAlignment = "Bottom"
    $button2.HorizontalAlignment = "Right"
    $button2.Margin = "8,0,0,0"
    $button2.Content = $Button2Text
    $button2.Add_Click({$window.Tag=$Button2Text;$window.Close()})
    $button2.IsCancel = $true
    $buttonStack.AddChild($button2)
  
    # Message Label
    $label = New-Object -TypeName System.Windows.Controls.Label
    $label.Margin = "3,0,0,0"
    $label.Content = $Message
    [System.Windows.Controls.Grid]::SetRow($label,0)
    $grid.AddChild($label)
  
    # Count Down Textbox
    $timerTextBox = New-Object -TypeName System.Windows.Controls.TextBox
    $timerTextBox.Width = "150"
    $timerTextBox.TextAlignment = "Center"
    $timerTextBox.IsReadOnly = $true
    $timerTextBox.Text = $timeLeft.ToString()
    [System.Windows.Controls.Grid]::SetRow($timerTextBox,1)
    $grid.AddChild($timerTextBox)
  
    # Windows Timer
    $timer = New-Object -TypeName System.Windows.Threading.DispatcherTimer
  
    $timer.Interval = New-TimeSpan -Seconds 1
    $timer.Tag = $timeLeft
    $timer.Add_Tick({
      $timer.Tag = $timer.Tag - $oneSec
      $timerTextBox.Text = $timer.Tag.ToString()
      if ($timer.Tag.TotalSeconds -lt 1) { $window.Tag = "TIMEOUT"; $window.Close() }
    })
    $timer.IsEnabled = $true
    $timer.Start()
  
    # Show
    $window.Activate() | Out-Null
    $window.ShowDialog() | Out-Null
    $window.Tag
    $timer.IsEnabled = $false
    $timer.Stop()
    $window = $null
    $button1 = $null
    $button2 = $null
    $label = $null
    $timerTextBox = $null
    $timer = $null
    $timeLeft = $null
    $oneSec = $null
  
    Write-Verbose -Message "Function completed: $($MyInvocation.MyCommand)"
}

# Function to close all open applications
function Close-AllApplications {
    # Get processes with a main window handle
    $processes = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and $_.Name -ne 'powershell' -and $_.Name -ne 'WindowsTerminal' }
    
    # Close main windows
    foreach ($process in $processes) {
        try {
            $process.CloseMainWindow() | Out-Null
            Write-Host "Sent close request to process: $($process.Name) with ID $($process.Id)"
        } catch {
            Write-Host "Failed to send close request to process: $($process.Name) with ID $($process.Id). Error: $_"
        }
    }
    
    # Wait for processes to close gracefully
    Start-Sleep -Seconds 5
    
    # Forcefully terminate any remaining processes
    foreach ($process in $processes) {
        if (!$process.HasExited) {
            try {
                Stop-Process -Id $process.Id -Force
                Write-Host "Forcefully terminated process: $($process.Name) with ID $($process.Id)"
            } catch {
                Write-Host "Failed to terminate process: $($process.Name) with ID $($process.Id). Error: $_"
            }
        }
    }
}



# Function to terminate all background processes for CACHE STORING APPS
# Chrome, Edge, Firefox. Word, Excel, Powerpoint, 

function Exit-AllBGProcesses {
    # List of process names to terminate
    $processNames = @("chrome", "msedge", "firefox", "winword", "excel", "powerpnt")

    foreach ($processName in $processNames) {
        $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue

        if ($processes) {
            foreach ($process in $processes) {
                try {
                    # Terminate each process
                    Stop-Process -Id $process.Id -Force
                    Write-Host "Terminated $processName process: $($process.Id)"
                } catch {
                    Write-Host "Failed to terminate $processName process: $($_.Exception.Message)"
                }
            }
        } else {
            Write-Host "No $processName processes found."
        }
    }
}



# Function to delete the user profile
function Remove-UserProfile {
    $userProfile = "$env:USERPROFILE"
    if (Test-Path $userProfile) {
        Remove-Item "$userProfile\*" -Recurse -Force
        Write-Host "User profile deleted."
    } else {
        Write-Host "User profile not found."
    }
}

# Function to clear Recycle Bin
function Remove-RecycleBin {
    Write-Host "Clearing Recycle Bin..."
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
}

# Function to restart the computer
function Restart-PC {
    Restart-Computer -Force
}

Start-Transcript

$response = Start-GCTimeoutDialog -Title "Restart" -Message "This system will restart in 30 seconds."
Write-Host($response)
if ($response -ne "Cancel") {
    Close-AllApplications
    Exit-AllBGProcesses
    Remove-UserProfile
    Remove-RecycleBin
    Restart-PC
}

Stop-Transcript
