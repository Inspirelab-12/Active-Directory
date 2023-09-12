# Get List of service Running from remote computer
Get-Service -ComputerName dxb-pf0zm8v3 | Where Status -eq "Running" | Out-GridView

#Get List of task running from remote computer 
Get-WmiObject Win32_Process -ComputerName dxb-pf0zm8v3, Win2k8 | Out-GridView