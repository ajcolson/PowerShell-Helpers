## Network Drive Remapper
## Last Modified: 20 June 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## Use this script to remap network drives for users based on an input CSV file.
## An example use case is to have this as a startup process on workstations
## where the mapping files can be stored in the user's profile.

param(
    [string]$MapFile = "$env:USERPROFILE\remap-drives.csv",
    [switch]$NoPersist = $False,
    [switch]$NoRemoveExistingDrives = $False,
    [switch]$WhatIf = $False
)

<#

This script assumes the format of the CSV follows the rules below:

- The first line is a header line. The exact line reads (without quotes) "drive_letter,drive_path,persistent"
- Each line after will follow the headers with information:
    - First value is the drive Letter you wish to map. Include the ":" char.
    - Second value is the path you are trying to map.
    - Third value is whether the mapping should be marked Persistent. Use "true" or "false"

Example File:

drive_letter,drive_path,persistent
Z:,"\\fileserver\FolderA",true
Y:,"\\fileserver\FolderB",false

 #>

if ($WhatIf -eq $True){
    Write-Host "Attempting to find mapping entries from file: ""$MapFile"""
    try {
        Import-CSV -Path $MapFile | 
            ForEach-Object {
                Write-Host "Found entry."
                if ( $NoRemove -eq $False ){
                    Write-Host "This entry would try to overwrite a curent mapping."
                }
                Write-Host "This entry would map to drive letter $($_.drive_letter)"
                Write-Host "This entry would map to folder path $($_.drive_path)"
                if ( $NoPersist -eq $False -or $_.persistent -eq "false"){
                    Write-Host "This entry is flagged to not be persistent."
                } else {
                    Write-Host "This entry is flagged to be persistent."
                }
            }
        Write-Host "No more entries found. The process would exit now."
    } catch {
        Write-Error "An error occured trying to remap drives."
    }
} else {
    try {
        Import-CSV -Path $MapFile | 
            ForEach-Object {
                if ( $NoRemoveExistingDrives -eq $False ){
                    net use $_.drive_letter /DELETE /Y
                }
                if ( $NoPersist -eq $False -or $_.persistent -eq "false"){
                    net use $_.drive_letter $_.drive_path
                } else {
                    net use $_.drive_letter $_.drive_path /PERSISTENT:YES
                }
            }
    } catch {
        Write-Error "An error occured trying to remap drives."
    }
}



