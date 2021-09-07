#Download and Run MSI package for Automated install
$uri = "https://openvpn.net/downloads/openvpn-connect-v3-windows.msi"
$uri2 = "https://download.microsoft.com/download/C/B/3/CB35F695-5A32-4458-ACDB-E701250CEA1E/SQLDataSyncAgent-2.0-x64-ENU.msi"
$out = "C:\OpenVPNInstaller.msi"
$out2 = "C:\SQLDataSync.msi"

Function Download_Installers{
Invoke-WebRequest -uri $uri -OutFile $out
Invoke-WebRequest -uri $uri2 -OutFile $out2
$msifile = Get-ChildItem -Path $out -File -Filter '*.ms*' 
$msifile2 = Get-ChildItem -Path $out2 -File -Filter '*.ms*' 

}

Function Install_OpenVPN{
msiexec /i $out /passive

}

Download_Installers
Install_OpenVPN

.\TurnOffFirewall.ps1
