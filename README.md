<a id="readme-top"></a>

<div align="center">

<h3 align="center">UTS SD Kiosk</h3>

  <p align="center">
    A fast and easy method to turn a regular PC into a secure kiosk for public use.
    <br />
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#additional-steps">Additional Steps</a></li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

![Kiosk Homepage Screen Shot][homepage-screenshot]
This project incorporates many features into a regular PC to make it secure enough for public use. It allows a (customizable) list of certain apps, opens browsers in Private mode by default, prevents access to files in the hard drive, wipes out all data on the computer if it is left idle for 15 minutes, and much more. It utilizes a combination of Microsoft's Assigned Access feature on Windows, custom PowerShell scripts in the background, and Group Policy changes.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* [![PowerShell][PowerShell-shield]][PowerShell-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

Requirements:
1. Windows 11 PC
2. An account with Administrative access on the PC

### Prerequisites

Some packages need to be installed first.

Open PowerShell as an *Administrator*.

* PowerShell
  ```PowerShell
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted
  Install-PackageProvider -Name NuGet -Force
  Install-Module -Name GCDialog -Force -Scope AllUsers
  ```

### Installation

1. Clone the repo:

* Command Prompt
   ```sh
   git clone https://github.com/Skilledgamer101/uts-sd-kiosk.git
   ```
2. Run the following command under *Administrator* Command Prompt:

* Command Prompt
   ```sh
   cd path\to\cloned\repo
   psexec.exe -i -s powershell.exe
   ```
3. Click 'Accept' in the popup window.

> Note: Before performing the next step, take a look at the `setup_kiosk.ps1` file in this repo. Make sure the paths match with the ones on your PC, and feel free to add/remove any paths.

4. A new window should open titled 'PsExec.exe'. Enter the following commands in it:

* PowerShell
  ```PowerShell
  cd path\to\cloned\repo
  .\setup_kiosk.ps1
   ```

5. You should receive a message like this:
  ```
  Successfully applied Assigned Access Configuration.
  ```

> Note: For the next step, you will have to change the "Arguments" tag (at the very bottom) in the `Clear Everything.xml` file to point to the path of the `clear_everything.ps1` file in this repo.

6. Set the `clear_everything.ps1` file to run in the background:
  * PowerShell
  ```PowerShell
  Register-ScheduledTask -Xml (Get-Content -Path "C:\path\to\task.xml" -Raw) -TaskName "Clear Everything"
  ```
> Note: The Task Scheduler application can be used to set the task as well ('Import Task' > Select the `Clear Everything.xml` file).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ADDITIONAL STEPS FOR EXTRA SECURITY-->
## Additional Steps
1. Modify Edge and Chrome shortcuts to make them open in Private mode by default:
  * PowerShell
  ```PowerShell
  .\UpdateShortcut.ps1 -ShortcutPath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -NewTargetPath "C:\path\to\msedge.exe" -Arguments "--inprivate"
  .\UpdateShortcut.ps1 -ShortcutPath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" -NewTargetPath "C:\path\to\chrome.exe" -Arguments "--incognito"
  ```
2. Create new File Explorer shortcut in Start Menu
  * PowerShell
  ```PowerShell
  .\UpdateShortcut.ps1 -ShortcutPath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\explorer.lnk" -NewTargetPath "%WINDIR%\explorer.exe"
  ```
3. Restrict access to hard drive <br /> <br />
  a. Press Win + R. Type mmc. <br />
  b. File > Add/Remove Snap-In > Group Policy Object Editor > Browse > kioskUser0 > Finish <br />
  c. User Configuration > Administrative Templates > Windows Components > File Explorer > Prevent access to drives from My Computer <br />
  d. Select whichever drives you would like to restrict access to <br />

4. (Optional) Set Shared Computer Activation for Microsoft Office products.
* Command Prompt
```sh
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" /v SharedComputerLicensing /t REG_SZ /d "1" /f
```

<!-- USAGE EXAMPLES -->
## Usage

### Specific Allowed Apps on Homepage
![Kiosk Apps Screen Shot][apps-screenshot]

### Trying to Access A File in Hard Drive
![File Explorer Screen Shot][explorer-screenshot]

### Trying to Access an App Not on Allowed List
![Blocked App Screen Shot][blocked-app-screenshot]

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Mansoor Lunawadi - mansoorlunawadi@yahoo.ca

