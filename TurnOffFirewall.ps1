
Set-ExecutionPolicy RemoteSigned -CurrentScope Process -Force
Set-ExecutionPolicy RemoteSigned -CurrentScope CurrentUser -Force
Set-ExecutionPolicy RemoteSigned -CurrentScope LocalMachine -Force


Set-TimeZone -Id "Eastern Standard Time" -PassThru

netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow 


Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile' -name "EnableFirewall" -Value 0

Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\Standardprofile' -name "EnableFirewall" -Value 0


 ./ShowAllSystemTrayIcons.ps1
