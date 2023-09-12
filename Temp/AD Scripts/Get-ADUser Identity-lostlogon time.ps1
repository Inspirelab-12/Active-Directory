
#############---------------Last Logon Single Users in Domain-------------############

Get-ADUser -Identity SQLAdmin


###############--------------------------------------------------##################################

Get-ADUser -Identity SQLAdmin -Properties LastLogon | Select Name, @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}}


#############------------------Last Logon All Users in Domain---------------####################### 


Get-ADUser -Filter * -Properties lastLogon | Select samaccountname, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}

