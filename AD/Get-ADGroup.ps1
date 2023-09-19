# Get-ADGroup
### -------------------------------------------------------------------------------------- ###
# Get all AD Groups & Limit Properties
Get-ADGroup -filter * | select Name, groupscope, objectclass

# Get groups with a specific name
Get-ADGroup -filter "Name -like 'Acc*'"

# Get all groups from a specific OU
Get-ADGroup -filter * -SearchBase "OU=ADPRO Groups,DC=ad,DC=activedirectorypro,DC=com" | select name, distinguishedName

# Get all Security Groups
Get-ADGroup -filter "GroupCategory -eq 'Security'" | select name, GroupCategory

# Get all AD group properties
Get-ADGroup -identity Administrators -Properties *

#Get AD Groups using wildcard search
Get-ADGroup -Filter 'Name -like "*acc*" -or Name -like "*mar*"' | select name
