# List Disabled User
Search-ADAccount –AccountDisabled –UsersOnly –ResultPageSize 2000 –ResultSetSize $null | Select-Object SamAccountName, objectClass | Export-CSV “C:\Temp\DisabledUsers.csv” –NoTypeInformation 
