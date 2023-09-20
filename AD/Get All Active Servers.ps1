Import-Module ActiveDirectory
Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' ` -Properties Name,Operatingsystem,OperatingSystemVersion,IPv4Address | Sort-Object -Property Operatingsystem |
Select-Object -Property Name,Operatingsystem,OperatingSystemVersion,IPv4Address | Export-CSV "C:\temp\AllActiveServers.csv" -NoTypeInformation -Encoding UTF8
