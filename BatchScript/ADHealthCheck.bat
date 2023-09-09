@echo Off

ECHO YOUR DC Diagnosis is in progress Please wait .............

set logfile=\\ServerName\HealthCheckReport\ADHealth.txt

REM Finds system boot time
echo System Boot Time ------------------------------------------------------------- >> %logfile%
systeminfo | find "System Boot Time:" >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Displays all current TCP/IP network configuration values
echo IPCONFIG ------------------------------------------------------------- >> %logfile%
ipconfig /all >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Analyse the state of domain controllers in a forest and reports any problems to assist in troubleshooting
echo DCDIAG ------------------------------------------------------------- >> %logfile%
dcdiag /a >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM The replsummary operation quickly summarizes the replication state and relative health
echo Replsummary ------------------------------------------------------------- >> %logfile%
repadmin /replsummary >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Displays the replication partners for each directory partition on the specified domain controller
echo Showrepl ------------------------------------------------------------- >> %logfile%
repadmin /showrepl >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Displays the Queue status for the replication
echo Queue ------------------------------------------------------------- >> %logfile%
Repadmin /Queue >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Displays the synchronization status 
echo Syncall ------------------------------------------------------------- >> %logfile%
Repadmin /syncall >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Displays the KCC Check
echo KCC ------------------------------------------------------------- >> %logfile%
Repadmin /KCC >> %logfile%
echo. >> %logfile%
echo. >> %logfile%
REM Display the FSMO roles
echo NETDOM Query FSMO ------------------------------------------------------------- >> %logfile%
netdom query fsmo >> %logfile%
REM Global Catalogs
echo List Global Catalogs ------------------------------------------------------------- >> %logfile%
for /f "tokens=2" %%a in ('systeminfo ^| findstr Domain:') do set domain=%%a
nslookup -querytype=srv _gc._tcp.%domain% >> %logfile%

-----------------------------------------------------------------------------------------------------

