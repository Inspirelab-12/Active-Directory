# List all domain groups

Get-ADGroup -Filter * | select SamAccountName, objectClass, GroupCategory, GroupScope | ft -AutoSize | Out-String -Width 4096

# List all Domain Groups  
Get-ADGroup -Filter * | select SamAccountName, objectClass, GroupCategory, GroupScope | Export-CSV "C:\temp\DomainGroups.csv" -NoTypeInformation -Encoding UTF8 
