@echo off
if exist .\*.apk (ren *.apk orgin.apk) else echo "no apk file!!"
if exist .\*.dex (ren *.dex unshell.dex) else echo "no un-shell dex file!!"
pause