# Get all AD Groups & Limit Properties
Get-ADGroup -filter * | select Name, groupscope, objectclass | Export-CSV "C:\temp\AllADGroup.csv" -NoTypeInformation -Encoding UTF8 


# Get groups with a specific name
Get-ADGroup -filter "Name -like 'Acc*'" | Export-CSV "C:\temp\AllADGroupspecificname.csv" -NoTypeInformation -Encoding UTF8 


# Get all groups from a specific OU
Get-ADGroup -filter * -SearchBase "OU=ADPRO Groups,DC=ad,DC=activedirectorypro,DC=com" | select name, distinguishedName | Export-CSV "C:\temp\AllADGroupspecificOU.csv" -NoTypeInformation -Encoding UTF8 


# Get all Security Groups
Get-ADGroup -filter "GroupCategory -eq 'Security'" | select name, GroupCategory | Export-CSV "C:\temp\AllADGroupSecurityGroups.csv" -NoTypeInformation -Encoding UTF8 


# Get all AD group properties
Get-ADGroup -identity Administrators -Properties * | Export-CSV "C:\temp\AllADGroupGroupProperties.csv" -NoTypeInformation -Encoding UTF8 


#Get AD Groups using wildcard search
Get-ADGroup -Filter 'Name -like "*acc*" -or Name -like "*mar*"' | select name | Export-CSV "C:\temp\AllADGroupWildcardSearch.csv" -NoTypeInformation -Encoding UTF8 

