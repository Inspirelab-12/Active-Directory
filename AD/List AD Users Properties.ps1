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

# --------------------------------------------------------------------------------------------------------------------------- #

# 1. List AD Selected User Properties Export CSV

 Get-ADUser -Identity User01 -Properties * | Export-CSV "C:\temp\AD Selected User Properties.csv" -NoTypeInformation -Encoding UTF8

# --------------------------------------------------------------------------------------------------------------------------- #

# 2. List AD User Properties Export CSV

Get-ADUser -filter * -properties * | Export-CSV "C:\temp\AD User Properties.csv" -NoTypeInformation -Encoding UTF8 

# --------------------------------------------------------------------------------------------------------------------------- #

# 3. List AD Selected User with Selected Objects Export CSV

Get-ADUser -Identity User01 -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, whenChanged, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\Selected User with Selected Objects.csv" -NoTypeInformation -Encoding UTF8  

# --------------------------------------------------------------------------------------------------------------------------- #

# 4. List AD Users with Selected Objects Export CSV

Get-ADUser -filter * -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, whenChanged, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\AD Users with Selected Objects.csv" -NoTypeInformation -Encoding UTF8  
# --------------------------------------------------------------------------------------------------------------------------- #

# 5. List information for Enabled Users Export CSV

# Get information for enabled users
$enabledUsers = Get-ADUser -Filter {Enabled -eq $true} -Properties DisplayName, SamAccountName, EmailAddress, Office, Department

# Specify the path for the CSV file
$csvFilePath = "C:\temp\EnabledUsers.csv"

# Export the user information to a CSV file
$enabledUsers | Select-Object DisplayName, SamAccountName, EmailAddress, Office, Department | Export-Csv -Path $csvFilePath -NoTypeInformation

# Display a message confirming the export
Write-Host "Enabled user information exported to $csvFilePath."

# --------------------------------------------------------------------------------------------------------------------------- # 

# 6. List information for Disabled Users Export CSV

# Get information for disabled users
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties DisplayName, SamAccountName, EmailAddress, Office, Department

# Specify the path for the CSV file
$csvFilePath = "C:\temp\DisabledUsers.csv"

# Export the user information to a CSV file
$disabledUsers | Select-Object DisplayName, SamAccountName, EmailAddress, Office, Department | Export-Csv -Path $csvFilePath -NoTypeInformation

# Display a message confirming the export
Write-Host "Disabled user information exported to $csvFilePath."

# --------------------------------------------------------------------------------------------------------------------------- #

# 7. List information for both Enabled and Disabled Users Export CSV

# Get information for both Enabled and Disabled Users Export CSV
$allUsers = Get-ADUser -Filter * -Properties Name, Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires, Enabled  
# Export all user information to a CSV file
$csvPath = "Enabled-disabled-Users.csv"
$allUsers | Select-Object Name, Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires, Enabled | Export-Csv -Path "C:\temp\Enabled and Disabled Users.csv" -NoTypeInformation  
Write-Host "Data exported to $csvPath" 

# --------------------------------------------------------------------------------------------------------------------------- #

