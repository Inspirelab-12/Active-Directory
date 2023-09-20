Get-ADDomainController -Filter * | ft Name,Hostname,OperatingSystem,Enabled  | Export-CSV "C:\temp\AllADDomainController.csv" -NoTypeInformation -Encoding UTF8 

