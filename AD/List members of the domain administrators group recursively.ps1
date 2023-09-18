# List members of the domain administrators group recursively.
Get-ADGroupMember -Identity "Domain Admins" -Recursive | select objectClass, SamAccountName | ft