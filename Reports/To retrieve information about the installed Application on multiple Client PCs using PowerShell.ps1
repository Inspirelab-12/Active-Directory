
# To retrieve information about the installed Application on multiple Client PCs using PowerShell #

foreach ($computer in (Get-Content C:\test\computers422.txt)) {
  write-verbose "Working on $computer..." -Verbose
  Invoke-Command -ComputerName "$Computer" -ScriptBlock {
    Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
    Select-Object DisplayName, DisplayVersion, Publisher
  } | export-csv C:\test\results.csv -Append -NoTypeInformation
}