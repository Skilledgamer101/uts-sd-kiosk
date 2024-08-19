$assignedAccessConfiguration = @"

<?xml version="1.0" encoding="utf-8"?>
<AssignedAccessConfiguration xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://schemas.microsoft.com/AssignedAccess/2017/config" xmlns:default="http://schemas.microsoft.com/AssignedAccess/2017/config" xmlns:rs5="http://schemas.microsoft.com/AssignedAccess/201810/config" xmlns:v3="http://schemas.microsoft.com/AssignedAccess/2020/config" xmlns:v5="http://schemas.microsoft.com/AssignedAccess/2022/config">
  <Profiles>
    <Profile Id="{2ccf36b4-1ff7-4327-9efe-b3a09d07fa98}">
      <AllAppsList>
        <AllowedApps>
          <App AppUserModelId="Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" /> 
          <App AppUserModelId="Microsoft.WindowsNotepad_8wekyb3d8bbwe!App" /> 
          <App AppUserModelId="Microsoft.Paint_8wekyb3d8bbwe!App" /> 
          <App AppUserModelId="windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" /> 
          <App DesktopAppPath="C:\Windows\System32\notepad.exe" />
          <App DesktopAppPath="%windir%\explorer.exe" />
          <App AppUserModelId="%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" />
          <App DesktopAppPath="C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE" />
          <App DesktopAppPath="C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE" />
          <App DesktopAppPath="C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE" />
          <App DesktopAppPath="C:\Program Files\Google\Chrome\Application\chrome.exe" />
          <App DesktopAppPath="C:\Program Files\Mozilla Firefox\private_browsing.exe" />
          <App DesktopAppPath="C:\Program Files\Mozilla Firefox\firefox.exe" />
          <App DesktopAppPath="C:\Windows\System32\taskschd.msc" />
          <App DesktopAppPath="C:\Windows\System32\mmc.exe" />
          <App DesktopAppPath="C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" />
          <App DesktopAppPath="C:\Program Files\Zoom\bin\Zoom.exe" />
          <App DesktopAppPath="C:\Program Files (x86)\Cisco\Cisco AnyConnect Secure Mobility Client\vpnui.exe" />
          <App DesktopAppPath="C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE" />
          <App AppUserModelId="MSTeams_8wekyb3d8bbwe!MSTeams" />
          
          

        </AllowedApps>
      </AllAppsList>
      <rs5:FileExplorerNamespaceRestrictions>
        <rs5:AllowedNamespace Name="Downloads" />
        <v3:AllowRemovableDrives />
      </rs5:FileExplorerNamespaceRestrictions>
      <v5:StartPins><![CDATA[{
          "pinnedList":[
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\explorer.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Microsoft Edge.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Word.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Excel.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\PowerPoint.lnk"},
            {"packagedAppId":"windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel"},
            {"packagedAppId":"Microsoft.WindowsCalculator_8wekyb3d8bbwe!App"},
            {"packagedAppId":"Microsoft.WindowsNotepad_8wekyb3d8bbwe!App"},
            {"packagedAppId":"Microsoft.Paint_8wekyb3d8bbwe!App"},
            {"packagedAppId":"MSTeams_8wekyb3d8bbwe!MSTeams"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Google Chrome.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Firefox Private Browsing.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Zoom\\Zoom Workplace.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Cisco\\Cisco AnyConnect Secure Mobility Client.lnk"},
            {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Outlook.lnk"}
          ]
        }]]></v5:StartPins>
      <Taskbar ShowTaskbar="true" />
      <v5:TaskbarLayout><![CDATA[
        <?xml version="1.0" encoding="utf-8"?>
        <LayoutModificationTemplate
          xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
          xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
          xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
          xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
          Version="1">
        <CustomTaskbarLayoutCollection PinListPlacement="Replace">
          <defaultlayout:TaskbarLayout>
          <taskbar:TaskbarPinList>
            <taskbar:DesktopApp DesktopApplicationLinkPath="#leaveempty"/>
          </taskbar:TaskbarPinList>
          </defaultlayout:TaskbarLayout>
        </CustomTaskbarLayoutCollection>
        </LayoutModificationTemplate>
        ]]>
      </v5:TaskbarLayout>
    </Profile>
  </Profiles>
  <Configs>
    <Config>
      <AutoLogonAccount rs5:DisplayName="RHPCS Kiosk" />
      <DefaultProfile Id="{2ccf36b4-1ff7-4327-9efe-b3a09d07fa98}" />
    </Config>
  </Configs>
</AssignedAccessConfiguration>

"@

$namespaceName="root\cimv2\mdm\dmmap"
$className="MDM_AssignedAccess"
$obj = Get-CimInstance -Namespace $namespaceName -ClassName $className
$obj.Configuration = [System.Net.WebUtility]::HtmlEncode($assignedAccessConfiguration)
$obj = Set-CimInstance -CimInstance $obj -ErrorVariable cimSetError -ErrorAction SilentlyContinue
if($cimSetError) {
    Write-Output "An ERROR occurred. Displaying error record and attempting to retrieve error logs...`n"
    Write-Error -ErrorRecord $cimSetError[0]

    $timeout = New-TimeSpan -Seconds 30
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    do{
        $events = Get-WinEvent -FilterHashtable $eventLogFilterHashTable -ErrorAction Ignore
    } until ($events.Count -or $stopwatch.Elapsed -gt $timeout) # wait for the log to be available

    if($events.Count) {
        $events | ForEach-Object {
            Write-Output "$($_.TimeCreated) [$($_.LevelDisplayName.ToUpper())] $($_.Message -replace "`n|`r")"
        }
    } else {
        Write-Warning "Timed-out attempting to retrieve event logs..."
    }

    Exit 1
}

Write-Output "Successfully applied Assigned Access configuration"
