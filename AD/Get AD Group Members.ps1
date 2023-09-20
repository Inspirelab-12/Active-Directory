
#Get AD Group Members

Get-ADGroupMember -Identity Administrators | Select-Object name, objectClass,distinguishedName | Export-CSV "C:\temp\Domain-Members.csv" -NoTypeInformation -Encoding UTF8

#Get AD Group

Get-ADGroup -Filter {GroupScope -eq "DomainLocal"} | Get-ADGroupMember | Select-Object name, objectClass,distinguishedName 

#Get AD Group Member Specific Name
Get-ADGroupMember -Identity 'Enterprise Admins' -Recursive 

#Get AD Group Member Specific Name
Get-ADGroupMember -Identity Administrators | Select-Object name, objectClass,distinguishedName | Out-GridView 

# Get Group Membership
#---------------------------------

Get-ADPrincipalGroupMembership xxxx | select name,groupscope

# Exambles
#--------------------------------------------------------------------------------------------------------------
# Get Global Security Group for a user is a member of
# 	Get-ADPrincipalGroupMembership xxxx | select name,groupscope | Where-Object Groupscope -eq "Global"

# Get Local Security Group for a user is a member of
#  	Get-ADPrincipalGroupMembership xxxx | select name,groupscope | Where-Object Groupscope -eq "domainlocal"
