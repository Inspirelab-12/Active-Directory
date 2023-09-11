Write-Host 'AD User Info:

  1. Human Resources
  2. Financial Resources
  3. Information Technology 
  q. Quit'


While (($Selection = Read-Host -Prompt 'Please select an option') -notin 1,2,3,4,'q') 
{ 
    Write-Warning "$Selection is not a valid option" 
}

Switch ($Selection) {
    1 { Get-ADUser -Filter 'department -like "Human Resources"' | Select -Property * | Out-GridView }
    2 { Get-ADUser -Filter 'department -like "Financial Resources"' | Select -Property * | Out-GridView }
    3 { Get-ADUser -Filter 'department -like "Information Technology"' | Select -Property * | Out-GridView }
    4 { $env:computername }
   
}