w32tm /query /status
w32tm /config /syncfromflags:domhier /update
net stop w32time
net start w32time

