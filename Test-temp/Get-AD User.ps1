Search-ADAccount  -UsersOnly -AccountInactive -TimeSpan 30.00:00:00 -SearchBase "Our Searchbase here" -SearchScope Subtree | where {$_.enabled} | Sort | FT Name,LastLogonDate -AutoSize 

Get-ADUser -Filter {Enabled -eq $TRUE} -SearchBase $OU -Properties Name,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-30)) -and ($_.LastLogonDate -ne $NULL)} | Sort | Select Name,SamAccountName,LastLogonDate

Get-ADUser -Filter {Enabled -eq $True} -Property Created,LastLogonDate | Select-Object -Property Name, SAMAccountName, Created, LastLogonDate, mobile | export-csv C:\users.csv