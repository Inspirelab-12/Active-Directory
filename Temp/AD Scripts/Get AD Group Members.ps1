
#####----------Get AD Group Members------########

Get-ADGroupMember -Identity Administrators | Select-Object name, objectClass,distinguishedName | Export-CSV "C:\temp\Domain-Members.csv" -NoTypeInformation -Encoding UTF8


########----------------Get AD Group----------------#######################

Get-ADGroup -Filter {GroupScope -eq "DomainLocal"} | Get-ADGroupMember | Select-Object name, objectClass,distinguishedName 

### 


Get-ADGroupMember -Identity 'Enterprise Admins' -Recursive 
### 

Get-ADGroupMember -Identity Administrators | Select-Object name, objectClass,distinguishedName | Out-GridView 
### 

