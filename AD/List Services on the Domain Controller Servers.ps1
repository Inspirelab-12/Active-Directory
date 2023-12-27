# List Services on the Domain Controller Servers

# ---------------------------------------------------------------------------------------#

# Server Names 
$computer = 'D', 'SRV01', 'SRV02' 

# Service Names 
$services = 'ntds', 'adws', 'dns', 'dnscache', 'kdc', 'w32time', 'netlogon' 

# Getthe service status from specified servers 
Get-Service $services -ComputerName $computer | ` 
Sort-Object MachineName, DisplayName | ` 
Select-Object MachineName, DisplayName, Status

# ---------------------------------------------------------------------------------------#