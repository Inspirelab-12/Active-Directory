<#
.SYNOPSIS
This is quality control CmdLet to measure performance of differant Powershell CmdLets.

.DESCRIPTION
This is quality control CmdLet to measure performance of differant Powershell CmdLets.
As a result Measure-BenchmarksCmdLet shows, when CmdLet started (DD.MM.YYYY hh:mm:ss), 
how many objects CmdLet returned as result, 
when CmdLet finished (DD.MM.YYYY hh:mm:ss) 
and last info is differance (Diff) between start and end time in format: Hours:Minute:Seconds.Milliseconds

.PARAMETER ScriptBlock
Cmd-Let call that we want to measure performance for.
NOTICE: that this input parameter is Script Block type of parameter and writes between curly brackets { }

.PARAMETER errorlog
Switch parameter that sets to write to log or not to write to log. Error file is in PSLog folder with name Error_Log.txt.

.EXAMPLE
Measure-BenchmarksCmdLet { Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose } 

Description
---------------------------------------
Benchmarking custom made Powershell CmdLet Get-CPUInfo with verbose logging.

.EXAMPLE 
Measure-BenchmarksCmdLet { Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" } 

Description
---------------------------------------
Benchmarking custom made Powershell CmdLet Get-CPUInfo without verbose logging.

.EXAMPLE 
Measure-BenchmarksCmdLet {Get-Service -ComputerName localhost}

Description
---------------------------------------
Benchmarking Powershell built-in CmdLet Get-Service for local computer.

.EXAMPLE
Help Measure-BenchmarksCmdLet -Full

Description
---------------------------------------
Test of Powershell help.

.INPUTS
ScriptBlock

Cmd-Let call that we want to measure performance for.

.OUTPUTS
System.String
System.TimeSpan

As a result Measure-BenchmarksCmdLet shows, when CmdLet started (DD.MM.YYYY hh:mm:ss), 
how many objects CmdLet returned as result, 
when CmdLet finished (DD.MM.YYYY hh:mm:ss) 
which command or CmdLet was running
when data were collected in date format (YYYY.MM.DD hh:mm:ss)
and last info is differance (Diff) between start and end time in: Hours:Minutes:Seconds.Milliseconds

.NOTES
FunctionName : Measure-BenchmarksCmdLet
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK 
https://improvescripting.com/how-to-benchmark-scripts-with-powershell/
Invoke-Command
Get-Date
#>
function Measure-BenchmarksCmdLet {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)] 
    [ScriptBlock]$ScriptBlock,
    [Parameter( Mandatory=$false,
                HelpMessage="Write to error log file or not.")]
    [switch]$errorlog
)
BEGIN { 

}
PROCESS { 

    try {
    
        $benchmark = $ScriptBlock
        
        $d1 = Get-Date        
        
        $obj = Invoke-Command -ScriptBlock $benchmark -ErrorAction Stop

        #$wmiDT = [System.Management.ManagementDateTimeConverter]::ToDateTime($d1)    

        $d2 = Get-Date   

        $diff = $d2 - $d1
        
        $wmiCount = ($obj).Count

        Write-Verbose "Script started at $d1"
        Write-Verbose "Total items processed: $wmiCount"
        Write-Verbose "Script finished at $d2"

        #use this for debugging example
        #Write-Verbose $d2 - $d1

        Write-Verbose $diff

        Write-Verbose "Start processing Measure-BenchmarksCmdLet"

                $properties = @{ 'Command'=$ScriptBlock;
                                 'Started'=$d1;
                                 'Finished'=$d2;
            	                 '# of Objects processed'=$wmiCount;
            	                 'Execution Time [hh:mm:ss:ms]'=$d2 - $d1;
            	                 'Collected'=(Get-Date -UFormat %Y.%m.%d' '%H:%M:%S)}

                $obj = New-Object -TypeName PSObject -Property $properties
                $obj.PSObject.TypeNames.Insert(0,'Report.MeasureBenchmarks')

                Write-Output $obj
        
        Write-Verbose "Finish processing Measure-BenchmarksCmdLet"


    } catch {
        Write-Warning "Measure-BenchmarksCmdLet function failed."
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
            Write-ErrorLog -hostname "Measure-BenchmarksCmdLet has failed" -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
            Write-Verbose "Finish writing to Error log."
        } 
    } 

}
END { 
}
}
#region Execution examples
#Measure-BenchmarksCmdLet {Get-Service -ComputerName localhost} -errorlog -Verbose


#Measure-BenchmarksCmdLet { Import-Module 01common;  Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose ; Remove-Module 01Common;}
#Measure-BenchmarksCmdLet { Import-Module 01common;  Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" ; Remove-Module 01Common;}

#Measure-BenchmarksCmdLet { Get-PrinterJob -computers "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose | Where-Object { $_.JobStatus -like "Error*" } }

#Measure-BenchmarksCmdLet { Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" -Verbose }
#Measure-BenchmarksCmdLet { Get-CPUInfo -filename "OKFINservers.txt" -errorlog -client "OK" -solution "FIN" }
#endregion