# Need to check again
 
 $group = gwmi win32_group -filter 'Name = "Administrators"'
$group.GetRelated('Win32_UserAccount') | Out-GridView

#List Administrators 
Get-ADGroupMember -Identity "Administrators" -Recursive | Select-Object "*" | Export-CSV "C:\temp\Administrators.csv" -NoTypeInformation -Encoding UTF8 

 
