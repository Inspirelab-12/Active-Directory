#List All Domain Controllers

Get-ADDomainController -filter * | Select hostname, site | export-csv -path c:\temp\all-domain-controllers.csv