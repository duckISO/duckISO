# duckISO Source 🦆
Here you can find sources files used to build duckISO:
- NTLite presets (`duckISO 10.xml` or `duckISO 11.xml`)
- Registry file(s)
- Scripts (on the desktop)
- Others, such as programs needed to interface with Windows easier

## Building From Source

**NOTE:** Ideally, you should use Windows 11 Enterprise as your base ISO, so that all the policies apply correctly. Insider without a Microsoft account or telemetry may not work on Windows 10/11 Pro. You can use LTSC if you really want to.

### Why should you build it? 
- To use it, there's no provided ISOs (to avoid any potential issues with redistributing ISOs, to make it more legit and to make sure that noobs do not install it)
  - To avoid any potential issues with redistributing ISOs
  - To make it more legitimate (I can not really tamper with it)
  - To make sure that noobs do not install it
- To personalize the build, to remove or restore components, to change settings, to use your own Windows version, etc...
- To ensure that the ISO is legitimate (if you use an ISO built by someone else, they could of changed anything they wanted to)

### Prerequisites
- [NTLite](https://www.ntlite.com/) free or above (preset is only made in the free version)
- An archive extractor ([7-Zip](https://www.7-zip.org/)... it is illegal to use duckISO if you use WinRaR and especially WinZip)
- A local copy of the duckISO repository (use `git clone` or [click here](https://github.com/duckISO/duckISO/archive/refs/heads/main.zip)
- A Windows 10 or 11 Enterprise (or Pro) ISO ([Win 10 Pro](https://www.microsoft.com/en-gb/software-download/windows10), [Win 11 Pro](https://www.microsoft.com/software-download/windows11) and [UUPDump](https://uupdump.net/))
	- You should probably use UUPDump if you want to make an insider ISO
- A Windows installation to build duckISO with (can be a virtual machine)

### Downloading the Windows 10/11 Enterprise ISO
Downloading the evaluation version [from here](https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise) causes issues with NTLite (the Windows Setup wouldn't work), so I do not recommend using evaluation verisons of ISOs with NTLite. Instead, you can use [UUPDump](https://uupdump.net/) to literally build your own ISO using a script or you can follow this to get an official ISO from Microsoft:
1. Get the Media Creation Tool from Microsoft's website ([10](https://www.microsoft.com/en-gb/software-download/windows10) or [11](https://www.microsoft.com/software-download/windows11))
2. Open Command Prompt as admin and `cd` to the directory with the Media Creation Tool inside of it.
3. Run it in Command Prompt with these arguments, but replace `EXEHERE.exe` with the name of the executable you downloaded (like `MediaCreationToolW11.exe`) and replace the `MediaLangCode` with your langauge code:
```
EXEHERE.exe /Eula Accept /Retail /MediaArch x64 /MediaLangCode en-GB /MediaEdition Enterprise
```
4. Enter a generic product key when asked
	1. Win 10 Enterprise: `XGVPP-NMH47-7TTHJ-W3FW7-8HV2C`
    2. Windows 11 Enterprise: `NPPR9-FWDCX-D2C8J-H872K-2YT43`
5. Go through the rest of the setup, make sure to make it output an ISO file

**I am not going to help with activating it, I presume that you have a legitimate key.**

<details><summary>List of language codes and their respective languages</summary>

**Note:** Other languages that are not English are not officially supported by the scripts or me and you may have issues.

| Language code | Language |
| ----------- | ----------- |
| af | Afrikaans |
| af-ZA | Afrikaans (South Africa) |
| ar | Arabic |
| ar-AE | Arabic (U.A.E.) |
| ar-BH | Arabic (Bahrain) |
| ar-DZ | Arabic (Algeria) |
| ar-EG | Arabic (Egypt) |
| ar-IQ | Arabic (Iraq) |
| ar-JO | Arabic (Jordan) |
| ar-KW | Arabic (Kuwait) |
| ar-LB | Arabic (Lebanon) |
| ar-LY | Arabic (Libya) |
| ar-MA | Arabic (Morocco) |
| ar-OM | Arabic (Oman) |
| ar-QA | Arabic (Qatar) |
| ar-SA | Arabic (Saudi Arabia) |
| ar-SY | Arabic (Syria) |
| ar-TN | Arabic (Tunisia) |
| ar-YE | Arabic (Yemen) |
| az | Azeri (Latin) |
| az-AZ | Azeri (Latin) (Azerbaijan) |
| az-AZ | Azeri (Cyrillic) (Azerbaijan) |
| be | Belarusian |
| be-BY | Belarusian (Belarus) |
| bg | Bulgarian |
| bg-BG | Bulgarian (Bulgaria) |
| bs-BA | Bosnian (Bosnia and Herzegovina) |
| ca | Catalan |
| ca-ES | Catalan (Spain) |
| cs | Czech |
| cs-CZ | Czech (Czech Republic) |
| cy | Welsh |
| cy-GB | Welsh (United Kingdom) |
| da | Danish |
| da-DK | Danish (Denmark) |
| de | German |
| de-AT | German (Austria) |
| de-CH | German (Switzerland) |
| de-DE | German (Germany) |
| de-LI | German (Liechtenstein) |
| de-LU | German (Luxembourg) |
| dv | Divehi |
| dv-MV | Divehi (Maldives) |
| el | Greek |
| el-GR | Greek (Greece) |
| en | English |
| en-AU | English (Australia) |
| en-BZ | English (Belize) |
| en-CA | English (Canada) |
| en-CB | English (Caribbean) |
| en-GB | English (United Kingdom) |
| en-IE | English (Ireland) |
| en-JM | English (Jamaica) |
| en-NZ | English (New Zealand) |
| en-PH | English (Republic of the Philippines) |
| en-TT | English (Trinidad and Tobago) |
| en-US | English (United States) |
| en-ZA | English (South Africa) |
| en-ZW | English (Zimbabwe) |
| eo | Esperanto |
| es | Spanish |
| es-AR | Spanish (Argentina) |
| es-BO | Spanish (Bolivia) |
| es-CL | Spanish (Chile) |
| es-CO | Spanish (Colombia) |
| es-CR | Spanish (Costa Rica) |
| es-DO | Spanish (Dominican Republic) |
| es-EC | Spanish (Ecuador) |
| es-ES | Spanish (Castilian) |
| es-ES | Spanish (Spain) |
| es-GT | Spanish (Guatemala) |
| es-HN | Spanish (Honduras) |
| es-MX | Spanish (Mexico) |
| es-NI | Spanish (Nicaragua) |
| es-PA | Spanish (Panama) |
| es-PE | Spanish (Peru) |
| es-PR | Spanish (Puerto Rico) |
| es-PY | Spanish (Paraguay) |
| es-SV | Spanish (El Salvador) |
| es-UY | Spanish (Uruguay) |
| es-VE | Spanish (Venezuela) |
| et | Estonian |
| et-EE | Estonian (Estonia) |
| eu | Basque |
| eu-ES | Basque (Spain) |
| fa | Farsi |
| fa-IR | Farsi (Iran) |
| fi | Finnish |
| fi-FI | Finnish (Finland) |
| fo | Faroese |
| fo-FO | Faroese (Faroe Islands) |
| fr | French |
| fr-BE | French (Belgium) |
| fr-CA | French (Canada) |
| fr-CH | French (Switzerland) |
| fr-FR | French (France) |
| fr-LU | French (Luxembourg) |
| fr-MC | French (Principality of Monaco) |
| gl | Galician |
| gl-ES | Galician (Spain) |
| gu | Gujarati |
| gu-IN | Gujarati (India) |
| he | Hebrew |
| he-IL | Hebrew (Israel) |
| hi | Hindi |
| hi-IN | Hindi (India) |
| hr | Croatian |
| hr-BA | Croatian (Bosnia and Herzegovina) |
| hr-HR | Croatian (Croatia) |
| hu | Hungarian |
| hu-HU | Hungarian (Hungary) |
| hy | Armenian |
| hy-AM | Armenian (Armenia) |
| id | Indonesian |
| id-ID | Indonesian (Indonesia) |
| is | Icelandic |
| is-IS | Icelandic (Iceland) |
| it | Italian |
| it-CH | Italian (Switzerland) |
| it-IT | Italian (Italy) |
| ja | Japanese |
| ja-JP | Japanese (Japan) |
| ka | Georgian |
| ka-GE | Georgian (Georgia) |
| kk | Kazakh |
| kk-KZ | Kazakh (Kazakhstan) |
| kn | Kannada |
| kn-IN | Kannada (India) |
| ko | Korean |
| ko-KR | Korean (Korea) |
| kok | Konkani |
| kok-IN | Konkani (India) |
| ky | Kyrgyz |
| ky-KG | Kyrgyz (Kyrgyzstan) |
| lt | Lithuanian |
| lt-LT | Lithuanian (Lithuania) |
| lv | Latvian |
| lv-LV | Latvian (Latvia) |
| mi | Maori |
| mi-NZ | Maori (New Zealand) |
| mk | FYRO Macedonian |
| mk-MK | FYRO Macedonian (Former Yugoslav Republic of Macedonia) |
| mn | Mongolian |
| mn-MN | Mongolian (Mongolia) |
| mr | Marathi |
| mr-IN | Marathi (India) |
| ms | Malay |
| ms-BN | Malay (Brunei Darussalam) |
| ms-MY | Malay (Malaysia) |
| mt | Maltese |
| mt-MT | Maltese (Malta) |
| nb | Norwegian (Bokm?l) |
| nb-NO | Norwegian (Bokm?l) (Norway) |
| nl | Dutch |
| nl-BE | Dutch (Belgium) |
| nl-NL | Dutch (Netherlands) |
| nn-NO | Norwegian (Nynorsk) (Norway) |
| ns | Northern Sotho |
| ns-ZA | Northern Sotho (South Africa) |
| pa | Punjabi |
| pa-IN | Punjabi (India) |
| pl | Polish |
| pl-PL | Polish (Poland) |
| ps | Pashto |
| ps-AR | Pashto (Afghanistan) |
| pt | Portuguese |
| pt-BR | Portuguese (Brazil) |
| pt-PT | Portuguese (Portugal) |
| qu | Quechua |
| qu-BO | Quechua (Bolivia) |
| qu-EC | Quechua (Ecuador) |
| qu-PE | Quechua (Peru) |
| ro | Romanian |
| ro-RO | Romanian (Romania) |
| ru | Russian |
| ru-RU | Russian (Russia) |
| sa | Sanskrit |
| sa-IN | Sanskrit (India) |
| se | Sami (Northern) |
| se-FI | Sami (Northern) (Finland) |
| se-FI | Sami (Skolt) (Finland) |
| se-FI | Sami (Inari) (Finland) |
| se-NO | Sami (Northern) (Norway) |
| se-NO | Sami (Lule) (Norway) |
| se-NO | Sami (Southern) (Norway) |
| se-SE | Sami (Northern) (Sweden) |
| se-SE | Sami (Lule) (Sweden) |
| se-SE | Sami (Southern) (Sweden) |
| sk | Slovak |
| sk-SK | Slovak (Slovakia) |
| sl | Slovenian |
| sl-SI | Slovenian (Slovenia) |
| sq | Albanian |
| sq-AL | Albanian (Albania) |
| sr-BA | Serbian (Latin) (Bosnia and Herzegovina) |
| sr-BA | Serbian (Cyrillic) (Bosnia and Herzegovina) |
| sr-SP | Serbian (Latin) (Serbia and Montenegro) |
| sr-SP | Serbian (Cyrillic) (Serbia and Montenegro) |
| sv | Swedish |
| sv-FI | Swedish (Finland) |
| sv-SE | Swedish (Sweden) |
| sw | Swahili |
| sw-KE | Swahili (Kenya) |
| syr | Syriac |
| syr-SY | Syriac (Syria) |
| ta | Tamil |
| ta-IN | Tamil (India) |
| te | Telugu |
| te-IN | Telugu (India) |
| th | Thai |
| th-TH | Thai (Thailand) |
| tl | Tagalog |
| tl-PH | Tagalog (Philippines) |
| tn | Tswana |
| tn-ZA | Tswana (South Africa) |
| tr | Turkish |
| tr-TR | Turkish (Turkey) |
| tt | Tatar |
| tt-RU | Tatar (Russia) |
| ts | Tsonga |
| uk | Ukrainian |
| uk-UA | Ukrainian (Ukraine) |
| ur | Urdu |
| ur-PK | Urdu (Islamic Republic of Pakistan) |
| uz | Uzbek (Latin) |
| uz-UZ | Uzbek (Latin) (Uzbekistan) |
| uz-UZ | Uzbek (Cyrillic) (Uzbekistan) |
| vi | Vietnamese |
| vi-VN | Vietnamese (Viet Nam) |
| xh | Xhosa |
| xh-ZA | Xhosa (South Africa) |
| zh | Chinese |
| zh-CN | Chinese (S) |
| zh-HK | Chinese (Hong Kong) |
| zh-MO | Chinese (Macau) |
| zh-SG | Chinese (Singapore) |
| zh-TW | Chinese (T) |
| zu | Zulu |
| zu-ZA | Zulu (South Africa) |

</details>

### Making the ISO
1. Extract the Windows build using the previously mentioned archive extractor
2. Open NTLite and add the extracted folder to NTLite's source list
3. Import the duckISO XML from the repo and apply it
4. **Integrate drivers (especially networking drivers)**, the registry file (integrate `duckISO.reg`) and the latest updates (unless UUPDump did it for you)
	1. [Windows 10 21H2 update history](https://support.microsoft.com/en-us/topic/windows-10-update-history-857b8ccb-71e4-49e5-b3f6-7073197d98fb)
	2. [Windows 11 21H2 update history](https://support.microsoft.com/en-us/topic/windows-11-update-history-a19cd327-b57f-44b9-84e0-26ced7109ba9)
	3. You can find the drivers for your networking card by researching the model or hardware IDs, check Device Manager.
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
