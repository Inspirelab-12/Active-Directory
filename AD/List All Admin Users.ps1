
#List Administrators 
Get-ADGroupMember -Identity "Administrators" -Recursive | Select-Object "*" | Export-CSV "C:\temp\AllAdministrators.csv" -NoTypeInformation -Encoding UTF8 

 

