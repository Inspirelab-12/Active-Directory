<#
.SYNOPSIS
Get Operating System info.
.DESCRIPTION
Gets Operating system info for list of servers. 
List of servers is in txt file in 01servers folder or list of strings with names of computers.

CmdLet has two ParameterSets one for list of computers from file and another from list of strings as computer names.

Errors will be saved in log folder PSLogs with name Error_Log.txt. Parameter errorlog controls logging of errors in log file.

Get-OSInfo function uses Get-CimInstance -Class CIM_OperatingSystem PowerShell function to get OS info.

Result shows following columns: Environment (PROD, Acceptance, Test, Course...), 
LogicalName (Application, web, integration, FTP, Scan, Terminal Server...), ServerName, Caption, CSDVersion, Version,
OSArchitecture, Install Date, Last BootUp Time, SystemDrive, WindowsDirectory, FreePhysicalMemory, FreeSpaceInPagingFiles, 
FreeVirtualMemory, NumberOfProcesses, NumberOfUsers, SizeStoredInPagingFile, TotalVirtualMemorySize, TotalVisibleMemorySize, IP

.PARAMETER computers
List of computers that we want to get OS Info from. Parameter belongs to default Parameter Set = ServerNames.
.PARAMETER filename
Name of txt file with list of servers that we want to check OS info. .txt file should be in 01servers folder.
Parameter belongs to Parameter Set = FileName.
.PARAMETER errorlog
Switch parameter that sets to write to log or not to write to log. Error file is in PSLog folder with name Error_Log.txt.
.PARAMETER client
OK - O client
BK - B client
etc.
.PARAMETER solution
FIN - Financial 
HR - Humane resource
etc. 

.EXAMPLE
Get-OSInfo -client "OK" -solution "FIN"

Description
---------------------------------------
Test of default parameter with default value ( computers = 'localhost' ) in default ParameterSet = ServerName.

.EXAMPLE
Get-OSInfo -client "OK" -solution "FIN" -Verbose

Description
---------------------------------------
Test of Verbose parameter. NOTE: Notice how localhost default value of parameter computers replaces with name of server.

.EXAMPLE
'ERROR' | Get-OSInfo -client "OK" -solution "FIN" -errorlog

Description
---------------------------------------
Test of errorlog parameter. There is no server with name ERROR so this call will fail and write to Error log since errorlog switch parameter is on. Look Error_Log.txt file in PSLogs folder.

.EXAMPLE
Get-OSInfo -computers 'APP100001' -client "OK" -solution "FIN" -errorlog

Description
---------------------------------------
Test of computers parameter with one value. Parameter accepts array of strings.

.EXAMPLE
Get-OSInfo -computers 'APP100001', 'APP100002' -client "OK" -solution "FIN" -errorlog -Verbose

Description
---------------------------------------
Test of computers parameter with array of strings. Parameter accepts array of strings.

.EXAMPLE
Get-OSInfo -hosts 'APP100001' -client "OK" -solution "FIN" -errorlog

Description
---------------------------------------
Test of computers paramater alias hosts.

