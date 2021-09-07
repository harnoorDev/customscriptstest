

Set-TimeZone -Id "Eastern Standard Time" -PassThru

netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow 


Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\Standardprofile' -name "EnableFirewall" -Value 0

## Variables
 
$bgInfoFolder = "C:\BgInfo"
$bgInfoFolderContent = $bgInfoFolder + "\*"
$itemType = "Directory"
$bgInfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$logonBgiUrl = "https://tinyurl.com/yxlxbgun"
$bgInfoZip = "C:\BgInfo\BgInfo.zip"
$bgInfoEula = "C:\BgInfo\Eula.txt"
$logonBgiZip = "C:\BgInfo\LogonBgi.zip"
$bgInfoRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegkey = "BgInfo"
$bgInfoRegType = "String"
$bgInfoRegkeyValue = "C:\BgInfo\Bginfo.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt"
$regKeyExists = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
 
$foregroundColor1 = "Red"

$writeEmptyLine = "`n"
 

 
## Create BgInfo folder on C: if it not exists, else delete it's content
 
If (!(Test-Path -Path $bgInfoFolder)){New-Item -ItemType $itemType -Force -Path $bgInfoFolder
  
 }Else{
   
    Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract latest BgInfo software to C:\BgInfo
 
Import-Module BitsTransfer
Start-BitsTransfer -Source $bgInfoUrl -Destination $bgInfoZip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($bgInfoZip, $bgInfoFolder)
Remove-Item $bgInfoZip
Remove-Item $bgInfoEula

 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract logon.bgi file to C:\BgInfo
 
Invoke-WebRequest -Uri $logonBgiUrl -OutFile $logonBgiZip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($logonBgiZip, $bgInfoFolder)
Remove-Item $logonBgiZip

 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create BgInfo Registry Key to AutoStart
 
If ($regKeyExists -eq $True){Write-Host ($writeEmptyLine + "# BgInfo regkey exists, script wil go on")`
-foregroundcolor $foregroundColor1 $writeEmptyLine
}Else{
New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Run BgInfo
 
C:\BgInfo\Bginfo.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt

 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Exit PowerShell window 3 seconds after completion
 

Start-Sleep 3 
stop-process -Id $PID
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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


