#List AD Users 
#--------------------------------------------------------------------------------------------------------------------------- 
Get-ADUser -filter * -properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8 
#---------------------------------------------------------------------------------------------------------------------------


#List AD Users with Object Selection
#---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -filter * -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8  
#---------------------------------------------------------------------------------------------------------------------------
