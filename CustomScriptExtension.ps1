

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
.\DownloadInstallMSI.ps1
