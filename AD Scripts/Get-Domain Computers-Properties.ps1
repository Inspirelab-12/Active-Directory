Get-ADComputer -Filter * -Property * | Select-Object Name,DNSHostName,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion,IPv4Address,Lastlogondate | Export-CSV "C:\temp\All-Windows.csv" -NoTypeInformation -Encoding UTF8

