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
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)
This project incorporates many features into a regular PC to make it secure enough for public use. It allows a (customizable) list of certain apps, opens browsers in Private mode by default, prevents access to files in C drive, and wipes out all data on the computer if it is left idle for 15 minutes.

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
4. A new window should open titled 'PsExec.exe'. Enter the following commands in it:

* PowerShell
  ```sh
  cd path\to\cloned\repo
  .\setup_kiosk.ps1
   ```
5. You should receive a message like this:
  ```
  Successfully applied Assigned Access Configuration.
  ```
6. Set the `clear_everything.ps1` file to run in the background:
  ```PowerShell
  Register-ScheduledTask -Xml (Get-Content -Path "C:\path\to\task.xml" -Raw) -TaskName "Clear Everything"
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ADDITIONAL STEPS FOR EXTRA SECURITY-->
## Additional Steps
1. Modify Edge and Chrome shortcuts to make them open in Private mode by default:
```

3. 

<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
    - [ ] Nested Feature

See the [open issues](https://github.com/Skilledgamer101/uts-sd-kiosk/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Top contributors:

<a href="https://github.com/Skilledgamer101/uts-sd-kiosk/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Skilledgamer101/uts-sd-kiosk" alt="contrib.rocks image" />
</a>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@twitter_handle](https://twitter.com/twitter_handle) - mansoorlunawadi@yahoo.ca

Project Link: [https://github.com/Skilledgamer101/uts-sd-kiosk](https://github.com/Skilledgamer101/uts-sd-kiosk)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* []()
* []()
* []()

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[PowerShell-shield]:https://img.shields.io/badge/PowerShell-blue.svg?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbDpzcGFjZT0icHJlc2VydmUiIHZpZXdCb3g9IjAgMCAxMjggMTI4Ij48bGluZWFyR3JhZGllbnQgaWQ9ImEiIHgxPSI5Ni4zMDYiIHgyPSIyNS40NTQiIHkxPSIzNS4xNDQiIHkyPSI5OC40MzEiIGdyYWRpZW50VHJhbnNmb3JtPSJtYXRyaXgoMSAwIDAgLTEgMCAxMjgpIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHN0b3Agb2Zmc2V0PSIwIiBzdG9wLWNvbG9yPSIjYTljOGZmIi8+PHN0b3Agb2Zmc2V0PSIxIiBzdG9wLWNvbG9yPSIjYzdlNmZmIi8+PC9saW5lYXJHcmFkaWVudD48cGF0aCBmaWxsPSJ1cmwoI2EpIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik03LjIgMTEwLjVjLTEuNyAwLTMuMS0uNy00LjEtMS45LTEtMS4yLTEuMy0yLjktLjktNC42bDE4LjYtODAuNWMuOC0zLjQgNC02IDcuNC02aDkyLjZjMS43IDAgMy4xLjcgNC4xIDEuOSAxIDEuMiAxLjMgMi45LjkgNC42bC0xOC42IDgwLjVjLS44IDMuNC00IDYtNy40IDZINy4yeiIgY2xpcC1ydWxlPSJldmVub2RkIiBvcGFjaXR5PSIuOCIvPjxsaW5lYXJHcmFkaWVudCBpZD0iYiIgeDE9IjI1LjMzNiIgeDI9Ijk0LjU2OSIgeTE9Ijk4LjMzIiB5Mj0iMzYuODQ3IiBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDEgMCAwIC0xIDAgMTI4KSIgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiPjxzdG9wIG9mZnNldD0iMCIgc3RvcC1jb2xvcj0iIzJkNDY2NCIvPjxzdG9wIG9mZnNldD0iLjE2OSIgc3RvcC1jb2xvcj0iIzI5NDA1YiIvPjxzdG9wIG9mZnNldD0iLjQ0NSIgc3RvcC1jb2xvcj0iIzFlMmY0MyIvPjxzdG9wIG9mZnNldD0iLjc5IiBzdG9wLWNvbG9yPSIjMGMxMzFiIi8+PHN0b3Agb2Zmc2V0PSIxIi8+PC9saW5lYXJHcmFkaWVudD48cGF0aCBmaWxsPSJ1cmwoI2IpIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMjAuMyAxOC41SDI4LjVjLTIuOSAwLTUuNyAyLjMtNi40IDUuMkwzLjcgMTA0LjNjLS43IDIuOSAxLjEgNS4yIDQgNS4yaDkxLjhjMi45IDAgNS43LTIuMyA2LjQtNS4ybDE4LjQtODAuNWMuNy0yLjktMS4xLTUuMy00LTUuM3oiIGNsaXAtcnVsZT0iZXZlbm9kZCIvPjxwYXRoIGZpbGw9IiMyQzU1OTEiIGZpbGwtcnVsZT0iZXZlbm9kZCIgZD0iTTY0LjIgODguM2gyMi4zYzIuNiAwIDQuNyAyLjIgNC43IDQuOXMtMi4xIDQuOS00LjcgNC45SDY0LjJjLTIuNiAwLTQuNy0yLjItNC43LTQuOXMyLjEtNC45IDQuNy00Ljl6TTc4LjcgNjYuNWMtLjQuOC0xLjIgMS42LTIuNiAyLjZMMzQuNiA5OC45Yy0yLjMgMS42LTUuNSAxLTcuMy0xLjQtMS43LTIuNC0xLjMtNS43LjktNy4zbDM3LjQtMjcuMXYtLjZsLTIzLjUtMjVjLTEuOS0yLTEuNy01LjMuNC03LjQgMi4yLTIgNS41LTIgNy40IDBsMjguMiAzMGMxLjcgMS45IDEuOCA0LjUuNiA2LjR6IiBjbGlwLXJ1bGU9ImV2ZW5vZGQiLz48cGF0aCBmaWxsPSIjRkZGIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik03Ny42IDY1LjVjLS40LjgtMS4yIDEuNi0yLjYgMi42TDMzLjYgOTcuOWMtMi4zIDEuNi01LjUgMS03LjMtMS40LTEuNy0yLjQtMS4zLTUuNy45LTcuM2wzNy40LTI3LjF2LS42bC0yMy41LTI1Yy0xLjktMi0xLjctNS4zLjQtNy40IDIuMi0yIDUuNS0yIDcuNCAwbDI4LjIgMzBjMS43IDEuOCAxLjggNC40LjUgNi40ek02My41IDg3LjhoMjIuM2MyLjYgMCA0LjcgMi4xIDQuNyA0LjYgMCAyLjYtMi4xIDQuNi00LjcgNC42SDYzLjVjLTIuNiAwLTQuNy0yLjEtNC43LTQuNiAwLTIuNiAyLjEtNC42IDQuNy00LjZ6IiBjbGlwLXJ1bGU9ImV2ZW5vZGQiLz48L3N2Zz4K
[PowerShell-logo]:https://icon.icepanel.io/Technology/svg/Powershell.svg
[PowerShell-url]:https://learn.microsoft.com/en-us/powershell/
[contributors-shield]: https://img.shields.io/github/contributors/Skilledgamer101/uts-sd-kiosk.svg?style=for-the-badge
[contributors-url]: https://github.com/Skilledgamer101/uts-sd-kiosk/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Skilledgamer101/uts-sd-kiosk.svg?style=for-the-badge
[forks-url]: https://github.com/Skilledgamer101/uts-sd-kiosk/network/members
[stars-shield]: https://img.shields.io/github/stars/Skilledgamer101/uts-sd-kiosk.svg?style=for-the-badge
[stars-url]: https://github.com/Skilledgamer101/uts-sd-kiosk/stargazers
[issues-shield]: https://img.shields.io/github/issues/Skilledgamer101/uts-sd-kiosk.svg?style=for-the-badge
[issues-url]: https://github.com/Skilledgamer101/uts-sd-kiosk/issues
[license-shield]: https://img.shields.io/github/license/Skilledgamer101/uts-sd-kiosk.svg?style=for-the-badge
[license-url]: https://github.com/Skilledgamer101/uts-sd-kiosk/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/mansoor-lunawadi
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
