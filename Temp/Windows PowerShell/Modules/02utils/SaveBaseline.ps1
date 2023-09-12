<#
.SYNOPSIS
Save baseline xml file for differant comparation purposes and change tracking possibilities.
.DESCRIPTION
Save baseline xml file for differant comparation purposes and change tracking possibilities.
After baseline xml file has been created we can use other CmdLet to compare current state with baseline state. 
For example we can create baseline XML file with properties of files in some folder and than compare current properties of these files agains baseline in order to find updated, deleted or new files. 
.PARAMETER InputObject
Any object that will be saved as xml file.
.PARAMETER BaselineFileName
Prefix of xml file name. File name has client and solution parameter values. 
Xml file cannot be overwritten due to use of NoClobber parameter of Export-Clixml CmdLet
.PARAMETER archive
Switch parameter that archives current baseline in Archive folder and creates new baseline file.
.PARAMETER errorlog
write to log or not.
.PARAMETER client
OK - O client
BK - B client
.PARAMETER solution
FIN - Financial solution
HR - Humane Resource solution
.EXAMPLE
Get-FileProperties -inputobjects OKFINtestfiles.csv -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -BaselineFileName "TestClient" -errorlog -client "OK" -solution "FIN" -Verbose

Description
---------------------------------------
Output objects of Get-FileProperties CmdLet are input objects for Save-Baseline CmdLet.

.INPUTS
System.Management.Automation.PSCustomObject

InputObject parameter pipelines by value. 
.OUTPUTS
System.Boolen

.NOTES
FunctionName : Save-Baseline
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK 
https://improvescripting.com/how-to-export-xml-file-in-powershell
Export-Clixml
#>
Function Save-Baseline {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
                ValueFromPipeline=$true, 
                HelpMessage="Input rows to be saved as baseline xml file.")] 
    [PSobject[]]$InputObject,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="XML baseline file name.")]
    [string]$BaselineFileName,
    
    [Parameter(HelpMessage="Archive current baseline in Archive folder and create new baseline.")]
    [switch]$archive,
    
    [Parameter(HelpMessage="Write to error log file or not.")]
    [switch]$errorlog,
    
    [Parameter(Mandatory=$true, 
                HelpMessage="Client for example OK = O client, BK = B client")]
    [string]$client,
     
    [Parameter(Mandatory=$true,
                HelpMessage="Solution, for example FIN = Financial accounting, HR = Human Resource")]
    [string]$solution
    
    
)
BEGIN { 
    
    #Creat an empty array
    $objects = @()

}
PROCESS { 

    $objects += $InputObject
    
}
END { 
    
    #Create PSbaselines folder if does not exist    
    if ( !( Test-Path -Path "$home\Documents\PSbaselines" -PathType "Container" ) ) {
        Write-Verbose "Create Baseline folder in: $home\Documents"
        New-Item -Name "PSbaselines" -Path "$home\Documents" -ItemType "Container" -ErrorAction Stop
        Write-Verbose "Baselines folder has been created."
    }
    
    $BaselineFile = "$home\Documents\PSbaselines\$BaselineFileName" + "-" + "$client" + "-" + "$solution" + ".xml"

    try {
        
        #Archive the baseline file in Archive folder before creating new baseline file.
        if ( $archive ) {
            
            #Create Archive folder if does not exist
            if ( !(Test-Path -Path "$home\Documents\PSbaselines\Archive" -PathType "Container" ) ) {
                Write-Verbose "Create archive folder in: $home\Documents\PSbaselines"
                New-Item -Name "Archive" -Path "$home\Documents\PSbaselines" -ItemType "Container" -ErrorAction Stop
                Write-Verbose "Archive folder has been created."
            }
            
            $date = Get-Date -UFormat "%Y-%m-%d_%H-%M-%S"
            $ArchiveFile = "$home\Documents\PSbaselines\Archive\$BaselineFileName" + "-" + "$client" + "-" + "$solution" + "-" + $date + ".xml"
            
            #This is used only for the very first time when neither PSbaselines folder nor Archive nor Baseline file exist.             
            if ( !( Test-Path -Path $BaselineFile -PathType "Leaf" ) ) {
                $objects | Export-Clixml -Path $BaselineFile -NoClobber -ErrorAction Stop
                Write-Verbose "Baseline file has been saved for very first time: $BaselineFile"
            }
            
            Write-Verbose "Archive baseline file: $BaselineFile"
            Move-Item -Path $BaselineFile -Destination $ArchiveFile -ErrorAction Stop
            Write-Verbose "Baseline file archived to: $ArchiveFile" 
        }    

        $objects | Export-Clixml -Path $BaselineFile -NoClobber -ErrorAction Stop
        
        Write-Verbose "Baseline file saved: $BaselineFile"
        
    } catch {
        Write-Warning "Save-Baseline function failed"
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
            Write-ErrorLog -hostname "Save-Baseline has failed" -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
            Write-Verbose "Finish writing to Error log."
        } 
    } 
}


}
#region Execution examples
#Get-FileProperties -inputobjects OKFINtestfiles.csv -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -BaselineFileName "TestClient" -errorlog -client "OK" -solution "FIN" -Verbose

#Get-FileProperties -inputobjects OKFINcompareFilesSecEnv.csv -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -BaselineFileName "AppSecEnv" -errorlog -client "OK" -solution "FIN" -Verbose
#Get-FileProperties -inputobjects OKFINcompareFilesProdEnv.csv -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -BaselineFileName "AppProdEnv" -errorlog -client "OK" -solution "FIN" -Verbose

#Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -errorlog -BaselineFileName "Get-CPUInfo" -client "OK" -solution "FIN" -Verbose

#Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Save-Baseline -archive -errorlog -BaselineFileName "Get-CPUInfo"  -client "OK" -solution "FIN" -Verbose
#endregion