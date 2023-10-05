
<# -----------------------------------------------------------#

Index

1. List Selected AD Group Members.
2. List Selected AD Group Members showing Enable Users. 
3. List Selected AD Group Members recursively.

# -----------------------------------------------------------#>

# 1. List Selected AD Group Members

Get-ADGroupMember -Identity 'Enterprise Admins' | Select-Object name, SamAccountName, objectClass, distinguishedName | Export-CSV "C:\temp\AD- Group-Members.csv" -NoTypeInformation -Encoding UTF8

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 2. List Selected AD Group Members showing Enabled Users.  
 
 $groupname = "Domain Admins"
 $users = Get-ADGroupMember -Identity $groupname | ? {$_.objectclass -eq "user"}
 $result = @()
 foreach ($activeusers in $users) { $result += (Get-ADUser -Identity $activeusers | ? {$_.enabled -eq $true} | select Name, SamAccountName, UserPrincipalName, Enabled) }
 $result | Export-CSV "C:\temp\AD Group Enable and Disabled Users.csv" -NoTypeInformation -Encoding UTF8 

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 3. List Selected AD Group Members recursively.

Get-ADGroupMember -Identity "Domain Admins" -Recursive | select name, SamAccountName, objectClass, distinguishedName | ft

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#






