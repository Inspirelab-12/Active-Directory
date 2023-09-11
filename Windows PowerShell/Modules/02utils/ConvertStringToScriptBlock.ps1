<#
.SYNOPSIS
Convert string value passed by pipeline into script block value.
.DESCRIPTION
Convert string value passed by pipeline into script block value.

I have used this CmdLet in Get-FileProperties from 03 Common module.

It can be also used for calls to Invoke-Command cmdlet which accepts script block value in the parameter ScriptBlock.

For example, the Invoke-Command cmdlet has a ScriptBlock parameter that takes a script block value, as shown in this example:

    Invoke-Command -ScriptBlock { Get-Process }

.PARAMETER string
Input value of string that will be converted into script block type value.

.EXAMPLE
$sb = "Get-Service" | Convert-StringToScriptBlock
Invoke-Command -ScriptBlock $sb

Description:
------------------------------------------------------
Convert string value "Get-Service" into script block and keep in $sb variable.
Run Invoke-Command cmdlet and use value in $sb variable as input for parameter ScriptBlock.

.EXAMPLE
Help Convert-StringToScriptBlock -Full

Description:
------------------------------------------------------
Test of Powershell help.

.INPUTS
System.String

.OUTPUTS
ScriptBlock

.NOTES
FunctionName : Convert-StringToScriptBlock
Created by   : Dejan Mladenovic
Date Coded   : 10/31/2018 19:06:41
More info    : https://improvescripting.com/

.LINK 
https://improvescripting.com/how-to-convert-string-to-script-block-using-powershell/
Invoke-Command
#>
Function Convert-StringToScriptBlock {
[CmdletBinding()]
param (

    [Parameter(ValueFromPipeline=$true,
                Position=0,
                Mandatory=$false,
                HelpMessage="Input string that will this CmdLet convert into Script Block.")] 
    [string]$string
)
BEGIN {        
}
PROCESS {  

    Write-Verbose "Starting converting string to script block..."

    $sb = [scriptblock]::Create($string)
    
    Write-Verbose "Converting string to script block finished."

    return $sb

}        
END { 
}
}
#region Execution examples
#Convert-StringToScriptBlock -string "Parameter value" -Verbose
#endregion
