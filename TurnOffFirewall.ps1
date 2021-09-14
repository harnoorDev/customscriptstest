
Set-ExecutionPolicy RemoteSigned -CurrentScope Process -Force
Set-ExecutionPolicy RemoteSigned -CurrentScope CurrentUser -Force
Set-ExecutionPolicy RemoteSigned -CurrentScope LocalMachine -Force

# Show all tray icons
Function ShowTrayIcons {
	Write-Output "Showing all tray icons..."
	If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")) {
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoAutoTrayNotify" -Type DWord -Value 1
}

Set-TimeZone -Id "Eastern Standard Time" -PassThru

netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow 

Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled False

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\Standardprofile' -name "EnableFirewall" -Value 0


ShowTrayIcons


 #./ShowAllSystemTrayIcons.ps1
