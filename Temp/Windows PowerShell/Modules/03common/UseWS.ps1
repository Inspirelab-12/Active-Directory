<#
.SYNOPSIS
Handles Windows Services (Get, Start, Stop, Restart, Suspend [Pause], Resume, Set, Add, Delete) both on local and remote machines
.DESCRIPTION
Handles Windows Services (Get, Start, Stop, Restart, Suspend [Pause], Resume, Set, Add, Delete) both on local and remote machines
List of servers is in txt file in 01servers folder or list of strings with names of computers.
CmdLet has two ParameterSets one for the list of computers from file and another from the list of strings as computer names.

Errors will be saved in the log folder PSLogs with the name Error_Log.txt. Parameter errorlog controls the logging of errors in the log file.

Use-WS function uses: Get-Service, Start-Service, Stop-Service, Restart-Service, Suspend-Service, Resume-Service, Set-Service, New-Service, Remove-Service 
AND Get-WmiObject -Class Win32_Service PowerShell function with delete method

The result shows different columns (properties) depending on which action has been applied (get, start, stop, restart, suspend, resume, set, add, delete)
.PARAMETER computers
List of computers that we want to get All windows services info from. Parameter belongs to default Parameter Set = ServerNames.
.PARAMETER filename
Name of text file with a list of servers. Text file should be in 01servers folder.
Parameter belongs to Parameter Set = FileName.
.PARAMETER errorlog
Switch parameter that sets to write to log or not to write to the log. Error file is in PSLog folder with name Error_Log.txt.
.PARAMETER client
OK - O client
BK - B client
etc.
.PARAMETER solution
FIN - Financial solution 
HR - Human resource solution
etc. 
.PARAMETER action 
Defines the action that we want to do against the Windows Service and have these possible values:
---------------------------------------------------------------------------------------------------------
 Get - Gets Windows Service Properties using Get-Service PowerShell CmdLet
 Start - Starts Windows Service using Start-Service PowerShell CmdLet
 Stop - Stops Windows Service using Stop-Service PowerShell CmdLet
 Restart - Restarts Windows Service using Restart-Service PowerShell CmdLet
 Suspend - Suspends [Pause] Windows Service using Suspend-Service PowerShell CmdLet
 Resume - Resumes Windows Service after being suspended [paused] using Resume-Service PowerShell CmdLet
 Set - Set [changes] some Windows Service properties (Display Name, Description, Startup Type) using Set-Service PowerShell CmdLet
 Add - Adds New Windows Service using New-Service PowerShell CmdLet and needs in addition use of BinaryPathName parameter to point to a binary file location.
 Delete - Deletes [Remove] Windows Service using Remove-Service PowerShell CmdLet and Delete method of Win32_Service class depending on PowerShell Version
.PARAMETER name
It is a mandatory parameter and represents the name of Windows Service (not Display Name very important)
.PARAMETER BinaryPathName
It is a path to Windows Service Binary file that will be added to the system and it is combined with Action parameter value Add.
Look at the example of how to use it. 
.PARAMETER DisplayName
The new value for the Display Name of Window Service and it is combined with Action parameter value Set 
.PARAMETER description
The new value for the Description of Windows Service and it is combined with Action parameter value Set
.PARAMETER StartupType
The new value for the Startup Type of Windows Service and it is combined with Action parameter value Set
Possible values for this parameter are: "Automatic", "AutomaticDelayedStart", "Disabled", "InvalidValue", "Manual"

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -Name "TapiSrv"

Description
---------------------------------------
Test of default parameter with default value ( computers = 'localhost' ) in default ParameterSet = ServerName.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose

Description
---------------------------------------
Test of Verbose parameter. NOTE: Notice how localhost default value of parameter computers replaces with the name of the server.

.EXAMPLE
'ERROR' | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog

Description
---------------------------------------
Test of errorlog parameter. There is no server with the name ERROR so this call will fail and write to Error log since errorlog switch parameter is on. Look Error_Log.txt file in the PSLogs folder.

.EXAMPLE
Use-WS -computers 'APP100001' -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog

Description
---------------------------------------
Test of computers parameter with one value. The parameter accepts an array of strings.

.EXAMPLE
Use-WS -computers 'APP100001', 'APP100002' -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose

Description
---------------------------------------
Test of computers parameter with an array of strings. The parameter accepts an array of strings.

.EXAMPLE
Use-WS -hosts 'APP100001' -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog

Description
---------------------------------------
Test of computers paramater alias hosts.

