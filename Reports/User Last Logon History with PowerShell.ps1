
# User Last Logon History with PowerShell #

# ---------------------------------------------------------------------------------------------------------------- #

# a username, whose logon history you want to view
$checkuser='*1436*'
# getting information about the user logon history for the last 2 days (you can change this value)
$startDate = (get-date).AddDays(-2)
$DCs = Get-ADDomainController -Filter *
foreach ($DC in $DCs){
$logonevents = Get-Eventlog -LogName Security -InstanceID 4624 -after $startDate -ComputerName $dc.HostName
foreach ($event in $logonevents){
if (($event.ReplacementStrings[5] -notlike '*$') -and ($event.ReplacementStrings[5] -like $checkuser)) {
# Remote (Logon Type 10)
if ($event.ReplacementStrings[8] -eq 10){
write-host "Type 10: Remote Logon`tDate: "$event.TimeGenerated "`tStatus: Success`tUser: "$event.ReplacementStrings[5] "`tWorkstation: "$event.ReplacementStrings[11] "`tIP Address: "$event.ReplacementStrings[18] "`tDC Name: " $dc.Name
}
# Network(Logon Type 3)
if ($event.ReplacementStrings[8] -eq 3){
write-host "Type 3: Network Logon`tDate: "$event.TimeGenerated "`tStatus: Success`tUser: "$event.ReplacementStrings[5] "`tWorkstation: "$event.ReplacementStrings[11] "`tIP Address: "$event.ReplacementStrings[18] "`tDC Name: " $dc.Name
}
}
}
}

# ---------------------------------------------------------------------------------------------------------------- #

# User Logon History Based on Kerberos Events #

# ---------------------------------------------------------------------------------------------------------------- #

$alluserhistory = @()
$startDate = (get-date).AddDays(-1)
$DCs = Get-ADDomainController -Filter *
foreach ($DC in $DCs){
$logonevents = Get-Eventlog -LogName Security -InstanceID 4768 -after $startDate -ComputerName $dc.HostName
foreach ($event in $logonevents){
if ($event.ReplacementStrings[0] -notlike '*$') {
$userhistory = New-Object PSObject -Property @{
UserName = $event.ReplacementStrings[0]
IPAddress = $event.ReplacementStrings[9]
Date = $event.TimeGenerated
DC = $dc.Name
}
$alluserhistory += $userhistory
}
}
}
$alluserhistory

# ---------------------------------------------------------------------------------------------------------------- #
