<h1 align="center">
<img src="https://github.com/he3als/duckISO/blob/main/img/banner.png" alt="Banner - duckISO"</img>
  <br>
  🦆 duckISO
  <br>
</h1>
<h4 align="center">Pre-tweak and debloat the Windows 10 operating system to improve performance and usability.</h4>
<h4 align="center">⚠ duckISO is not finished!</h4>

<p align="center">
  <a href="#Building">Building</a>
  •
  <a href="#FAQ">FAQ (not done yet)</a>
  •
  <a href="#Discord">Discord</a>
</p>

### The benefits compared to other Windows mods

- Easily customisable
  - duckISO is easily customisable with a simple configuration file or built in presets for privacy, performance and security. 
  - It is one ISO that aims to fit everyone!
- Open and transparent
  - duckISO is completely open source and does not require propritery software to build it. 
  - It also respects software licenses properly by not redistributing anything in violation of anything.
- Improved compatibility and reliablity
  - duckISO aims to be compatible and reliable by not unnessacerily disabling random stuff, not applying random tweaks, etc... 
  - Plus, it is customisable, so if you configured it properly, it will suit your needs!

### Issues with duckISO

- It is not finished!
- Potential bugs 
  - Could have bugs from being a new project and potentially quite hard project to make.
- Reliability in early stages
  - Some tweaks could cause issues with certain apps. 
  - However, duckISO aims to be as compatibile and therefore reliable as possible and will be more compatible than other ISOs.

### The benefits compared to regular windows

#### **Private**

duckISO disables a lot of tracking embedded within Windows 10 and enforces group policies to minimise data collection. However, to maintain usability, duckISO does not strip/disable certain services like Microsoft Store by default (you can as it is customisable), which may have telemetry and other privacy concerns, but it is minimised within these applications via group policies.

#### **Secure**

duckISO aims to give users the choice to either disable security features for performance (at your own risk) or to improve Windows' default security by disabling exploitable features/services with the default security features enabled. Windows Defender is going to be enabled by default, but that can be configured in the build script and it will be pre-configured. Windows Update is going to be enabled by default in the build script, but it will have custom policies to improve it. Mitigations, Windows Defender and Windows Updates can be disabled to improve performance & reliability, but you have a choice and by default they are enabled in the config for security. This can be customised in the configuration when building.
Below are some security vulnerabilties that exist if you disable mitigations:

- [Spectre](https://spectreattack.com/spectre.pdf)
- [Meltdown](https://meltdownattack.com/meltdown.pdf)
- [DMA Remapping](https://docs.microsoft.com/en-us/windows/security/information-protection/kernel-dma-protection-for-thunderbolt)

Below are features that are disabled by default by duckISO that have possible security issues:

- [Remote Desktop](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=Windows+Remote+Desktop)
- [Printing](https://www.cisa.gov/uscert/ncas/current-activity/2021/06/30/printnightmare-critical-windows-print-spooler-vulnerability)
- [Adobe Font Manager Library](https://msrc.microsoft.com/update-guide/en-US/vulnerability/CVE-2020-1020)
- NetBIOS (*possible information retrieval*)

### **Long term installation of Windows**

Unlike Atlas and other ISOs, duckISO keeps in mind that most users will be using duckISO as their main operating system. With this in mind, not a lot is stripped/removed from Windows, but instead disabled for compatibilty. Windows Update is also planned to be enabled by default (with custom policies to make it less annoying with less breakage) for security updates with a script to run to apply the tweaks again after updates. Also, releases will be updated with an updater program.

#### **Performant**

duckISO is pre-tweaked for QoL/usability (quality of life) and latency & performance.
We've done the following to do this:

- Custom power plan
- Minimized services
- Disabled drivers
- Disabled devices
- Disabled power saving
- Optionally disabling security features for performance
- Automatically enabled MSI mode
- Boot configuration optimization
- Optimized process scheduling

### Discord

Watch over developments over on the duckISO [Discord server](https://discord.gg/wsDx6TUP2c)!

### Building

duckISO is not finished, there are no current instructions on how to build it. There's no ETA right now, but I will be working on it. Join the [Discord](#Discord)!

### Credits

- [AtlasOS](https://github.com/Atlas-OS/Atlas) 
  - Being the base tweaks for this project and pretty much being the source for this `README.md`, a very good project
- [Ducks on the Water](https://commons.wikimedia.org/wiki/File:Ducks_on_the_water_(8309532657).jpg) by [Izabela Russell](https://www.flickr.com/people/91529100@N03) used as the background for the banner under the license [CC BY 2.0 license](https://creativecommons.org/licenses/by/2.0/)
