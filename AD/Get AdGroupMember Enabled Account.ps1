# Get AdGroupMember Enabled Account
#------------------------------------------------
$group = "SALESLEADER"

$adusers = Get-ADGroupMember -Identity $group | where {$_.objectclass -eq "user"}

foreach ($activeuser in $adusers) 
{ 

    Get-ADUser -Identity $activeuser | where {$_.enabled -eq $true} | select Name, SamAccountName, UserPrincipalName, Enabled 
    
 }

