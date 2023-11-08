$OldReports = (Get-Date).AddDays(-0)
Get-ChildItem C:\temp\serverslist.txt | `
Where-Object { $_.LastWriteTime -le $OldReports} | `
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue 
$LogDate = get-date -f yyyyMMddhhmm
$File = Get-Content -Path C:\temp\serverslist.txt
$DiskReport = ForEach ($Servernames in ($File))

{Get-WmiObject win32_logicaldisk <#-Credential $RunAccount#> `
-ComputerName $Servernames -Filter "Drivetype=3" `
-ErrorAction SilentlyContinue
}

$DiskReport |

Select-Object @{Label = "Server Name";Expression = {$_.SystemName}},
@{Label = "Drive Letter";Expression = {$_.DeviceID}},
@{Label = "Total Capacity (GB)";Expression = {"{0:N1}" -f( $_.Size / 1gb)}},
@{Label = "Free Space (GB)";Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) }},
@{Label = 'Free Space (%)'; Expression = {"{0:P0}" -f ($_.freespace/$_.size)}} |

Export-Csv -path "C:\temp\DiskReport_$logDate.csv" –NoTypeInformation