$targets = @("ADADCHV08", "ADARADIUS", "ADANWBKP")
foreach ($server in $targets) {
    try {
        $sessions = quser /server:$server | Where-Object { $_ -match "ent\.admin" }
        foreach ($session in $sessions) {
            $sessionId = ($session -split "\s+")[2]
            logoff $sessionId /server:$server
            Write-Host "Logged off ent.admin from $server session ID $sessionId"
        }
    } catch {
        Write-Warning "Could not log off from $server - $_"
    }
}
