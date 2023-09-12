#Get User Identity
Get-ADUser -identity usernam -properties *  | Export-csv -path c:\temp\athambiraj.csv