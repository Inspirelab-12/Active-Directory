#List AD Users 
 
Get-ADUser -filter * -properties * | Export-CSV “C:\Temp\ADUser.CSV” –NoTypeInformation 
