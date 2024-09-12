@ECHO ON
REM "%windir%\system32\update\runonce\05b704e3-e524-49f1-a7c4-0b5df7481950\success.cmd"
Echo BEGIN success.cmd >> C:\Windows\Temp\FeatureUpdate-successcmd.log

REM Remove win11 bloatware apps
cd C:\ProgramData\FUp-Config-Content\
START /Wait Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\ProgramData\FUp-Config-Content\RemoveApps_Cloud.ps1"

REM Brand OEMInfo to the System
START Powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\ProgramData\FUp-Config-Content\OEMInfo\OEMInfo.ps1"

REM Add "My PC" icon to desktop
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /V {20D04FE0-3AEA-1069-A2D8-08002B30309D} /T REG_DWORD /D 0 /F

REM Add Run as different user
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V ShowRunasDifferentuserinStart /T REG_DWORD /D 1 /F

REM Change "This PC" icon to Machine Name
cd C:\ProgramData\FUp-Config-Content\
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set OSLanguage=%%a
if %OSLanguage%==1033 (call C:\ProgramData\FUp-Config-Content\MyComputerNameIcon\Load_ComputerName.cmd)
if %OSLanguage%==1036 (call C:\ProgramData\FUp-Config-Content\MyComputerNameIcon\Load_ComputerName_FR.cmd)
if %OSLanguage%==3084 (call C:\ProgramData\FUp-Config-Content\MyComputerNameIcon\Load_ComputerName_FR.cmd)

REM Tweak - Mount Def User Profile
REG LOAD "HKEY_LOCAL_MACHINE\defuser" c:\users\default\ntuser.dat
REM Tweak - Set Cortana / Search Icon
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 1 /F
REM Tweak - Unpin MS Store from Taskbar
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V NoPinningStoreToTaskbar /T REG_DWORD /D 1 /F
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /V NoPinningStoreToTaskbar /T REG_DWORD /D 1 /F
REM Tweak - Show File Name Extensions
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V HideFileExt /T REG_DWORD /D 0 /F
REM Tweak - Turn off News and Interests
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Microsoft\Windows\CurrentVersion\Feeds" /V ShellFeedsTaskbarViewMode /T REG_DWORD /D 2 /F
REM Tweak - LockScreen Tool Tips & Rotation Disable
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /V RotatingLockScreenOverlayEnabled /T REG_DWORD /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V RotatingLockScreenEnabled /D 0 /F
REM Tweak - Content Delivery Disable
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V SystemPaneSuggestionsEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V SubscribedContentEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V SoftLandingEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V SilentInstalledAppsEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V PreInstalledAppsEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V OemPreInstalledAppsEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V FeatureManagementEnabled /D 0 /F
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V ContentDeliveryAllowed /D 0 /F
REM Tweak - LockScreen SpotLight Disable
REG ADD "HKEY_LOCAL_MACHINE\defuser\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /V DisableWindowsSpotlightFeatures /T REG_DWORD /D 00000001 /F
REM Tweak - Remove Task View Button
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V ShowTaskViewButton /T REG_DWORD /D 0 /F
REM Tweak - Remove Chat
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V TaskbarMn /T REG_DWORD /D 00000000 /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v ConfigureChatAutoInstall /t REG_DWORD /d 0 /f

REM Tweak - Remove Widgets
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V TaskbarDa /T REG_DWORD /D 00000000 /F
REM Tweak - Disable Co-Pilot
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Policies\Microsoft\Windows\WindowsCopilot" /v "TurnOffWindowsCopilot" /t REG_DWORD /f /d 1
REG ADD "HKEY_LOCAL_MACHINE\defuser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowCopilotButton" /t REG_DWORD /f /d 0
REM Tweak - unmount Def User Profile
REG UNLOAD HKEY_LOCAL_MACHINE\defuser

Echo END success.cmd >> C:\Windows\Temp\FeatureUpdate-successcmd.log