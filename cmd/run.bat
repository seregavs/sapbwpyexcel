@echo off
rem python "C:\Users\<user>\Documents\Python\ubex\ubex\ubex.py" BWQ 4 1
python "C:\Users\<user>\Documents\Python\ubex\ubex\ubex_scheduler.py" BWD
pause
start %windir%\explorer.exe "C:\Temp\ubex"