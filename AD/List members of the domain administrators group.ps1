# List members of the domain administrators group.

Get-ADGroupMember -Identity "Domain Admins" | select objectClass, SamAccountName | ft