$serverList = "D:\New folder\servers.txt"
$scriptpath = $MyInvocation.MyCommand.Path
#$dir = Split-Path $scriptpath
pushd $dir
 
[System.Collections.ArrayList]$sysCollection = New-Object System.Collections.ArrayList($null)
  
foreach ($server in (Get-Content $serverList))
{
    "Collecting information from $server"
    $totCores=0
  
    try
    {
        [wmi]$user = Get-WmiObject Win32_Computersystem -ComputerName $server 
        [wmi]$sysInfo = get-wmiobject Win32_ComputerSystem -Namespace "root\CIMV2" -ComputerName $server -ErrorAction Stop
        [wmi]$bios = Get-WmiObject Win32_BIOS -Namespace "root\CIMV2" -computername $server
        [wmi]$os = Get-WmiObject Win32_OperatingSystem -Namespace "root\CIMV2" -Computername $server
        [array]$disks = Get-WmiObject Win32_LogicalDisk -Namespace "root\CIMV2" -Filter DriveType=3 -Computername $server
        [array]$disks = Get-WmiObject Win32_LogicalDisk -Namespace "root\CIMV2" -Computername $server
        [array]$procs = Get-WmiObject Win32_Processor -Namespace "root\CIMV2" -Computername $server
        [array]$mem = Get-WmiObject Win32_PhysicalMemory -Namespace "root\CIMV2" -ComputerName $server
        [array]$nic = Get-WmiObject Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2" -ComputerName $server | where{$_.IPEnabled -eq "True"}
  
        $si = @{
            user            =[string]$sysinfo.username
            Server          = [string]$server
            Manufacturer    = [string]$sysInfo.Manufacturer
            Model           = [string]$sysInfo.Model
            TotMem          = "$([string]([System.Math]::Round($sysInfo.TotalPhysicalMemory/1gb,2))) GB"
            BiosDesc        = [string]$bios.Description
            BiosVer         = [string]$bios.SMBIOSBIOSVersion+"."+$bios.SMBIOSMajorVersion+"."+$bios.SMBIOSMinorVersion
            BiosSerial      = [string]$bios.SerialNumber
            OSName          = [string]$os.Name.Substring(0,$os.Name.IndexOf("|") -1)
            ServicePack = (“SP {0}” -f [string]$os.ServicePackMajorVersion)
            Arch            = [string]$os.OSArchitecture
            Processors      = [string]@($procs).count
            Cores           = [string]$procs[0].NumberOfCores

        }
         
        $disks | foreach-object {$si."Drive$($_.Name -replace ':', '')"="$([string]([System.Math]::Round($_.Size/1gb,2))) GB"}

       
       
    }
    catch [Exception]
    {
        "Error communicating with $server, skipping to next"
        $si = @{
            Server          = [string]$server
            ErrorMessage    = [string]$_.Exception.Message
            ErrorItem       = [string]$_.Exception.ItemName
        }
        Continue
    }
    finally
    {
       [void]$sysCollection.Add((New-Object PSObject -Property $si))   
    }
}
  
$sysCollection `
    | select-object user,Server,TotMem,OSName,Arch,ServicePack,Processors,Cores,Manufacturer,Model,BiosDesc,BiosVer,BiosSerial,DriveA,DriveB,DriveC,DriveD,DriveE,DriveF,DriveG,DriveH,DriveI,DriveJ,DriveK,DriveL,DriveM,DriveN,DriveO,DriveP,DriveQ,DriveR,DriveS,DriveT,DriveU,DriveV,DriveW,DriveX,DriveY,DriveZ,ErrorMessage,ErrorItem `
    | sort -Property Server `
    | Export-CSV -path "D:\New folder\result.csv" -NoTypeInformation  
    Write-Host "inventory completed check $outputCSV" -backgroundcolor "green"

    #Export-Csv E:\diskutilizationreport.cs