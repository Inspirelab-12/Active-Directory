# List All Domain Controllers and Operating System
Get-ADDomainController -Filter * | ft Name,Hostname,OperatingSystem,Enabled  

# List specific properties from domain computers.

Get-ADComputer -Filter * -Properties * | select Name, Samaccountname, Enabled, DistinguishedName | Export-CSV "C:\temp\AllADComputers.csv" -NoTypeInformation -Encoding UTF8  

# List specific properties from domain computers.

Get-ADComputer -Filter * -Property * | Select-Object Name,DNSHostName,OperatingSystem,OperatingSystemServicePack,OperatingSystemVersion,IPv4Address,Lastlogondate | Export-CSV "C:\temp\DomainComputer-Property.csv" -NoTypeInformation -Encoding UTF8