.EXAMPLE
Use-WS -computers (Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" )) -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose

Description
---------------------------------------
Test of computers parameter and values for parameter comes from .txt file that has a list of servers.

.EXAMPLE
'APP100001' | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog

Description
---------------------------------------
Test of the pipeline by the value of computers parameter.

.EXAMPLE
'APP100001', 'APP100002' | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose

Description
---------------------------------------
Test of the pipeline by value with an array of strings of computers parameter.

.EXAMPLE
'APP100001', 'APP100002' | Select-Object @{label="computers";expression={$_}} | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog

Description
---------------------------------------
Test of values from the pipeline by property name (computers).

.EXAMPLE
Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" ) | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose

Description
---------------------------------------
Test of the pipeline by value that comes as the content of .txt file with the list of servers.

.EXAMPLE
Help Use-WS -Full

Description
---------------------------------------
Test of Powershell help.

.EXAMPLE
Use-WS -filename "OKFINkservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose

Description
---------------------------------------
This is test of ParameterSet = FileName and parameter filename. There is a list of servers in .txt file.

.EXAMPLE
Use-WS -filename "OKFINserverss.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose

Description
---------------------------------------
This is test of ParameterSet = FileName and parameter filename. This test will fail due to the wrong name of the .txt file with the warning message "WARNING: This file path does NOT exist:".

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "TapiSrv" 

Description
---------------------------------------
Gets Windows Service Properties. Get is the default action parameter value so we do not need to provide the value for the action parameter.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "TapiSrv" -action Start 

Description
---------------------------------------
Start Windows Service.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "TapiSrv" -action Stop

Description
---------------------------------------
Stop Windows Service

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "TapiSrv" -action Suspend 

Description
---------------------------------------
Suspend [Pause] Windows Service.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "TapiSrv" -action Resume

Description
---------------------------------------
Resume Windows Service that has been paused [suspended].

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "TapiSrv" -action Restart 

Description
---------------------------------------
Restart Windows Service.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon" -BinaryPathName "C:\Temp\WS\ConDaemon.exe" -action Add

Description
---------------------------------------
Adds New Window Service with name ConDaemon. It is important to combine both Action parameter with value Add and BinaryPathName parameter with the value pointing to the location of
Windows Service binary (executable) file.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon" -DisplayName "New Con Deamon WS" -description "Windows Service New Description" -StartupType Disabled -action Set

Description
---------------------------------------
Changes [Sets] Window Service Properties (Display Name, Description, Startup Type) and it is combined with Action parameter value Set.

.EXAMPLE
Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon" -action Delete

Description
---------------------------------------
Removes [Deletes] Windows Service from the system. 


.INPUTS
System.String

Computers parameter pipeline both by Value and by Property Name value and has the default value localhost. (Parameter Set = ComputerNames)
Filename parameter does not pipeline and does not have a default value. (Parameter Set = FileName)
.OUTPUTS
System.Management.Automation.PSCustomObject


.NOTES
FunctionName : Use-WS
Created by   : Dejan Mladenovic
Date Coded   : 11/20/2020 19:06:41
More info    : https://improvescripting.com/

.LINK 
https://improvescripting.com/write-own-powershell-cmdlet-that-handles-windows-services/
Get-Service 
Start-Service 
Stop-Service 
Restart-Service 
Suspend-Service 
Resume-Service
Set-Service
New-Service
Remove-Service
#>
Function Use-WS {
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

    [Parameter(Mandatory=$false,
                HelpMessage="Action agains Windows Service. (Get, Start, Stop, Restart, Suspend, Resume, Set, Add, Delete)")]
    [ValidateSet("Get", "Start", "Stop", "Restart", "Suspend", "Resume", "Set", "Add", "Delete")] 
    [string]$action = 'Get',

    [Parameter( Mandatory=$true,
                HelpMessage="Name of the Windows Service and accepts wildcards.")]
    [string]$name,

    [Parameter( Mandatory=$false,
                HelpMessage="Path to Windows Service Executable file that will be added to Services Console.")]
    [string]$BinaryPathName,
    
    [Parameter( Mandatory=$false,
                HelpMessage="New value for Windows Service Display Name.")]
    [string]$DisplayName,

    [Parameter( Mandatory=$false,
                HelpMessage="New value for Windows Service Description.")]
    [string]$description,

    [Parameter( Mandatory=$false,
                HelpMessage="New value for Windows Service Startup Type.")]
    [ValidateSet("Automatic", "AutomaticDelayedStart", "Disabled", "InvalidValue", "Manual")]
    [string]$StartupType,

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

<#
The following lines of code (4) are added in order to provide Credentials for PowerShell Remoting since we use Invoke-Command CmdLet
This is dependant on the type of Remoting Enabled in your environment and sometimes is not necessary if your user running the script
has enough privileges. 
#>


##REPLACE THIS VALUE!!
$EncryptedPasswordFile = "C:\Users\dekib\Documents\PSCredential\Invoke-Command.txt"
##REPLACE THIS VALUE!!
$username="user_name" 
$password = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString
$Credentials = New-Object System.Management.Automation.PSCredential($username, $password)

    foreach ($computer in $computers ) {

        if ( $computer -eq 'localhost' ) {
            $computer = $env:COMPUTERNAME
            Write-Verbose "Replace localhost with real name of the server."
        }
        
        $computerinfo = Get-ComputerInfo -computername $computer -client $client -solution $solution
        $hostname = $computerinfo.hostname
        $env = $computerinfo.environment
        $logicalname = $computerinfo.logicalname
        $ip = $computerinfo.ipaddress
        
        try {
            Write-Verbose "Start processing: $computer - $env - $logicalname"        
            Write-Verbose "Handle Windows Service ($name)..."

            switch($action) {
                'Start' {
                    
                    Write-Verbose "Check Windows Service Status ($name)..."

                    $getscriptblock = Convert-StringToScriptBlock -string "Get-Service -Name $name -ErrorAction Stop"

                    $services = $null

                    $services = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction Stop

                    if ( $services.Status -eq "Stopped" ) {
                        
                        Write-Verbose "Start Windows Service ($name)..."

                        $scriptblock = Convert-StringToScriptBlock -string "Start-Service -Name $name -PassThru -ErrorAction Stop | Select-Object Name, Status"

                        Invoke-Command -ComputerName $computers -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                        Write-Verbose "Windows Service ($name) STARTED!"
                    
                    } else {

                      Write-Verbose "No ($name) Windows Service to start on computer: $computer"
                    
                    }

                    break
                }
                'Stop' {
                    
                    Write-Verbose "Check Windows Service Status ($name)..."

                    $getscriptblock = Convert-StringToScriptBlock -string "Get-Service -Name $name -ErrorAction Stop"

                    $services = $null

                    $services = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction Stop

                    if ( $services.Status -eq "Running" ) {
                        
                        Write-Verbose "Stop Windows Service ($name)..."

                        $scriptblock = Convert-StringToScriptBlock -string "Stop-Service -Name $name -Force -PassThru -ErrorAction Stop | Select-Object Name, Status"

                        Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                        Write-Verbose "Windows Service ($name) STOPPED!"
                    
                    } else {

                      Write-Verbose "No ($name) Windows Service to stop on computer: $computer"
                    
                    }
                    break
                }
                'Restart' {
                    
                    Write-Verbose "Restart Windows Service ($name)..."

                    $scriptblock = Convert-StringToScriptBlock -string "Restart-Service -Name $name -Force -PassThru -ErrorAction Stop | Select-Object Name, Status"

                    Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                    Write-Verbose "Windows Service ($name) RESTARTED!"

                    break
                }
                'Suspend' {

                    Write-Verbose "Check Windows Service Status ($name)..."

                    $getscriptblock = Convert-StringToScriptBlock -string "Get-Service -Name $name -ErrorAction Stop"

                    $services = $null

                    $services = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction Stop

                    if ( $services.CanPauseAndContinue -eq $true -and $services.Status -ne "Paused") {
                        
                        Write-Verbose "Suspend [Pause] Windows Service ($name)..."

                        $scriptblock = Convert-StringToScriptBlock -string "Suspend-Service -Name $name -PassThru -ErrorAction Stop | Select-Object Name, Status"

                        Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                        Write-Verbose "Windows Service ($name) SUSPENDED [PAUSED]!"
                    
                    } else {

                      Write-Verbose "No ($name) Windows Service to suspend [pause] on computer: $computer"
                    
                    }

                    break
                }
                'Resume' {
                    
                    Write-Verbose "Check Windows Service Status ($name)..."

                    $getscriptblock = Convert-StringToScriptBlock -string "Get-Service -Name $name -ErrorAction Stop"

                    $services = $null

                    $services = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction Stop

                    #We want to resume only paused service and that can be resumed
                    if ( $services.CanPauseAndContinue -eq $true -and $services.Status -eq "Paused") {
                        
                        Write-Verbose "Resume Windows Service ($name)..."

                        $scriptblock = Convert-StringToScriptBlock -string "Resume-Service -Name $name -PassThru -ErrorAction Stop | Select-Object Name, Status"

                        Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                        Write-Verbose "Windows Service ($name) resumed!"
                    
                    } else {

                      Write-Verbose "No ($name) Windows Service to resume on computer: $computer"
                    
                    }

                    break
                }
                'Set' {
                    
                    Write-Verbose "Set Windows Service Properties ($name)..."

                    $setstring = "Set-Service -Name '" + $name + "' "

                    if ($DisplayName){
                        $setstring = $setstring + "-DisplayName '" + $DisplayName + "' " 
                    }

                    if ($description){
                        $setstring = $setstring + "-Description '" + $description + "' " 
                    }

                    if ($StartupType){
                        $setstring = $setstring + "-StartupType '" + $StartupType + "' " 
                    }

                    $scriptblock = Convert-StringToScriptBlock -string $setstring

                    Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                    Write-Verbose $setstring

                    Write-Verbose "Windows Service ($name) SET!"

                    break
                }
                'Add' {

                    $getscriptblock = Convert-StringToScriptBlock -string "Get-Service -Name $name -ErrorAction Stop | Select-Object *"

                    $services = $null

                    #If the service doesn't exist we do not want to get an error so we used SilentlyContinue error action value.
                    $services = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction SilentlyContinue

                    if ($services){
                    
                        Write-Warning "Windows Service ($name) already exists and cannot be added again!"

                    } else {
                    
                        Write-Verbose "Add Windows Service ($name)..."

                        $scriptblock = Convert-StringToScriptBlock -string "New-Service -Name $name -BinaryPathName $BinaryPathName"

                        Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                        Write-Verbose "Check New Windows Service ($name) existence."

                        $newservice = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction Stop

                        if($newservice){
                         
                            Write-Verbose "New Windows Service $name Added."
                            
                        } else {

                            Write-Warning "Something is wrong so rerun the command and investigate further!!!"
                        
                        }

                    } 

                    break
                }
                'Delete' {
                    
                    $hostversion="v$($Host.Version.Major).$($Host.Version.Minor)"

                    $getscriptblock = Convert-StringToScriptBlock -string "Get-Service -Name $name -ErrorAction Stop | Select-Object *"

                    $services = $null
                    
                    #If the service doesn't exist we do not want to get an error so we used SilentlyContinue error action value.
                    $services = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $getscriptblock -ErrorAction SilentlyContinue

                    #Stop Windows Service Before Trying to Delete It.
                    if ($services.Status -eq "Running"){

                        Write-Warning "Stop Windows Service ($name) in order to be able to delete it afterward."

                    } elseif ($services) {

                        #We use different commands to delete Windows Service for PowerShell Version 5.1 and older comparing with PowerShell versions 6 and 7
                        if ($Host.Version.Major -gt 5) {
                    
                            Write-Verbose "Delete Windows Service ($name) in PowerShell $hostversion..."

                            ## NEED Help with this part of code in PowerShell 6 returns error: 
                            <#
                             The term 'Remove-Service' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the spelling of the name, or if a path was included, verify that the path is correct and try again
                            #>
                            $scriptblock = Convert-StringToScriptBlock -string "Remove-Service -Name $name"

                            Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                            Write-Verbose "Windows Service ($name) DELETED [REMOVED]!"
                    
                    
                        } else {

                            Write-Verbose "Delete Windows Service ($name) in PowerShell $hostversion..."

                            (Get-WmiObject -ClassName win32_service -Filter "Name='$name'" -ComputerName $computer -ErrorAction Stop).Delete()

                            Write-Verbose "Windows Service ($name) DELETED [REMOVED]!"

                        }
                    } else { 
                    
                        Write-Warning "Windows Service ($name) does NOT exist so cannot be deleted!"       
                    }
                    

                    break
                }
                default {
                    
                    Write-Verbose "Get Windows Service ($name) properties..."

                    $script = "Get-Service -Name '" + $name + "' | Select-Object Name, Status, DisplayName, StartType, DependentServices, RequiredServices, ServicesDependedOn, CanPauseAndContinue, CanShutdown, CanStop, MachineName, ServiceName, ServiceHandle, ServiceType"
                     
                    $scriptblock = Convert-StringToScriptBlock -string $script

                    $result = Invoke-Command -ComputerName $computer -Credential $Credentials -ScriptBlock $scriptblock -ErrorAction Stop

                    #We need to add description separately since Get-Service will not return that value plus we need to pass $name variable to Get-CimInstance as Query
                    $result | Add-Member -NotePropertyName Description2 -NotePropertyValue (Get-CimInstance -Query "SELECT * from Win32_Service WHERE name LIKE '$name%'" | Select-Object Description) 

                    #First we will return all the properties and expend the value from Description2 but the result will have Description as last column in result which we do not want
                    $finalresult = $result | Select-Object -Property Name, Status, DisplayName, StartType, DependentServices, RequiredServices, ServicesDependedOn, CanPauseAndContinue, CanShutdown, CanStop, MachineName, ServiceName, ServiceHandle, ServiceType -ExpandProperty Description2

                    #Finally we can list the properties (columns) in the order we want to the final result.
                    $finalresult | Select-Object Name, Status, DisplayName, Description, StartType, DependentServices, RequiredServices, ServicesDependedOn, CanPauseAndContinue, CanShutdown, CanStop, MachineName, ServiceName, ServiceHandle, ServiceType
                    
                    #Select-Object Name, Status, DisplayName, -ExpandProperty Description2, StartType, DependentServices, RequiredServices, ServicesDependedOn, CanPauseAndContinue, CanShutdown, CanStop, MachineName, ServiceName, ServiceHandle, ServiceType

                    Write-Verbose "Windows Service ($name) properties."

                }
            }
           
        } catch {
            Write-Warning "Computer failed: $computer - $env - $logicalname Service failed: $AllWindowsService"
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

                Write-Verbose "Start writing to Error log."
                Write-ErrorLog -hostname $hostname -env $env -logicalname $logicalname -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
                Write-Verbose "Finish writing to Error log."
            }
        }
    }
}
END { 
}
}
#region Execution examples
#Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon"

#Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon" -BinaryPathName "C:\Temp\WS\ConDaemon.exe" -action Add

#Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon" -DisplayName "New Con Deamon WS" -description "Windows Service New Description" -StartupType Disabled -action Set

#Use-WS -client "OK" -solution "FIN" -errorlog -Verbose -name "ConDaemon" -action Delete
          	                  
                                 
<#
#Test ParameterSet = ServerName
Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" 
Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog
Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose
Use-WS -computers 'APP100001' -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog
Use-WS -computers 'APP100001', 'APP100002' -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose
Use-WS -hosts 'APP100001' -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog
Use-WS -computers (Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" )) -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose

#Pipeline examples
'APP100001' | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog
'APP100001', 'APP100002' | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose
'APP100001', 'APP100002' | Select-Object @{label="computers";expression={$_}} | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog
Get-Content( "$home\Documents\WindowsPowerShell\Modules\01servers\OKFINservers.txt" ) | Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose
'ERROR' | Use-WS -client "OK" -solution "FIN" -errorlog

#Test CmdLet help
Help Use-WS -Full

#SaveToExcel
Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose | Save-ToExcel -errorlog -ExcelFileName "Use-WS" -title "Windows Services info of servers in Financial solution for " -author "Dejan Mladenovic" -WorkSheetName "Windows services Info" -client "OK" -solution "FIN" 
#SaveToExcel and send email
Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-ToExcel -sendemail -errorlog -ExcelFileName "Use-WS" -title "Windows Services info of servers in Financial solution for " -author "Dejan Mladenovic" -WorkSheetName "Windows services Info" -client "OK" -solution "FIN" 

#Benchmark
#Time = 5.5 sec; Total Items = 12
Measure-BenchmarksCmdLet { Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose }
#Time = 4.9 sec; Total Items = 12
Measure-BenchmarksCmdLet { Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" }

#Baseline create
Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose | Save-Baseline -errorlog -BaselineFileName "Use-WS" -client "OK" -solution "FIN" -Verbose
Use-WS -client "OK" -solution "FIN" -errorlog -Name "TapiSrv" -Verbose | Save-Baseline -errorlog -BaselineFileName "Use-WS" -client "OK" -solution "FIN" -Verbose 
#Baseline archive and create new
Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose | Save-Baseline -archive -errorlog -BaselineFileName "Use-WS"  -client "OK" -solution "FIN" -Verbose
Use-WS -client "OK" -solution "FIN" -Name "TapiSrv" -errorlog -Verbose | Save-Baseline -archive -errorlog -BaselineFileName "Use-WS" -client "OK" -solution "FIN" -Verbose

#Test ParameterSet = FileName
Use-WS -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose
Use-WS -filename "OKFINserverss.txt" -errorlog -client "OK" -solution "FIN" -Name "TapiSrv" -Verbose

#>
#endregion