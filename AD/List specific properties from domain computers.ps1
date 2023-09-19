# List specific properties from domain computers.

Get-ADComputer -Filter * -Properties * | select Name, Samaccountname, Enabled, DistinguishedName | Export-CSV "C:\temp\AllADComputers.csv" -NoTypeInformation -Encoding UTF8  


