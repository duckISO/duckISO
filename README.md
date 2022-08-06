<h1 align="center">
  <a href="https://github.com/duckISO/duckISO/"><img src="https://github.com/duckISO/duckISO/raw/main/img/banner.jpg" alt="duckISO Banner" width="900"></a>
  <br>duckISO 🦆<br>
</h1>

<p align="center">
  <a href="https://github.com/duckISO/duckISO/tree/main/src">Source code/building</a>
  ·
  <a href="https://github.com/duckISO/duckISO/tree/main/src/DuckModules">Hashes of binaries</a>
  ·
  <a href="https://discord.gg/wsDx6TUP2c">Discord</a>
</p>

**⚠️ Warning:** I do not recommend using duckISO as your daily Windows install yet, wait until [version 1.0 releases](https://github.com/orgs/duckISO/projects/1).

My personal presets and scripts to modify Windows 11 or 10 with NTLite for performance and privacy. duckISO is a fork of [AtlasOS](https://github.com/Atlas-OS/Atlas). It is focused on being a long term installation, with not a lot of items stripped (mostly UWP bloat is stripped), causing less issues in the future as you can re-enable what you have disabled.
- Defender is not stripped, but it is disabled by default
  - You may want or need it in the future, it is a good anti-virus that integrates into Windows well (your brain is better though mostly)
- Windows Update is not disabled, it is configured with policies and you can easily re-run the post installation script after an update
  - It is enabled for security and bug fixes (with Windows 11, you are probably going to want the updates)
- Edge (configued with policies) is not stripped, it can be uninstalled and replaced with either LibreWolf of Brave
  - Couldn't strip it easily with free NTLite, plus it is nice to have an included web browser

### There are no ISOs provided
If you want to use this, [build it yourself](https://github.com/duckISO/duckISO/tree/main/src). This is to avoid noobs using it and asking for help with simple things that they shouldn't need help for if they are knowingly using a custom ISO.

### Credits
- [AtlasOS](https://github.com/Atlas-OS/Atlas) - duckISO a fork of Atlas - it wouldn't be able to be made without it (Zusier is 🐐)
- [privacy.sexy](https://privacy.sexy/) - Disabling Defender and uninstalling Edge - a great project
- [ReviOS](https://www.revi.cc/revios) - Replacing Edge's associations in the Windows Registry
- Credit to the AtlasOS contributors

### Notes
You can view the old commit history here: https://github.com/duckISO/gooseISO

```
   _
>( . )__  <--- duck
 (_____/
```
