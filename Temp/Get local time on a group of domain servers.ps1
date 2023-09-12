$servers = Get-ADComputer -Filter * -Properties * | Where-Object OperatingSystem -Like '*Server*' | Select-Object -expand Name
$Results = @()
foreach ($Server in $Servers)
{
$Results += get-wmiobject win32_localtime -ComputerName $Server | 
Select `
@{n='Server';e={$_.PSComputerName}},
Hour,
Minute
}
$Results | export-csv C:\Scripts\Output\ServerTimes.csv -Encoding ASCII -NoTypeInformation