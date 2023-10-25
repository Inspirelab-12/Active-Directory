
# To retrieve information about the installed Application on multiple Client PCs using PowerShell #

# Index 
# 1. For All Products Multiple Client
# 2. For All Products Current Machine 
# 3. For Particular Product Multiple Client (Ex: O365ProPlusRetail)
# 3. For Particular Product Current Machine (Ex: O365ProPlusRetail)


# ------------------------------------------------------------------------------------------------------- #

# 1. For All Products 

foreach ($computer in (Get-Content C:\Script_tests\computers.txt)) {
  write-verbose "Working on $computer..." -Verbose
  Invoke-Command -ComputerName "$Computer" -ScriptBlock {
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
  } | export-csv C:\Script_tests\results.csv -Append -NoTypeInformation
}

# ------------------------------------------------------------------------------------------------------- #

# 2. For All Products Current Machine 

Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Format-Table –AutoSize

# ------------------------------------------------------------------------------------------------------- #

# 3. For Particular Product (Ex: O365ProPlusRetail)

foreach ($computer in (Get-Content C:\Script_tests\computers.txt)) {
  write-verbose "Working on $computer..." -Verbose
  Invoke-Command -ComputerName "$Computer" -ScriptBlock {
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\O365ProPlusRetail* |
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
  } | export-csv C:\Script_tests\results.csv -Append -NoTypeInformation
}

# ------------------------------------------------------------------------------------------------------- #

#4. For Particular Product Current Machine (Ex: O365ProPlusRetail)

Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\O365ProPlusRetail* |  
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Format-Table –AutoSize

# ------------------------------------------------------------------------------------------------------- #