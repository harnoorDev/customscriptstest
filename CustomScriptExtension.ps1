




#Download and Run MSI package for Automated install
$uri = "https://openvpn.net/downloads/openvpn-connect-v3-windows.msi"
$uri2 = "https://download.microsoft.com/download/C/B/3/CB35F695-5A32-4458-ACDB-E701250CEA1E/SQLDataSyncAgent-2.0-x64-ENU.msi"
$out = "C:\Downloads\OpenVPNInstaller.msi"
$out2 = "C:\Downloads\SQLDataSync.msi"

Function Download_OPEN_VPN_Installer{
Invoke-WebRequest -uri $uri -OutFile $out
$msifile = Get-ChildItem -Path $out -File -Filter '*.ms*' 
$msifile2 = Get-ChildItem -Path $out2 -File -Filter '*.ms*' 
write-host "Open VPN $msifile "
write-host "Open $msifile2 "
}

Function Install_OpenVPN{
msiexec /i $out /passive

}

Download_OPEN_VPN_Installer
Install_OpenVPN




Set-TimeZone -Id "Eastern Standard Time" -PassThru

netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow 


Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy
\DomainProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\
PublicProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\
Standardprofile' -name "EnableFirewall" -Value 0



Write-Host ($writeEmptyLine + "# BgInfo download started")`
-foregroundcolor $foregroundColor1 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 
## Create BgInfo folder on C: if it not exists, else delete it's content
 
If (!(Test-Path -Path $bgInfoFolder)){New-Item -ItemType $itemType -Force -Path $bgInfoFolder
    Write-Host ($writeEmptyLine + "# BgInfo folder created")`
    -foregroundcolor $foregroundColor2 $writeEmptyLine
 }Else{Write-Host ($writeEmptyLine + "# BgInfo folder already exists")`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
    Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
    Write-Host ($writeEmptyLine + "# Content existing BgInfo folder deleted")`
    -foregroundcolor $foregroundColor1 $writeEmptyLine}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract latest BgInfo software to C:\BgInfo
 
Import-Module BitsTransfer
Start-BitsTransfer -Source $bgInfoUrl -Destination $bgInfoZip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($bgInfoZip, $bgInfoFolder)
Remove-Item $bgInfoZip
Remove-Item $bgInfoEula
Write-Host ($writeEmptyLine + "# bginfo.exe available")`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Download, save and extract logon.bgi file to C:\BgInfo
 
Invoke-WebRequest -Uri $logonBgiUrl -OutFile $logonBgiZip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($logonBgiZip, $bgInfoFolder)
Remove-Item $logonBgiZip
Write-Host ($writeEmptyLine + "# logon.bgi available")`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Create BgInfo Registry Key to AutoStart
 
If ($regKeyExists -eq $True){Write-Host ($writeEmptyLine + "# BgInfo regkey exists, script wil go on")`
-foregroundcolor $foregroundColor1 $writeEmptyLine
}Else{
New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
Write-Host ($writeEmptyLine + "# BgInfo regkey added")`
-foregroundcolor $foregroundColor2 $writeEmptyLine}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Run BgInfo
 
C:\BgInfo\Bginfo.exe C:\BgInfo\logon.bgi /timer:0 /nolicprompt
Write-Host ($writeEmptyLine + "# BgInfo has run")`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
## Exit PowerShell window 3 seconds after completion
 
Write-Host ($writeEmptyLine + "# Script completed, the PowerShell window will close in 3 seconds")`
-foregroundcolor $foregroundColor1 $writeEmptyLine
Start-Sleep 3 
stop-process -Id $PID
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
