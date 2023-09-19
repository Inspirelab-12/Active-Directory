#Get Members of the Domain Admins Group
#-----------------------------------------------------------
Get-ADGroupMember -Identity "Domain Admins" | Select-Object -Property Name, SamAccountName, DisplayName