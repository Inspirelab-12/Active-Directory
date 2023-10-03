# Index #
# --------------------------------------------------------------------- #
# 1. List AD Selected User Properties Export CSV
# 2. List AD User Properties Export CSV
# 3. List AD Selected User with Selected Objects Export CSV
# 4. List AD Users with Selected Objects Export CSV
# 5. List information for Enabled users Export CSV
# 6. List information for Disabled users Export CSV
# 7. List information for both Enabled and Disabled Users Export CSV
# --------------------------------------------------------------------- #


# 1. List AD Selected User Properties Export CSV
# --------------------------------------------------------------------------------------------------------------------------- #
 Get-ADUser -Identity test1 -Properties * | Export-CSV "C:\temp\AD-Selected-Users.csv" -NoTypeInformation -Encoding UTF8
# --------------------------------------------------------------------------------------------------------------------------- #

# 2. List AD User Properties Export CSV
# --------------------------------------------------------------------------------------------------------------------------- # 
Get-ADUser -filter * -properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8 
# --------------------------------------------------------------------------------------------------------------------------- #
# 3. List AD Selected User with Selected Objects Export CSV
# ---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -Identity test1 -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\AD-Selected-Prop-Selected-Users.csv" -NoTypeInformation -Encoding UTF8  
# --------------------------------------------------------------------------------------------------------------------------- #

# 4. List AD Users with Selected Objects Export CSV
# --------------------------------------------------------------------------------------------------------------------------- #
Get-ADUser -filter * -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\AD-Selected-Prop-Users.csv" -NoTypeInformation -Encoding UTF8  
# --------------------------------------------------------------------------------------------------------------------------- #

# 5. List information for Enabled users Export CSV
# --------------------------------------------------------------------------------------------------------------------------- #
$enabledUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties *
Write-Host "Enabled Users:"
$enabledUsers | Format-Table Name, SamAccountName, EmailAddress, Enabled | Export-Csv -Path "C:\temp\Disabled-Users.csv" -NoTypeInformation  
Write-Host "Data exported to C:\temp\Disabled-Users.csv"  
# --------------------------------------------------------------------------------------------------------------------------- # 

# 6. List information for Disabled users Export CSV
# --------------------------------------------------------------------------------------------------------------------------- #
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties *
Write-Host "Disabled Users:"
$disabledUsers | Format-Table Name, SamAccountName, EmailAddress, Enabled | Export-Csv -Path "C:\temp\Enabled-Users.csv" -NoTypeInformation  
Write-Host "Data exported to C:\temp\Enabled-Users.csv" 
# --------------------------------------------------------------------------------------------------------------------------- #

# 7. List information for both Enabled and Disabled Users Export CSV
# --------------------------------------------------------------------------------------------------------------------------- #
# Get information for both Enabled and Disabled Users Export CSV
$allUsers = Get-ADUser -Filter * -Properties Name, Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires, Enabled  
# Export all user information to a CSV file
$csvPath = "Enabled-disabled-Users.csv"
$allUsers | Select-Object Name, Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires, Enabled | Export-Csv -Path "C:\temp\Enabled-disabled-Users.csv" -NoTypeInformation  
Write-Host "Data exported to $csvPath" 
# --------------------------------------------------------------------------------------------------------------------------- #

