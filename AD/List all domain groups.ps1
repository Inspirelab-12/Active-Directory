# List all domain groups

Get-ADGroup -Filter * | select SamAccountName, objectClass, GroupCategory, GroupScope | ft -AutoSize | Out-String -Width 4096