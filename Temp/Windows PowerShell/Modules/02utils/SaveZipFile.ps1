#region help
<#
.SYNOPSIS
Save Zip file.
.DESCRIPTION
Save Zip file.
.PARAMETER zipfilename
Absolute location of zip file with name of zip file.
.PARAMETER sourcedir
Source directory where the files that will be zipped are.
.PARAMETER errorlog
Switch parameter that sets to write to log or not to write to log. Error file is in PSLog folder with name Error_Log.txt.
.EXAMPLE
Save-ZipFile  -zipfilename "C:\Temp\Rollback.zip" -sourcedir "C:\Temp\Rollback" -Verbose

Description
---------------------------------------
Zip content of folder C:\Temp\Rollback in zip file C:\Temp\Rollback.zip 

.EXAMPLE
Save-ZipFile  -zipfilename "C:\Temp\Rollback.zip" -sourcedir "C:\Temp\Rollback" -errorlog -Verbose

.INPUTS
System.String

InputObject parameters are strings. 
.OUTPUTS

.NOTES
FunctionName : Save-ZipFile
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK 
System.IO.Compression.FileSystem
System.IO.Compression.ZipFile
#>
#endregion
Function Save-ZipFile {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
                HelpMessage="Absolute path to zip file that will be created.")] 
    [string]$zipfilename,
    
    [Parameter(Mandatory=$true,
                HelpMessage="Source directory where all the files that will be zipped are.")]
    [string]$sourcedir,
    
    [Parameter( Mandatory=$false,
                HelpMessage="Write to error log file or not.")]
    [switch]$errorlog   
)
BEGIN { 

}
PROCESS { 

        try {

           Add-Type -Assembly System.IO.Compression.FileSystem
           $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
           Write-Verbose "Zip files..."
           [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir,$zipfilename, $compressionLevel, $false)
           Write-Verbose "Files zipped."
            
        } catch {
            Write-Warning "Save-ZipFile function failed"
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
                Write-ErrorLog -hostname "Save-ZipFile has failed" -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
                Write-Verbose "Finish writing to Error log."
            } 
        } 
    
}
END { 
      
}
}
#region Execution examples
#Save-ZipFile  -zipfilename "C:\Temp\Rollback.zip" -sourcedir "C:\Temp\Rollback" -errorlog -Verbose 
#endregion