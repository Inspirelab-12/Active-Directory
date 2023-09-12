# Get-ADUser -Filter 'city -eq "Amsterdam"' -SearchBase "OU=Marketing,OU=Amsterdam,OU=Sites,DC=Lazyadmin,DC=NL" | Set-ADUser -StreetAddress "Westerdok 1" -PostalCode "2312ab"


# Get-ADUser -Properties Department | Select-Object SamAccountName,Department

# Get-ADUser -Filter 'enabled -eq $true' -properties Department,Description,Enabled,Title -SearchBase "*Insert company*"| export-csv users.csv


# Get-ADUser -SearchBase "OU=SALES,DC=SHELLPRO,DC=LOCAL" -filter * |  Set-ADUser  -Replace @{company="SHELLGEEK"}





fetch Users from department 
update attribute 


#create powershell script to update this attribute "extensionAttribute20" with value "Support Services Sector"
whenever user departmet eaual ("Human Resources" or "Financial Resources" or "Information Technology") 


#Get-ADUser -Filter 'Department -like "*"' -Properties * | Set-ADUser -Identity "*" -Replace @{extensionAttribute20 = $"Support Services Sector" }

#Get-ADUser -Filter 'Department -like "*"' -Properties * |  Export-Csv "C:\ad-users-department.csv"  

Set-ADUser -Identity "*" -Replace @{extensionAttribute20 = $"Support Services Sector" }


    Get-ADUser -Filter * -property displayname | where {$_.displayname -eq $User.EmployeeFullName} | Set-ADUser -department $User.Department -Division $User.Division -Title $User.JobTitle -Manager $User.LineMangerFullname -info $User.Service -departmentNumber $User.'Cost Centre'


    Get-ADUser -Filter 'Department -like "*"' -Properties * | Set-ADUser -Identity "*" -Replace @{extensionAttribute20 = $"Support Services Sector" }

    Get-ADUser -Filter 'Department -like "*"' -Properties * | 
    
    Set-ADUser -Identity Department -like "Human Resources" -Replace @{extensionAttribute20 = $"Support Services Sector" }


    Get-ADUser -filter {(Mail -like 'User@OldDomain.com')} -Properties * | Set-ADUser -Replace @{$_.MSExchExtensionAttribute33="GLOBAL"; $_.MSExchExtensionAttribute34="4"; $_.msExchExtensionAttribute35="SMTP:User@NewDomain.com"};


    Get-ADUser -Filter 'Department -like "Human Resources"; "Financial Resources"; Information Technology";' -Properties * | Set-ADUser -Replace @{extensionAttribute20 = $"Support Services Sector" }

    Set-ADUser -Identity Department -like "Human Resources" -Replace @{extensionAttribute20 = $"Support Services Sector" }
