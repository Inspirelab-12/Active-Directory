
#List All Administrators 
Get-ADGroupMember -Identity "Administrators" -Recursive | Select-Object "*" | Export-CSV "C:\temp\AllAdministrators.csv" -NoTypeInformation -Encoding UTF8 

#--------------------------

# Domain Admin Users 

# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the domain controller
$domainController = "MYLAB.LOCAL"

# Specify the distinguished name of the Domain Admins group
$domainAdminsGroup = "CN=Domain Admins,CN=Users,DC=ADAVIATION,DC=LOCAL"

# Get Domain Admins group members
$adminUsers = Get-ADGroupMember -Identity $domainAdminsGroup

# Create Report Date & Year 
$LogDate = get-date -f ddMMyyyyhhmm

# Specify the path for the CSV file
$csvFilePath = "C:\reports\AdminUsers_$logDate.csv"

# Create an array to store the results
$results = @()

# Populate the array with user information
foreach ($adminUser in $adminUsers) {
    $userInfo = [PSCustomObject]@{
        "Name"          = $adminUser.Name
        "SamAccountName"= $adminUser.SamAccountName
    }
    $results += $userInfo
}

# Export the results to a CSV file
$results | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "Admin users exported to: $csvFilePath"

 

