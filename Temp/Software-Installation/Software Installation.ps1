$Servers = Get-content "C:\Softwares\hostname.txt"
$Folder= "C:\Softwares\momakensetup.msi" 

Foreach ($Server in $Servers) {
$Test = Test-Path -path "\\$Server\c$\Temp\"

If ($Test -eq $True) {Write-Host "Path exists, hence installing softwares on $Server."}

Else {(Write-Host "Path doesnt exists, hence Creating foldet on $Server and starting installation") , (New-Item -ItemType Directory -Name Temp -Path "\\$Server\c$")}
Echo "Copying Files to C:\Temp\"
Copy-Item $Folder "\\$Server\c$\Temp\"
echo "Second Part :- Installing Software on $Server"
Invoke-Command -ComputerName $Server -ScriptBlock {(&cmd.exe /c MSIEXEC /I "c:\Temp\momakensetup.msi" /qn)  

}

}