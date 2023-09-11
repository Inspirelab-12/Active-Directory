<#
.SYNOPSIS
Get additional information about server. (IPAddress, Environment, Logical Name)
.DESCRIPTION
Get additional information about server: 
- Environment (Production, Acceptance, Test, Course...)
- Logical Name (Application - APP, Web - WEB, Integration - INT, Scan - SCAN, Terminal Server - TS, FTP - FTP server)
- IPAddress
It is important that csv file with list of servers has been saved in folder: 
    $home\Documents\WindowsPowerShell\Modules\01servers

Name pattern of csv file should be client + solution + servers.csv 
for example OKFINservers.csv => Client = OK - O client; Solution = FIN - Financial solution ; servers
or another example BKHRservers.csv => Client = BK - B client; Solution = HR - Humane resource solution; servers

CSV file should look like:
hostname,ipaddress,logicalname,environment
APP100001,192.168.1.120,APP1,PROD
APP100002,192.168.1.121,APP2,PROD
FTP000001,192.168.1.122,FTP1,PROD
WEB000001,192.168.1.150,WEB01,PROD
APP110001,192.168.2.120,APP1,TEST


Steps are:
- Create .csv file with suggested name pattern
- Save .csv file in folder 01servers of PowerShell modules folder
- Write date in .csv for hostname,ipaddress,logicalname,environment

.PARAMETER computername
DNS Name of server.
.PARAMETER client
OK - O client
BK - B client
.PARAMETER solution
FIN - Financial solution
HR - Human Resource solution
.EXAMPLE
Get-ComputerInfo -computername 'APP100001' -client 'OK' -solution 'FIN'
.EXAMPLE 
Get-ComputerInfo -computername 'APP100025' -client 'BK' -solution 'HR'

.INPUTS
System.String

.OUTPUTS
Selected.System.Management.Automation.PSCustomObject

Result: Hostname, IPadresse, LogicalName, Environment

.NOTES
FunctionName : Get-ComputerInfo
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK
https://improvescripting.com/how-to-import-or-export-data-using-powershell
Import-Csv
#>
Function Get-ComputerInfo {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true, 
                HelpMessage="Computer name.")]
    [string]$computername,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Client for example OK = O client, BK = B client")]
    [string]$client,
     
    [Parameter(Mandatory=$true,
                HelpMessage="Solution, for example FIN = Financial, HR = Human resource")]
    [string]$solution 
)

BEGIN { 
        
        Write-Verbose "BEGIN section"

        $serverlistfolder = "$home\Documents\WindowsPowerShell\Modules\01servers"
        
        if  ( !( Test-Path -Path $serverlistfolder -PathType "Container" ) ) {
            
            Write-Output "Create server names lists folder in: $serverlistfolder"
            New-Item -Path $serverlistfolder -ItemType "Container" -ErrorAction Stop
        
        }

}
PROCESS {               
        
        Write-Verbose "Import data for $client - $solution - $computername"
        $filenameprefix = "$client$solution"
        $constant = "servers.csv"
        $filename = "$filenameprefix$constant"
        $importfile = "$home\Documents\WindowsPowerShell\Modules\01servers\$filename"
        
        
        if ( ( Test-Path -Path $importfile -PathType "Leaf" ) ) {

            if ( $computername -eq 'localhost' ) {
                $computername = $env:COMPUTERNAME
                Write-Verbose "Replace localhost with real name of the server."
            }
        
            Import-Csv $importfile | Where-Object -FilterScript { $_.hostname -eq "$computername" } | Select-Object -Property hostname, ipaddress, logicalname, environment         
        
        } else {
        
            Write-Warning "Get-ComputerInfo CmdLet failed."
            Write-Warning "List of server names file $importfile does not exist."
            Write-Warning "Read Get-ComputerInfo CmdLet help to find out more info."
            
            $errormsg = "List of server names file $importfile does not exist."
            $exception = "Read Get-ComputerInfo CmdLet help to find out more info."
            
            $stacktrace = $_.ScriptStackTrace
            $failingline = "Test-Path -Path $importfile -PathType Leaf"
            $positionmsg = $_.InvocationInfo.PositionMessage
            $pscommandpath = $_.InvocationInfo.PSCommandPath
            $failinglinenumber = "103"
            $scriptname = "GetComputerInfo.ps1"

            Write-Verbose "Start writing to Error log."
            
            Write-ErrorLog -hostname "Get-ComputerInfo CmdLet was failing." -env "ALL" -logicalname "ALL" -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
                
            #Write-ErrorLog -hostname "Get-ComputerInfo was failing." -errormsg $errormsg -exception $exception -scriptname "GetComputerInfo.ps1"
            Write-Verbose "Finish writing to Error log."
            
        }
}
END {

        Write-Verbose "END section"

}
}
#region Execution examples
#This one will return: Hostname, IPadresse, LogicalName, Environment
#Get-ComputerInfo -computername "localhost" -client "OK" -solution "FIN"

#This one will fail
#Get-ComputerInfo -computername "APP100001" -client "SK" -solution "FIN" -Verbose
#endregion