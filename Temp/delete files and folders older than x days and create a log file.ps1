$StartFolder = "C:\temp files"

#delete old files
Get-ChildItem $StartFolder -Recurse -include *.bak -Force -ea 0 | 
? {!$_.PsIsContainer -and $_.LastWriteTime -lt (Get-Date).AddDays(-7)} | 
ForEach-Object {
	$_ | del -Force
	$_.FullName | Out-File c:\report.txt -Append
} 

#delete empty folders
Get-ChildItem $StartFolder -Recurse -Force -ea 0 |
? {$_.PsIsContainer -eq $True} |
? {$_.getfiles().count -eq 0} |
ForEach-Object {
    $_ | del -Force
    $_.FullName | Out-File c:\scanfdolerlog.txt -Append
}