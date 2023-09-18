# List specific properties from domain computers.

Get-ADComputer -Filter * -Properties * | select Name, Samaccountname, Enabled, DistinguishedName | Format-Table

