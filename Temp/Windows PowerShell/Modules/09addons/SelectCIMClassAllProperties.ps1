<#
.SYNOPSIS
Get all the properties for CIM (Common Information Model) or WMI (Windows Management Instrumentation) class and write Select statement for that CIM or WMI Class.
.DESCRIPTION
Get all the properties for CIM (Common Information Model) or WMI (Windows Management Instrumentation) class and write Select statement for that CIM or WMI Class. 
This is usefull when one wants to know what can be output from CIM or WMI class.
Which properties might be usefull and which are not.
.PARAMETER classname
CIM or WMI class name e.g. Win32_OperatingSystem
.EXAMPLE
Select-CIMClassAllProperties -classname "Win32_OperatingSystem"
.EXAMPLE 
Select-CIMClassAllProperties -classname "CIM_Processor"
.NOTES
    FunctionName : Select-CIMClassAllProperties
    Created by   : Dejan Mladenovic
    Date Coded   : 01/18/2020 05:21:41
    More info    : https://improvescripting.com/
.LINK 
https://improvescripting.com/how-to-write-select-statement-for-all-properties-of-cim-or-wmi-class-with-powershell
.OUTPUT
Output text in current PowerShell ISE Script Pane.
#>
Function Select-CIMClassAllProperties {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="CIM or WMI class name.")]
    [string]$classname,
    $SelectedText = $psISE.CurrentFile.Editor.SelectedText,
    $InstallMenu,
    $ComputerName = 'localhost'
)

BEGIN {

        if ($InstallMenu)
        {
            Write-Verbose "Try to install the menu item, and error out if there's an issue."
            try
            {
                $psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add("Select CIM or WMI Class Properties",{Select-CIMClassAllProperties},"Ctrl+Alt+W") | Out-Null
            }
            catch
            {
                Return $Error[0].Exception
            }
        }

}
PROCESS {               
        
        if (!$InstallMenu)
        {
            Write-Verbose "Don't run a function if we're installing the menu"
            try
            {
                Write-Verbose "Write Select statment for all the properties of CIM or WMI Class."
                 
                if ($SelectedText )
                {
                    $class = "$SelectedText"
                } else {
                    $class = "$classname"
                }

                $CmiClass = Get-CimInstance -Class $class -ComputerName $ComputerName | Get-Member -MemberType Property | Select-Object Name

                $FirstItem = $true
                $CmiClass | 
                
                ForEach-Object { 
                    $propertyname = $_.Name
                    if ($FirstItem -eq $true) {
                        $properties = $propertyname
                        $FirstItem = $false    
                    } else {
                        $properties = "$properties, $propertyname" 
                    }
                }    
    
                $l = $psise.CurrentFile.Editor.CaretLine
                $c = $psise.CurrentFile.Editor.CaretColumn
                $x = ''

                if ($c -ne 0)
                {
                    $x = ' ' * ($c - 1)
                }
 
                $psise.CurrentFile.Editor.InsertText("Get-CimInstance -Class $class -ComputerName $ComputerName | Select-Object $properties")
                $psise.CurrentFile.Editor.SetCaretPosition($l, $c + 3)  

            }
            catch
            {
                Return $Error[0].Exception
            }
        }   
}
END { }
}
#region Execution examples
    
    Select-CIMClassAllProperties -InstallMenu $true
    #Select-CIMClassAllProperties -classname "CIM_Processor"

#endregion

