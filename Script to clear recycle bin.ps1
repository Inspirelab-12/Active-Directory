$Path = 'C' + ':\$Recycle.Bin'
Get-ChildItem $Path -Force -Recurse -ErrorAction SilentlyContinue |
Remove-Item -Recurse -exclude *.ini -ErrorAction SilentlyContinue
write-Host "Recycle Bin is empty."