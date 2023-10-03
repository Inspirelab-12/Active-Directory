# Plan the reboot on another computer or server

Invoke-Command -ComputerName "FQDNcomputer.domain.tld" -ScriptBlock {
    $action = New-ScheduledTaskAction -Execute 'c:\windows\system32\shutdown.exe' -Argument '-r -t 300' 
    $tomorrow = (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(1)
    $trigger = New-ScheduledTaskTrigger -Once -At $tomorrow
    $settings = New-ScheduledTaskSettingsSet 
    $user = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
    Register-ScheduledTask -TaskName "planned Reboot" -TaskPath "\"  -Action $action -Settings $settings -Trigger $trigger -Principal $user
}   #-Credential get-credential