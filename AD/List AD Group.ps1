<#------------------------------------------------------------#

Index

1. Get All AD Groups & Selected Properties
2. Get Groups with a Specific Name
3. Get All Groups from a Specific OU
4. Get All Security Groups
5. Get Selected Group Properties
6. Get AD Groups Using Wildcard Search
<#------------------------------------------------------------#>


#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 1. Get All AD Groups & Selected Properties

Get-ADGroup -filter * | select Name, groupscope, objectclass | Export-CSV "C:\temp\All AD Groups.csv" -NoTypeInformation -Encoding UTF8 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 2. Get Groups with a Specific Name

Get-ADGroup -filter "Name -like 'Acc*'" | Export-CSV "C:\temp\Groups with a Specific Name.csv" -NoTypeInformation -Encoding UTF8 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 3. Get All Groups from a Specific OU

Get-ADGroup -filter * -SearchBase "CN=Users,DC=ASGLAB,DC=LOCAL" | select name, distinguishedName | Export-CSV "C:\temp\Groups from a Specific OU.csv" -NoTypeInformation -Encoding UTF8 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 4. Get All Security Groups

Get-ADGroup -filter "GroupCategory -eq 'Security'" | select name, GroupCategory | Export-CSV "C:\temp\All Security Groups.csv" -NoTypeInformation -Encoding UTF8 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 5. Get Selected Group Properties

Get-ADGroup -identity Administrators -Properties * | Export-CSV "C:\temp\Selected Group Properties.csv" -NoTypeInformation -Encoding UTF8 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 6. Get AD Groups Using Wildcard Search

Get-ADGroup -Filter 'Name -like "*admi*" -or Name -like "*mar*"' | select name | Export-CSV "C:\temp\AD Groups Using Wildcard Search.csv" -NoTypeInformation -Encoding UTF8 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

