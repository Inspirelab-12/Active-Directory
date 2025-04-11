# Get all computers from Active Directory
$computers = Get-ADComputer -Filter * -Property Name | Select-Object -ExpandProperty Name
$targetUser = "ent.admin"
$loggedInHosts = @()

foreach ($computer in $computers) {
    try {
        $sessions = quser /server:$computer 2>$null
        if ($sessions -match $targetUser) {
            Write-Host "$targetUser is logged in on $computer"
            $loggedInHosts += $computer
        }
    } catch {
        Write-Warning "Could not query $computer - $_"
    }
}

# Optional: Export to file
$loggedInHosts | Sort-Object | Out-File "C:\temp\ent.admin_logins.txt"
