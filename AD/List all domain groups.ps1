# List all domain groups

Get-ADGroup -Filter * | select SamAccountName, objectClass, GroupCategory, GroupScope | ft -AutoSize | Out-String -Width 4096

# List all Domain Groups Export CSV
 
Get-ADGroup -Filter * | select SamAccountName, objectClass, GroupCategory, GroupScope | ft -AutoSize | Export-CSV "C:\temp\Domain Groups.csv" -NoTypeInformation -Encoding UTF8 
