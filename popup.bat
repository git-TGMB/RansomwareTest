@echo off
for /l %%x in (1, 1, 100) do (

echo msgbox "You have been infected with Petya Ransomware. Please contact your IT Department to fix." > %tmp%\tmp.vbs
cscript /nologo %tmp%\tmp.vbs
del %tmp%\tmp.vbs
)