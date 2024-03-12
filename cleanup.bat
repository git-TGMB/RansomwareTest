@echo off
set "TaskName=PopupTask"
set "wallpaperpath=C:\Windows\Web\Wallpaper\Windows\img0.jpg"
set "Script1=C:\temp\popup.bat"
set "Script2=C:\temp\hide.vbs"

:: Show taskbar
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=2;&Set-ItemProperty -Path $p -Name Settings -Value $v;}"

:: Change wallpaper and hide icons, update
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %wallpaperpath% /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideIcons /t REG_DWORD /d 0 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: schtask for popup.bat
schtasks /Delete /TN "%TaskName%" /F
schtasks /Run /TN %TaskName%

taskkill /f /im explorer.exe
start explorer.exe