.EXAMPLE
Get-OSInfo -computers (Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" )) -client "OK" -solution "FIN" -errorlog -Verbose

Description
---------------------------------------
Test of computers parameter and values for parameter comes from .txt file that has list of servers.

.EXAMPLE
'APP100001' | Get-OSInfo -client "OK" -solution "FIN" -errorlog

Description
---------------------------------------
Test of pipeline by value of computers parameter.

.EXAMPLE
'APP100001', 'APP100002' | Get-OSInfo -client "OK" -solution "FIN" -errorlog -Verbose

Description
---------------------------------------
Test of pipeline by value with array of strings of computers parameter.

.EXAMPLE
'APP100001', 'APP100002' | Select-Object @{label="computers";expression={$_}} | Get-OSInfo -client "OK" -solution "FIN" -errorlog

Description
---------------------------------------
Test of values from pipeline by property name (computers).

.EXAMPLE
Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" ) | Get-OSInfo -client "OK" -solution "FIN" -errorlog -Verbose

Description
---------------------------------------
Test of pipeline by value that comes as content of .txt file with list of servers.

.EXAMPLE
Help Get-OSInfo -Full

Description
---------------------------------------
Test of Powershell help.

.EXAMPLE
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose

Description
---------------------------------------
This is test of ParameterSet = FileName and parameter filename. There is list of servers in .txt file.

.EXAMPLE
Get-OSInfo -file "OKFINserverss.txt" -errorlog -client "OK" -solution "FIN" -Verbose

Description
---------------------------------------
This is test of ParameterSet = FileName and parameter filename. This test will fail due to wrong name of the .txt file with warning message "WARNING: This file path does NOT exist:".

.INPUTS
System.String

Computers parameter pipeline both by Value and by Property Name value and has default value of localhost. (Parameter Set = ComputerNames)
Filename parameter does not pipeline and does not have default value. (Parameter Set = FileName)
.OUTPUTS
System.Management.Automation.PSCustomObject

Get-OSInfo returns PSCustomObjects which has been converted from PowerShell function Get-CimInstance -Class CIM_OperatingSystem
Result shows following columns: Environment (PROD, Acceptance, Test, Course...), 
LogicalName (Application, web, integration, FTP, Scan, Terminal Server...), ServerName, Caption, CSDVersion, Version,
OSArchitecture, Install Date, Last BootUp Time, SystemDrive, WindowsDirectory, FreePhysicalMemory, FreeSpaceInPagingFiles, 
FreeVirtualMemory, NumberOfProcesses, NumberOfUsers, SizeStoredInPagingFile, TotalVirtualMemorySize, TotalVisibleMemorySize, IP

.NOTES
FunctionName : Get-OSInfo
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK 
https://improvescripting.com/how-to-get-windows-operating-system-details-using-powershell/
Get-CimInstance -Class CIM_OperatingSystem
Get-CimInstance -Class Win32_OperatingSystem
#>
Function Get-OSInfo {
[CmdletBinding(DefaultParametersetName="ServerNames")]
param (
    [Parameter( ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true,
                ParameterSetName="ServerNames",
                HelpMessage="List of computer names separated by commas.")]
    [Alias('hosts')] 
    [string[]]$computers = 'localhost',
    
    [Parameter( ParameterSetName="FileName",
                HelpMessage="Name of txt file with list of servers. Txt file should be in 01servers folder.")] 
    [string]$filename,
    
    [Parameter( Mandatory=$false,
                HelpMessage="Write to error log file or not.")]
    [switch]$errorlog,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Client for example OK = O client, BK = B client")]
    [string]$client,
     
    [Parameter(Mandatory=$true,
                HelpMessage="Solution, for example FIN = Financial, HR = Human Resource")]
    [string]$solution     
)

BEGIN {

    if ( $PsCmdlet.ParameterSetName -eq "FileName") {

        if ( Test-Path -Path "$home\Documents\WindowsPowerShell\Modules\01servers\$filename" -PathType Leaf ) {
            Write-Verbose "Read content from file: $filename"
            $computers = Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\$filename" )        
        } else {
            Write-Warning "This file path does NOT exist: $home\Documents\WindowsPowerShell\Modules\01servers\$filename"
            Write-Warning "Create file $filename in folder $home\Documents\WindowsPowerShell\Modules\01servers with list of server names."
            break;
        }
       
    }

}
PROCESS { 

    foreach ($computer in $computers ) {

        if ( $computer -eq 'localhost' ) {
            $computer = $env:COMPUTERNAME
        }

        $computerinfo = Get-ComputerInfo -computername $computer -client $client -solution $solution
        $hostname = $computerinfo.hostname
        $env = $computerinfo.environment
        $logicalname = $computerinfo.logicalname
        $ip = $computerinfo.ipaddress
        
        try {
            Write-Verbose "Start processing: $computer - $env - $logicalname"
            Write-Verbose "Start CIM_OperatingSystem processing..."
            $OSInfos = $null
            $OSInfo = $null
            $obj = $null

            $params = @{ 'ComputerName'=$computer;
                         'Class'='CIM_OperatingSystem';
                         'ErrorAction'='Stop'}
            
            #Values are already in kilobytes that is the reason to divide with megabytes to get gigabytes.
            $OSInfos = Get-CimInstance @params | 
                Select-Object   CSName, 
                                Caption, 
                                CSDVersion, 
                                Version, 
                                OSArchitecture,
                                InstallDate,
                                LastBootUpTime,
                                SystemDrive, 
                                WindowsDirectory, 
                                @{Name="FreePhysicalMemory";Expression={("{0:N2}" -f($_.FreePhysicalMemory/1mb))}}, 
                                @{Name="FreeSpaceInPagingFiles";Expression={("{0:N2}" -f($_.FreeSpaceInPagingFiles/1mb))}}, 
                                @{Name="FreeVirtualMemory";Expression={("{0:N2}" -f($_.FreeVirtualMemory/1mb))}},  
                                NumberOfProcesses, 
                                NumberOfUsers, 
                                @{Name="SizeStoredInPagingFiles";Expression={("{0:N2}" -f($_.SizeStoredInPagingFiles/1mb))}}, 
                                @{Name="TotalVirtualMemorySize";Expression={("{0:N2}" -f($_.TotalVirtualMemorySize/1mb))}}, 
                                @{Name="TotalVisibleMemorySize";Expression={("{0:N2}" -f($_.TotalVisibleMemorySize/1mb))}}
                                
            Write-Verbose "Finish CIM_OperatingSystem processing..."
            
            foreach ($OSInfo in $OSInfos) {
                Write-Verbose "Start processing OS: $OSInfo"

                $properties = @{ 'Environment'=$env;
                                 'Logical name'=$logicalname;
                                 'Server name'=$OSInfo.CSName;
            	                 'Caption'=$OSInfo.Caption;
            	                 'Service pack'=$OSInfo.CSDVersion;
            	                 'Version'=$OSInfo.Version; 
                                 'OS Architecture'=$OSInfo.OSArchitecture;
                                 'Install Date'=$OSInfo.InstallDate;
                                 'Last BootUp Time'=$OSInfo.LastBootUpTime;
                                 'System drive'=$OSInfo.SystemDrive;
                                 'Windows directory'=$OSInfo.WindowsDirectory;
                                 'Free RAM (GB)'=$OSInfo.FreePhysicalMemory;
                                 'Free space in paging files (GB)'=$OSInfo.FreeSpaceInPagingFiles;
                                 'Free virtual memory (GB)'=$OSInfo.FreeVirtualMemory;
                                 'Number of processes'=$OSInfo.NumberOfProcesses;
                                 'Number of users'=$OSInfo.NumberOfUsers;
                                 'Size stored in paging file (GB)'=$OSInfo.SizeStoredInPagingFiles;
                                 'Total virtual memory size (GB)'=$OSInfo.TotalVirtualMemorySize;
                                 'Total visible memory size (GB)'=$OSInfo.TotalVisibleMemorySize;
                                 'IP'=$ip;
                                 'Collected'=(Get-Date -UFormat %Y.%m.%d' '%H:%M:%S)}

                $obj = New-Object -TypeName PSObject -Property $properties
                $obj.PSObject.TypeNames.Insert(0,'Report.OSInfo')

                Write-Output $obj
                Write-Verbose "Finish processing OS: $OSInfo"
            }
            
            Write-Verbose "Finish processing: $computer - $env - $logicalname"
            
        } catch {
            Write-Warning "Computer failed: $computer - $env - $logicalname OS failed: $OSInfo"
            Write-Warning "Error message: $_"

            if ( $errorlog ) {

                $errormsg = $_.ToString()
                $exception = $_.Exception
                $stacktrace = $_.ScriptStackTrace
                $failingline = $_.InvocationInfo.Line
                $positionmsg = $_.InvocationInfo.PositionMessage
                $pscommandpath = $_.InvocationInfo.PSCommandPath
                $failinglinenumber = $_.InvocationInfo.ScriptLineNumber
                $scriptname = $_.InvocationInfo.ScriptName

                $ErrorArguments = @{
                    'hostname' = $computer;
                    'env' = $env;
                    'logicalname' = $logicalname;
                    'errormsg' = $errormsg;
                    'exception' = $exception;
                    'stacktrace'= $stacktrace;
                    'failingline' = $failingline;
                    'positionmsg' = $positionmsg;
                    'pscommandpath' = $pscommandpath;
                    'failinglinenumber' = $failinglinenumber;
                    'scriptname' = $scriptname
                }

                Write-Verbose "Start writing to Error log."
                Write-ErrorLog @ErrorArguments
                #Write-ErrorLog -hostname $computer -env $env -logicalname $logicalname -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
                Write-Verbose "Finish writing to Error log."
            }
        }
    }

}
END {
}
}

#Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose |  Select-Object 'Environment', 'Logical Name', 'Server Name',  'Caption', 'Service pack', 'Version', 'OS Architecture', 'Install Date', 'Last BootUp Time', 'System drive', 'Windows directory', 'Free RAM (GB)', 'Free space in paging files (GB)', 'Free virtual memory (GB)', 'Number of processes', 'Number of users', 'Size stored in paging file (GB)', 'Total virtual memory size (GB)', 'Total visible memory size (GB)', 'IP', 'Collected' | Out-GridView

<#
#Test ParameterSet = ServerName
Get-OSInfo -client "OK" -solution "FIN"
Get-OSInfo -client "OK" -solution "FIN" -errorlog
Get-OSInfo -client "OK" -solution "FIN" -errorlog -Verbose
Get-OSInfo -computers 'APP100001' -client "OK" -solution "FIN" -errorlog
Get-OSInfo -computers 'APP100001', 'APP100002' -client "OK" -solution "FIN" -errorlog -Verbose
Get-OSInfo -hosts 'APP100001' -client "OK" -solution "FIN" -errorlog
Get-OSInfo -computers (Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" )) -client "OK" -solution "FIN" -errorlog -Verbose

#Pipeline examples
'APP100001' | Get-OSInfo -client "OK" -solution "FIN" -errorlog
'APP100001', 'APP100002' | Get-OSInfo -client "OK" -solution "FIN" -errorlog -Verbose
'APP100001', 'APP100002' | Select-Object @{label="computers";expression={$_}} | Get-OSInfo -client "OK" -solution "FIN" -errorlog
Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" ) | Get-OSInfo -client "OK" -solution "FIN" -errorlog -Verbose
'ERROR' | Get-OSInfo -client "OK" -solution "FIN" -errorlog

#Test CmdLet help
Help Get-OSInfo -Full

#SaveToExcel
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Select-Object 'Environment', 'Logical Name', 'Server Name',  'Caption', 'Service pack', 'Version', 'OS Architecture', 'Install Date', 'Last BootUp Time', 'System drive', 'Windows directory', 'Free RAM (GB)', 'Free space in paging files (GB)', 'Free virtual memory (GB)', 'Number of processes', 'Number of users', 'Size stored in paging file (GB)', 'Total virtual memory size (GB)', 'Total visible memory size (GB)', 'IP', 'Collected' | Save-ToExcel -errorlog -ExcelFileName "Get-OSInfo" -title "Get OS info of servers in Financial solution for " -author "Dejan Mladenovic" -WorkSheetName "OS Info" -client "OK" -solution "FIN" 
#SaveToExcel and send email
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Select-Object 'Environment', 'Logical Name', 'Server Name',  'Caption', 'Service pack', 'Version', 'OS Architecture', 'Install Date', 'Last BootUp Time', 'System drive', 'Windows directory', 'Free RAM (GB)', 'Free space in paging files (GB)', 'Free virtual memory (GB)', 'Number of processes', 'Number of users', 'Size stored in paging file (GB)', 'Total virtual memory size (GB)', 'Total visible memory size (GB)', 'IP', 'Collected' | Save-ToExcel -sendemail -errorlog -ExcelFileName "Get-OSInfo" -title "Get OS info of servers in Financial solution for " -author "Dejan Mladenovic" -WorkSheetName "OS Info" -client "OK" -solution "FIN" 

#Benchmark
#Time = 4 sec; Total Items = 28
Measure-BenchmarksCmdLet { Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose }
#Time = 3,69 sec; Total Items = 28
Measure-BenchmarksCmdLet { Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" }

#Baseline create
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -errorlog -BaselineFileName "Get-OSInfo" -client "OK" -solution "FIN" -Verbose
#Baseline archive and create new
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -archive -errorlog -BaselineFileName "Get-OSInfo"  -client "OK" -solution "FIN" -Verbose

#Test ParameterSet = FileName
Get-OSInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose
Get-OSInfo -filename "OKFINserverss.txt" -errorlog -client "OK" -solution "FIN" -Verbose
#>