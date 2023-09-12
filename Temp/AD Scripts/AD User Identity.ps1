
######--------------------AD User Identity----------------------################## 

Get-ADUser -identity athambiraj -properties *  | Export-csv -path c:\temp\athambiraj.csv