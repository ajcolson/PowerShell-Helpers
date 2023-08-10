###This file was autoinstalled by the Mapped Drive Printer Wizard.

##
## Written By: Alex Colson <hello@ajcolson.com>
## 23 Aug 2018
##



# Define array to hold identified mapped drives.
$mappedDrives = @()

# Get a list of the drives on the system, including only FileSystem type drives.
$drives = Get-PSDrive -PSProvider FileSystem

# Iterate the drive list
foreach ($drive in $drives) {
    # If the current drive has a DisplayRoot property, then it's a mapped drive.
    if ($drive.DisplayRoot) {
        # Exctract the drive's Name (the letter) and its DisplayRoot (the UNC path), and add then to the array.
        $mappedDrives += Select-Object Name,DisplayRoot -InputObject $drive
    }
}

# Take array of mapped drives and export it to a CSV file.
$mappedDrives | Export-Csv "$($env:USERPROFILE)\Desktop\mappedDrives.csv"

##Backup printers
C:\Windows\System32\spool\tools\Printbrm.exe /b /f "$($env:USERPROFILE)\Desktop\printersBackup.printerExport"

exit