Project Link: [https://github.com/Skilledgamer101/uts-sd-kiosk](https://github.com/Skilledgamer101/uts-sd-kiosk)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [GCDialog](https://github.com/grantcarthew/ps-gcpowershell) <br />
GCDialog was used to display a countdown timer dialog in the `clear_everything.ps1` file.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[PowerShell-shield]:https://img.shields.io/badge/PowerShell-blue.svg?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbDpzcGFjZT0icHJlc2VydmUiIHZpZXdCb3g9IjAgMCAxMjggMTI4Ij48bGluZWFyR3JhZGllbnQgaWQ9ImEiIHgxPSI5Ni4zMDYiIHgyPSIyNS40NTQiIHkxPSIzNS4xNDQiIHkyPSI5OC40MzEiIGdyYWRpZW50VHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgLTEgMCAxMjgpIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHN0b3Agb2Zmc2V0PSIwIiBzdG9wLWNvbG9yPSIjYTljOGZmIi8+PHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjYzdlNmZmIi8+PC9saW5lYXJHcmFkaWVudD48cGF0aCBmaWxsPSJ1cmwoI2EpIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik03LjIgMTEwLjVjLTEuNyAwLTMuMS0uNy00LjEtMS45LTEtMS4yLTEuMy0yLjktLjktNC42bDE4LjYtODAuNWMuOC0zLjQgNC02IDcuNC02aDkyLjZjMS43IDAgMy4xLjcgNC4xIDEuOSAxIDEuMiAxLjMgMi45LjkgNC42bC0xOC42IDgwLjVjLS44IDMuNC00IDYtNy40IDZINy4yeiIgY2xpcC1ydWxlPSJldmVub2RkIiBvcGFjaXR5PSIuOCIvPjxsaW5lYXJHcmFkaWVudCBpZD0iYiIgeDE9IjI1LjMzNiIgeDI9Ijk0LjU2OSIgeTE9Ijk4LjMzIiB5Mj0iMzYuODQ3IiBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIC0xIDAgMTI4KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIG9mZnNldD0iMCIgc3RvcC1jb2xvcj0iIzJkNDY2NCIvPjxzdG9wIG9mZnNldD0iLjE2OSIgc3RvcC1jb2xvcj0iIzI5NDA1YiIvPjxzdG9wIG9mZnNldD0iLjQ0NSIgc3RvcC1jb2xvcj0iIzFlMmY0MyIvPjxzdG9wIG9mZnNldD0iLjc5IiBzdG9wLWNvbG9yPSIjMGMxMzFiIi8+PHN0b3Agb2Zmc2V0PSIxIi8+PC9saW5lYXJHcmFkaWVudD48cGF0aCBmaWxsPSJ1cmwoI2IpIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMjAuMyAxOC41SDI4LjVjLTIuOSAwLTUuNyAyLjMtNi40IDUuMkwzLjcgMTA0LjNjLS43IDIuOSAxLjEgNS4yIDQgNS4yaDkxLjhjMi45IDAgNS43LTIuMyA2LjQtNS4ybDE4LjQtODAuNWMuNy0yLjktMS4xLTUuMy00LTUuM3oiIGNsaXAtcnVsZT0iZXZlbm9kZCIvPjxwYXRoIGZpbGw9IiMyQzU1OTEiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZD0iTTY0LjIgODguM2gyMi4zYzIuNiAwIDQuNyAyLjIgNC43IDQuOXMtMi4xIDQuOS00LjcgNC45SDY0LjJjLTIuNiAwLTQuNy0yLjItNC43LTQuOXMyLjEtNC45IDQuNy00Ljl6TTc4LjcgNjYuNWMtLjQuOC0xLjIgMS42LTIuNiAyLjZMMzQuNiA5OC45Yy0yLjMgMS42LTUuNSAxLTcuMy0xLjQtMS43LTIuNC0xLjMtNS43LjktNy4zbDM3LjQtMjcuMXYtLjZsLTIzLjUtMjVjLTEuOS0yLTEuNy01LjMuNC03LjQgMi4yLTIgNS41LTIgNy40IDBsMjguMiAzMGMxLjcgMS45IDEuOCA0LjUuNiA2LjR6IiBjbGlwLXJ1bGU9ImV2ZW5vZGQiLz48cGF0aCBmaWxsPSIjRkZGIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik03Ny42IDY1LjVjLS40LjgtMS4yIDEuNi0yLjYgMi42TDMzLjYgOTcuOWMtMi4zIDEuNi01LjUgMS03LjMtMS40LTEuNy0yLjQtMS4zLTUuNy45LTcuM2wzNy40LTI3LjF2LS42bC0yMy41LTI1Yy0xLjktMi0xLjctNS4zLjQtNy40IDIuMi0yIDUuNS0yIDcuNCAwbDI4LjIgMzBjMS43IDEuOCAxLjggNC40LjUgNi40ek02My41IDg3LjhoMjIuM2MyLjYgMCA0LjcgMi4xIDQuNyA0LjYgMCAyLjYtMi4xIDQuNi00LjcgNC42SDYzLjVjLTIuNiAwLTQuNy0yLjEtNC43LTQuNiAwLTIuNiAyLjEtNC42IDQuNy00LjZ6IiBjbGlwLXJ1bGU9ImV2ZW5vZGQiLz48L3N2Zz4K
[PowerShell-logo]:https://icon.icepanel.io/Technology/svg/Powershell.svg
[PowerShell-url]:https://learn.microsoft.com/en-us/powershell/

[homepage-screenshot]: images/homepage.png
[apps-screenshot]: images/apps.png
[explorer-screenshot]: images/explorer.png
[blocked-app-screenshot]: images/blocked-app.png
