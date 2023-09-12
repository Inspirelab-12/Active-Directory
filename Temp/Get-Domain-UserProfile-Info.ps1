Get-ADUser -filter * -properties PasswordExpired, PasswordLastSet, PasswordNeverExpires, EmailAddress, Title, Manager | ft Name, PasswordExpired, PasswordLastSet, PasswordNeverExpires, EmailAddress, Title, Manager 

