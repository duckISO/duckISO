- 7-Zip
  Configures 7-Zip to most people's optimal configuration, for Scoop or the regular install

- Animations
  Default: Disabled
  Virtually all windows animations are disabled

- Anti-cheat Compatibility
  Default: Disabled
  Enables a mitigation to prevent unauthorized programs from writing to protected memory. 
  Game anti-cheats like Valorant/Faceit use this. The post install script should already enable it for those games.
  However, if you have issues, use this.

- Bluetooth
  Default: Disabled
  Enable if you use Bluetooth devices, make sure you have proper drivers for them as well.

- Clipboard History and Snip & Sketch
  Default: Disabled
  Clipboard History, seems to break any UWP copying to clipboard as well. Minimal impact, don't resist to re-enable it.

- Defender
  Default: Disabled
  You can re-disable Defender here without running the post install script, read the README.txt for enabling Defender.
  
- Event Log & Task Scheduler
  Default: Enabled
  Not recommended to disable, causes issues.

- Firewall
  Default: Enabled
  Configures windows firewall, frequently needed for Microsoft Store.

- FSO & GameBar
  Default: Disabled
  FSO (Fullscreen Optimizations) runs Fullscreen Exclusive games in a "highly optimized" borderless window. Which allows for faster alt-tabbing and overlays.
  However, fullscreen exclusive still gives better latency, smoothness and FPS (at least from my experience), plus it doesn't even take long to alt-tab.
  Leave it disabled.

- Hard drive
  Default: Disabled
  Enables features that improve hard disk performance, like prefetching and font caching. Not needed for SSDs.

- IE & WMP
  Default: Enabled
  Disable Internet Explorer and Windows Media Player.

- Network Discovery
  Default: Disabled
  Also known as network sharing, used to, as the name implies share files over the netork. There is no disable script as it is only other dependencies.

- Notifications
  Default: Enabled
  If you don't understand what this is you shouldn't be allowed to use a computer.
  Zusier is not wrong.

- Power
  Default: Enabled
  - Sleep States:
    https://github.com/Atlas-OS/Atlas/wiki/3.-Post-Install#sleep-states
    Allows you to use sleep/hibernate.
  - Idle:
    Disables system idle, will DISPLAY your CPU being used at 100%. It is not actually under 100% load.
	Increases temperatures and probably fan speed, not recommended to be enabled all the time.
	https://github.com/he3als/IdleDisabler
	
- Printing
  Default: Disabled

- Search Indexing
  Default: Disabled
  Enables indexing of files for faster searching within explorer (uses lots of cycles)

- Start Menu
  Various scripts, including removing the start menu and replacing it with openshell

- Store
  Default: Enabled
  Disables store, can break a lot of things in the process. Please READ THE DISCLAIMER in the script before continuing.

- Telemetry IP addresses
  Default: Enabled
  Block Microsoft related telemetry IP addresses via Windows Firewall.
  Firewall must be enabled.

- UAC
  Default: Enabled (Minimum)
  If you disable it and later re-enable it and then you have issues starting apps: go into safe mode and enable the Appinfo service with Serviwin.

- UWP
  Default: Enabled
  Disables UWP entirely, breaks a lot in the process. Only use if you know what you are doing and understand the drawbacks.
  Some UWP like settings can sorta work, but usually it is super buggy. Not recommended!

- VPN
  Default: Disabled

- Wifi
  Default: Enabled

- Windows Update
  Default: duckISO configuration
  Configure Windows Update.

- Workstation (SMB)
  Default: Disabled
  If you use SMB shares or AMD Ryzen Master, enable this.