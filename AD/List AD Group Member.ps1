
<# -----------------------------------------------------------#

Index

1. List Selected AD Group Members.
2. List Selected Multiple AD Group Members. 
3. List Selected AD Group Members showing Enable Users. 
4. List Selected AD Group Members recursively.


# -----------------------------------------------------------#>

# 1. List Selected AD Group Members

Get-ADGroupMember -Identity 'Enterprise Admins' | Select-Object name, SamAccountName, objectClass, distinguishedName | Export-CSV "C:\temp\AD- Group-Members.csv" -NoTypeInformation -Encoding UTF8

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

2. List Selected Multiple AD Group Members.

# Import the Active Directory module
Import-Module ActiveDirectory

# Array of group names
$groupNames = @("Group1", "Group2", "Group3")

# Create an array to store the member information
$membersData = @()

# Loop through each group and get its members
foreach ($groupName in $groupNames) {
    $groupMembers = Get-ADGroupMember -Identity $groupName
    foreach ($member in $groupMembers) {
        $memberData = [PSCustomObject]@{
            GroupName       = $groupName
            MemberName      = $member.Name
            SamAccountName  = $member.SamAccountName
        }
        $membersData += $memberData
    }
}

# Export the data to a CSV file
$membersData |  Export-Csv -Path "C:\temp\GroupMembers.csv" -NoTypeInformation 

Write-Host "Group members exported to GroupMembers.csv"

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 3. List Selected AD Group Members showing Enabled Users.  
 
 $groupname = "Domain Admins"
 $users = Get-ADGroupMember -Identity $groupname | ? {$_.objectclass -eq "user"}
 $result = @()
 foreach ($activeusers in $users) { $result += (Get-ADUser -Identity $activeusers | ? {$_.enabled -eq $true} | select Name, SamAccountName, UserPrincipalName, Enabled) }
 $result | Export-CSV "C:\temp\AD Group Enable and Disabled Users.csv" -NoTypeInformation -Encoding UTF8 

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# 4. List Selected AD Group Members recursively.

Get-ADGroupMember -Identity "Domain Admins" -Recursive | select name, SamAccountName, objectClass, distinguishedName | ft

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#






