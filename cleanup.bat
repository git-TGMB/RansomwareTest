@echo off
echo Ransomware Simulation Cleanup Script [Version 1.0]
echo Written by Jim Teml, IT Security Analyst 
echo.

set "TaskName=PopupTask"
set /p wallpaperpath=<C:\temp\oldwallpaper.txt
set "Script1=C:\temp\popup.bat"
set "Script2=C:\temp\hide.vbs"

:: Show taskbar
echo Fixing taskbar...
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=2;&Set-ItemProperty -Path $p -Name Settings -Value $v;}"
echo.
echo Fixed
pause

:: Change wallpaper and show icons, update
echo Fixing wallpaper and icons...
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d %wallpaperpath% /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideIcons /t REG_DWORD /d 0 /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 1, True
echo Fixed

:: schtask for popup.bat
echo Deleting scheduled task...
schtasks /Delete /TN "%TaskName%" /F
echo Fixed

taskkill /f /im explorer.exe
start explorer.exe
echo.
echo Please restart your device to finalize the cleanup process.
pause
echo.
echo Thank you for keeping Ozinga Bros., Inc a safer and more secure business!
timeout 3
taskkill /f /im cmd.exe

