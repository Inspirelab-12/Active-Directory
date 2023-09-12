$ADPrivGroupArray = @(
 'Administrators',
 'Domain Admins',
 'Enterprise Admins',
 'Schema Admins',
 'Account Operators',
 'Server Operators',
 'Group Policy Creator Owners',
 'DNSAdmins',
 'Enterprise Key Admins',
 'Exchange Domain Servers',
 'Exchange Enterprise Servers',
 'Exchange Admins',
 'Organization Management',
 'Exchange Windows Permissions'
)
foreach($group in $ADPrivGroupArray){
    try
    {
    $GrpProps = Get-ADGroupMember -Identity $group -Recursive -Server $env:COMPUTERNAME -ErrorAction SilentlyContinue | select SamAccountName,distinguishedName
        $GrpProps | % {
             $_.SamAccountName 
        }  
    }
    catch{
       $_.Exception.Message
    }
}