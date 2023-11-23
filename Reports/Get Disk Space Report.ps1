# Specify the path to the text file containing computer names
$computerListFile = "C:\Reports\Scripts\serverslist.txt"

# Read the list of computer names from the file
$computers = Get-Content $computerListFile

# Create an empty array to store the report data
$report = @()

# Create Report Date & Year 
$LogDate = get-date -f ddMMyyyyhhmm

# Iterate through each remote computer and gather disk space information
foreach ($computer in $computers) {
    $driveInfo = Invoke-Command -ComputerName $computer -ScriptBlock {
        $drives = Get-WmiObject Win32_LogicalDisk

        $driveInfo = $drives | ForEach-Object {
            [PSCustomObject]@{
                ComputerName = $env:COMPUTERNAME
                DriveLetter = $_.DeviceID
                DriveLabel = $_.VolumeName
                DriveSize_GB = [math]::Round($_.Size / 1GB, 2)
                FreeSpace_GB = [math]::Round($_.FreeSpace / 1GB, 2)
                UsedSpace_GB = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)
                PercentageFree = [math]::Round(($_.FreeSpace / $_.Size) * 100, 2)
            }
        }

        return $driveInfo
    }

    $report += $driveInfo
}

# Export the combined report to a CSV file
$report | Export-Csv -Path "C:\reports\disk_space_report_$logDate.csv" -NoTypeInformation

# Display the combined report
$report | Format-Table -AutoSize
