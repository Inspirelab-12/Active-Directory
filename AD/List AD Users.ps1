#List AD Selected User Properties Export CSV
#--------------------------------------------------------------------------------------------------------------------------- 
 Get-ADUser -Identity test1 -Properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8 | 
#--------------------------------------------------------------------------------------------------------------------------- 

#List AD User Properties Export CSV
#--------------------------------------------------------------------------------------------------------------------------- 
Get-ADUser -filter * -properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8 
#---------------------------------------------------------------------------------------------------------------------------

#List AD Selected User with Selected Objects Export CSV
#---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -Identity test1 -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\AD-test1-Users.csv" -NoTypeInformation -Encoding UTF8  
#---------------------------------------------------------------------------------------------------------------------------

#List AD Users with Selected Objects Export CSV
#---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -filter * -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8  
#---------------------------------------------------------------------------------------------------------------------------
