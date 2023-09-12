param (
    $localPath = "C:\temp\",
    $remotePath = "/"
    
)
try
{
    # Load WinSCP .NET assembly
    Add-Type -Path "C:\Users\athambiraj\AppData\Local\Programs\WinSCP\WinSCPnet.dll"  ## https://winscp.net/download/WinSCP-5.19.6-Automation.zip
 
    # Setup session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Sftp
    HostName = "10.11.12.52"
    UserName = "mocce-sftp"
    Password = "O@n3#sf7865"
    SshHostKeyFingerprint = "ssh-ed25519 255 cMf0Ev4Wpa6jKwyzl2Ju6Zb8u8IYHNDLSH0iDU9BKiY="
}
 
    $session = New-Object WinSCP.Session
 
    try
    {
        # Connect
        $session.Open($sessionOptions)
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
        $transferResult =
            $session.GetFiles("/root/SFTP/*", "C:\temp\", $False, $transferOptions) #Get files from /root/SFTP/ to D:\ftp-test\

        # Throw on any error
        $transferResult.Check()
 
        # Print results
        foreach ($transfer in $transferResult.Transfers)
        {
           Write-Host "Download of $($transfer.FileName) to $localPath succeeded"
           $transferResult.Transfers     
        }
    }
    finally
    {
        # Disconnect, clean up (Session.Close to exit the session!)
        $session.Close()        
    }
 
    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
    
}