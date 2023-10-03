#List AD User Properties
#--------------------------------------------------------------------------------------------------------------------------- 
 Get-ADUser -Identity test1 -Properties *  
#--------------------------------------------------------------------------------------------------------------------------- 

#List AD User Properties Export CSV
#--------------------------------------------------------------------------------------------------------------------------- 
Get-ADUser -filter * -properties * | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8 
#---------------------------------------------------------------------------------------------------------------------------

#List AD Users with Selected Objects Export CSV
#---------------------------------------------------------------------------------------------------------------------------
Get-ADUser -filter * -properties * | Select-Object Displayname, Samaccountname, ObjectClass, title, department, EmailAddress, mobile, whenCreated, LastLogonDate, PasswordExpired, PasswordLastSet, PasswordNeverExpires | Export-CSV "C:\temp\ADUsers.csv" -NoTypeInformation -Encoding UTF8  
#---------------------------------------------------------------------------------------------------------------------------
