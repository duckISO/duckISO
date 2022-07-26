# duckISO Source
Here you can find sources files used to build duckISO:
- NTLite preset (duckISO.xml)
- Registry files
- Scripts
- Others, such as programs needed to interface with Windows easier

## Building From Source

**NOTE:** You should ideally be using Windows 11 Enterprise Pro to build this, to ensure that all the policies apply correctly.

There are plenty of reasons to build duckISO from source such as:
- To use it, there's no provided ISOs
- To personalize the build, by removing/restoring components you may/may not need
- To ensure that the ISO is legitimate

### Prerequisites
- NTLite free or above (preset is only made in the free version)
- An archive extractor (7-Zip... it is illegal to use duckISO if you use WinRaR and especially WinZip)
- A local copy of the duckISO repository
- A Windows 11 Enterprise ISO ([get it here](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise) or )
- An archive extractor ([7-Zip](https://www.7-zip.org/)... it is illegal to use duckISO if you use WinRaR and especially WinZip)

### Getting Started
1. Extract the Windows build using the previously mentioned archive extractor
2. Open NTLite and add the extracted folder to NTLite's source list
3. Import the duckISO XML from the repo and apply it
4. Integrate drivers, registry files and updates
5. Copy the following Folders/Files to the NTLite Mount Directory (right click -> explore mount directory)
  ```
  - DuckModules >> %temp%\NLTmpMount01\Windows\DuckModules
  - Desktop/duckISO >> %temp%\NLTmpMount01\Users\Default\Desktop\duckISO
  - PostInstall.bat >> %temp%\NLTmpMount01\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\PostInstall.bat
  ```
7. Make any changes you want to NTLite's components, settings, services etc... Here's what the components look like:

![Components](https://cdn.discordapp.com/attachments/779004051337117776/984919398982746203/NTLite_Q2pODNHjE6.png)

9. Go to the "Apply" tab and click process
10. Done!

## Resources
- [VCRedist](https://github.com/abbodi1406/vcredist)
- [DevManView](https://www.nirsoft.net/utils/device_manager_view.html)
- [ServiWin](https://www.nirsoft.net/utils/serviwin.html)
- [7-Zip](https://www.7-zip.org)
- [NSudo](https://github.com/m2team/NSudo)