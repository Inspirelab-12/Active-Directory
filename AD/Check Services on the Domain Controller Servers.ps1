# Server names 
$computer = 'ADAADC01', 'ADADCHV08', 'ADA-DRAD01' 
# Service names 
$services = 'ntds', 'adws', 'dns', 'dnscache', 'kdc', 'w32time', 'netlogon' 
# Getthe service status from specified servers 
Get-Service $services -ComputerName $computer | ` 
Sort-Object MachineName, DisplayName | ` 
Select-Object MachineName, DisplayName, Status