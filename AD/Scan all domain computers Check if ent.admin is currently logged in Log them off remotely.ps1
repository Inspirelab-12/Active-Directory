#------------------------------------------------------------------------------#
 #---------Full Script: Scan, Logoff, and Report ent.admin Sessions----------#
#------------------------------------------------------------------------------#

# 1. Scan all domain computers
# 2. Check if ent.admin is currently logged in
# 3. Log them off remotely
# 4. Generate a report and save it to C:\Temp\ent_admin_logoff_report.csv

#------------------------------------------------------------------------------#

# Requires RSAT tools
Import-Module ActiveDirectory

$targetUser = "ent.admin"
$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
$results = @()

foreach ($computer in $computers) {
    try {
        $sessions = quser /server:$computer 2>$null
        foreach ($line in $sessions) {
            if ($line -match $targetUser) {
                # Extract session ID (assumes third column)
                $parts = $line -split '\s+'
                $sessionId = $parts[2]

                # Attempt logoff
                try {
                    logoff $sessionId /server:$computer
                    $status = "Logged off"
                } catch {
                    $status = "Failed to log off - $($_.Exception.Message)"
                }

                # Add to report
                $results += [PSCustomObject]@{
                    ComputerName = $computer
                    SessionID    = $sessionId
                    Username     = $targetUser
                    Status       = $status
                    Timestamp    = (Get-Date)
                }

                Write-Host "$targetUser on $computer (Session $sessionId): $status"
            }
        }
    } catch {
        Write-Warning "Could not query $computer - $_"
    }
}

# Export to CSV
$reportPath = "C:\Temp\ent_admin_logoff_report.csv"
$results | Export-Csv -Path $reportPath -NoTypeInformation
Write-Host "Report saved to: $reportPath"
