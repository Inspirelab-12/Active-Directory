$Servers = Get-content "E:\PowerShell Script\Software-Installation\hostnames.txt"
$Folder= "E:\PowerShell Script\Software-Installation\googlechromestandaloneenterprise64.msi" 

Foreach ($Server in $Servers) {
$Test = Test-Path -path "\\$Server\c$\Temp\"

If ($Test -eq $True) {Write-Host "Path exists, hence installing softwares on $Server."}

Else {(Write-Host "Path doesnt exists, hence Creating foldet on $Server and starting installation") , (New-Item -ItemType Directory -Name Temp -Path "\\$Server\c$")}
Echo "Copying Files to C:\Temp\"
Copy-Item $Folder "\\$Server\c$\Temp\"
echo "Second Part :- Installing Software on $Server"
Invoke-Command -ComputerName $Server -ScriptBlock {(&cmd.exe /c MSIEXEC /I "c:\Temp\googlechromestandaloneenterprise64.msi" /qn)  , (Remove-Item -path "C:\Temp\googlechromestandaloneenterprise64.msi" -ErrorAction Ignore)

}

}