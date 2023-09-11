$group = gwmi win32_group -filter 'Name = "Administrators"'
$group.GetRelated('Win32_UserAccount')