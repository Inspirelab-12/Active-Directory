 #  List all members from AD group showing enable and disabled users.  

$groupname = "Domain Admins"$users = Get-ADGroupMember -Identity $groupname | ? {$_.objectclass -eq "user"}$result = @()foreach ($activeusers in $users) { $result += (Get-ADUser -Identity $activeusers | ? {$_.enabled -eq $true} | select Name, SamAccountName, UserPrincipalName, Enabled) }$result | Export-CSV "C:\temp\Domain Admins.csv" -NoTypeInformation -Encoding UTF8 
