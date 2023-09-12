<#
.SYNOPSIS
Send email.
.DESCRIPTION
Send email.
.PARAMETER Attachments
Email attachments. File path to file(s) that will be attachments.
.PARAMETER Priority
Email priority. Valid values are: Normal, High and Low.
.PARAMETER errorlog
Write to Error log or not. Switch parameter. Error log is in PSLogs Folder of My documents.
.PARAMETER client
OK - O client
BK - B client
.PARAMETER solution
FIN - Financial solution 
HR - Humane Resource solution
.EXAMPLE
Send-Email -Attachments "$home\Documents\PSlogs\Error_Log.txt" -Priority "Normal" -errorlog -client "Test" -solution "Test" -Verbose

.NOTES
FunctionName : Send-Email
Created by   : Dejan Mladenovic
Date Coded   : 09/23/2020 15:13:00
More info    : https://improvescripting.com/send-emails-using-powershell-with-many-examples/

.LINK 
Send-MailMessage
https://improvescripting.com/send-emails-using-powershell-with-many-examples/
#>
Function Send-Email {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, 
                HelpMessage="Email attachments.")]
    [string[]]$Attachments,
    
    [Parameter(Mandatory=$false, 
                HelpMessage="Priority. Valid values are: Normal, High and Low.")]
    [ValidateSet("Normal", "High", "Low")]            
    [string]$Priority = "Normal",
        
    [Parameter( Mandatory=$false,
                HelpMessage="Write to Error log or not.")]
    [switch]$errorlog,
     
    [Parameter(Mandatory=$true,
                HelpMessage="Client OK = O client BK = B client")]
    [string]$client,
     
    [Parameter(Mandatory=$true,
                HelpMessage="Solution, for example FIN = Financial, HR = Humane resource")]
    [string]$solution
)

BEGIN {
                    
}
PROCESS { 

        try {
            Write-Verbose "Sending email..."
            
            if( $client -eq "OK" -and $solution -eq "FIN") {
                ##REPLACE THIS VALUE!!!
                $EmailFrom = "your_email"
                
                ##REPLACE THIS VALUE!!!
                $EmailTo = "your_email"
            
                $EmailSubject = "Report from Financial solution - OK client." 
                $EmailBody = "This email has as attachments error log and report file from Financial Solution - OK client." 

                ##REPLACE THIS VALUE!!!
                $SMTPserver= "your_SMTP_server"

                ##REPLACE THIS VALUE!!!
                $EncryptedPasswordFile = "$home\Documents\PSCredential\MailJet.txt"
                ##REPLACE THIS VALUE!!!
                $username="your_user_name" 
                $password = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString
                $credential = New-Object System.Management.Automation.PSCredential($username, $password)

                ##Change this as splatting syntax in Send-MailMessage CmdLet
                Send-MailMessage -ErrorAction Stop -from "$EmailFrom" -to "$EmailTo" -subject "$EmailSubject" -body "$EmailBody" -SmtpServer "$SMTPserver" -Attachments $Attachments -Priority $Priority -Credential $credential -Port 587
                
            } elseif ( $client -eq "Test" -and $solution -eq "Test" ) {
                
                ##REPLACE THIS VALUE!!!
                $EmailFrom = "your_email"
                
                ##REPLACE THIS VALUE!!!
                $EmailTo = "your_email"
            
                $EmailSubject = "Test of Send-Email cmdlet" 
                $EmailBody = "This is test email." 

                ##REPLACE THIS VALUE!!!
                $SMTPserver= "your_SMTP_server"

                ##REPLACE THIS VALUE!!!
                $EncryptedPasswordFile = "$home\Documents\PSCredential\MailJet.txt"
                ##REPLACE THIS VALUE!!!
                $username="your_user_name" 
                $password = Get-Content -Path $EncryptedPasswordFile | ConvertTo-SecureString
                $credential = New-Object System.Management.Automation.PSCredential($username, $password)

                ##Change this as splatting syntax in Send-MailMessage CmdLet
                Send-MailMessage -ErrorAction Stop -from "$EmailFrom" -to "$EmailTo" -subject "$EmailSubject" -body "$EmailBody" -SmtpServer "$SMTPserver" -Attachments $Attachments -Priority $Priority -Credential $credential -Port 587
                
            }
            
            Write-Verbose "Email sent."
            
        } catch {
            
            Write-Warning "There was a problem with sending email, check error log. Value of error is: $_"
            
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
                Write-ErrorLog -hostname "Send Email was failing." -errormsg $errormsg -exception $exception -scriptname $scriptname -failinglinenumber $failinglinenumber -failingline $failingline -pscommandpath $pscommandpath -positionmsg $pscommandpath -stacktrace $stacktrace
                Write-Verbose "Finish writing to Error log."
            }
            
        }
}
END { 

}
}

#Send-Email -Attachments "$home\Documents\PSlogs\Error_Log.txt" -Priority "Normal" -errorlog -client "Test" -solution "Test" -Verbose