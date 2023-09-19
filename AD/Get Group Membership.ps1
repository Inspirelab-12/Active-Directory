# Get Group Membership
#---------------------------------

Get-ADPrincipalGroupMembership xxxx | select name,groupscope

# Exambles
#--------------------------------------------------------------------------------------------------------------
# Get Global Security Group for a user is a member of
# 	Get-ADPrincipalGroupMembership xxxx | select name,groupscope | Where-Object Groupscope -eq "Global"

# Get Local Security Group for a user is a member of
#  	Get-ADPrincipalGroupMembership xxxx | select name,groupscope | Where-Object Groupscope -eq "domainlocal"