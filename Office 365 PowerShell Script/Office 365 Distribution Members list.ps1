# Install-module -name MSOnline
# Get-Module -ListAvailable
# $GroupId = Get-MsolGroup -SearchString "DWC Support" | Export-CSV "C:\temp\For-GroupObject-ID.csv" -NoTypeInformation -Encoding UTF8 
# Get-MsolGroupMember -GroupObjectId 8d003c1e-xxxx-xxx-xxx-xxxxxxxxx | Export-CSV "C:\temp\Holiday-Inn-DGroupMembers.csv" -NoTypeInformation -Encoding UTF8