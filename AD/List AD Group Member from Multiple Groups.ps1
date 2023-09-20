# Get AdGroupMember from Multiple Groups

$adgroups = "DL-SALES", "EU-SALES", "FINANCE"

$results = @();

foreach ($group in $adgroups) 

{
   $results+= (Get-ADGroupMember -Identity $group -Recursive)

}

$results | Format-Table -AutoSize | FT