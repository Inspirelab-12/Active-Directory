# Server names 
$computer = 'DC01', 'DC02', 'DC03' 
# Service names 
$services = 'ntds', 'adws', 'dns', 'dnscache', 'kdc', 'w32time', 'netlogon' 
# Getthe service status from specified servers 
Get-Service $services -ComputerName $computer | ` 
Sort-Object MachineName, DisplayName | ` 
Select-Object MachineName, DisplayName, Status