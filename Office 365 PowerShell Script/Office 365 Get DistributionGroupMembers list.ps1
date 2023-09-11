# Collecting GroupObject Id
$GroupId = Get-MsolGroup -SearchString "DWC Support" | Export-CSV "C:\temp\For-GroupObject-ID.csv" -NoTypeInformation -Encoding UTF8 

########################################

# Get-MsolGroupMember -GroupObjectId 8d003c1e-594e-4371-8d59-2b3a6e269929 | Export-CSV "C:\temp\DWC-Accounts-Members.csv" -NoTypeInformation -Encoding UTF8
