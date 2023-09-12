$Sector = 'Support1'

Get-ADUser -Filter {department -eq "test dept12" -or department -eq "test dept1000"} | Where-Object Enabled | Set-ADUser -Replace @{ extensionAttribute15 = $Sector }