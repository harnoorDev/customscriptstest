Set-ExecutionPolicy RemoteSigned -CurrentScope Process -Force
Set-ExecutionPolicy RemoteSigned -CurrentScope CurrentUser -Force
Set-ExecutionPolicy RemoteSigned -CurrentScope LocalMachine -Force

#Showing All System Tray Icons
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F

C:\BgInfo\Bginfo.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt /silent

taskkill /f /im explorer.exe
start explorer.exe
