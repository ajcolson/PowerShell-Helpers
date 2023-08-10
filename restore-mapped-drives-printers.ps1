##
## Written By: Alex Colson <hello@ajcolson.com>
## 23 Aug 2018
##

# Import drive list.
$mappedDrives = Import-Csv "$($env:USERPROFILE)\Desktop\mappedDrives.csv"

# Iterate over the drives in the list.
foreach ($drive in $mappedDrives) {
    # Create a new mapped drive for this entry.
    New-PSDrive -Name $drive.Name -PSProvider "FileSystem" -Root $drive.DisplayRoot -Scope "Global" -Persist -ErrorAction Continue 
}

##restore printers
C:\Windows\System32\spool\tools\Printbrm.exe /r /f "$($env:USERPROFILE)\Desktop\printersBackup.printerExport"

exit