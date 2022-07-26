# duckISO Source
Here you can find sources files used to build duckISO:
- NTLite preset (duckISO.xml)
- Registry files
- Scripts
- Others, such as programs needed to interface with Windows easier

## Building From Source

**NOTE:** You should ideally be using Windows 11 Enterprise Pro to build this, so that all the policies apply correctly.

There are plenty of reasons to build duckISO from source such as:
- To use it, there's no provided ISOs (to avoid any potential issues with redistributing ISOs, to make it more legit and to make sure that noobs do not install it)
- To personalize the build, to remove or restore components, to change settings, to use your own Windows version, etc...
- To ensure that the ISO is legitimate (if you use an ISO built by someone else, they could of changed anything they wanted to)

### Prerequisites
- NTLite free or above (preset is only made in the free version)
- An archive extractor ([7-Zip](https://www.7-zip.org/)... it is illegal to use duckISO if you use WinRaR and especially WinZip)
- A local copy of the duckISO repository (use `git clone` or [click here](https://github.com/duckISO/duckISO/archive/refs/heads/main.zip)
- A Windows 11 Enterprise ISO ([Microsoft download](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise) or from [UUPDump](https://uupdump.net/))

### Getting Started
1. Extract the Windows build using the previously mentioned archive extractor
2. Open NTLite and add the extracted folder to NTLite's source list
3. Import the duckISO XML from the repo and apply it
4. Integrate drivers, registry file (integrate `duckISO.reg`) and updates (unless UUPDump did it for you)
5. Copy the following folders/files to the NTLite Mount Directory (source -> right click on mounted image -> explore mount directory)
  ```
  - DuckModules >> %temp%\NLTmpMount01\Windows\DuckModules
  - Desktop/duckISO >> %temp%\NLTmpMount01\Users\Default\Desktop\duckISO
  - PostInstall.cmd >> %temp%\NLTmpMount01\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\PostInstall.cmd
  ```
7. Make any changes you want to NTLite's components, settings, services etc... You should check and look over everything. Here's what the components look like:

![Components](https://user-images.githubusercontent.com/65787561/180858573-6c0e06f1-c25e-4c9e-9a50-d558846706de.png)

9. Go to the "Apply" tab and click process
10. Done!

## Resources
- [VCRedist](https://github.com/abbodi1406/vcredist)
- [DevManView](https://www.nirsoft.net/utils/device_manager_view.html)
- [ServiWin](https://www.nirsoft.net/utils/serviwin.html)
- [7-Zip](https://www.7-zip.org)
- [NSudo](https://github.com/m2team/NSudo)