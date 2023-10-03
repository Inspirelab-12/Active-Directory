


# List AD Selected User Properties Export CSV
# --------------------------------------------------------------------------------------------------------------------------- 
 Get-ADUser -Identity test1 -Properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8
# --------------------------------------------------------------------------------------------------------------------------- 

# List AD User Properties Export CSV
# --------------------------------------------------------------------------------------------------------------------------- 
Get-ADUser -filter * -properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8 
# ---------------------------------------------------------------------------------------------------------------------------

# List AD Selected User with Selected Objects Export CSV
# ---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -Identity test1 -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\AD-test1-Users.csv" -NoTypeInformation -Encoding UTF8  
# ---------------------------------------------------------------------------------------------------------------------------

# List AD Users with Selected Objects Export CSV
# ---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -filter * -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8  
# ---------------------------------------------------------------------------------------------------------------------------

# List information for both Enabled and Disabled Users
# ---------------------------------------------------------------------------------------------------------------------------
# Get information for both enabled and disabled users
$allUsers = Get-ADUser -Filter * -Properties Name, Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires, Enabled  
# Export all user information to a CSV file
$csvPath = "AllUsers.csv"$allUsers | Select-Object Name, Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires, Enabled | Export-Csv -Path "C:\temp\Enabled-disabled-Users.csv" -NoTypeInformation  
Write-Host "Data exported to $csvPath" 
# ---------------------------------------------------------------------------------------------------------------------------

