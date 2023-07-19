## GetUserHomeDirFromSID
## Last Modified: 19 July 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## Given a SID for a user, find the home dir as defined in the Registry.

param(
    [string]$UserSID = $(Read-Host "Enter the SID of the user you are looking for")
)

Get-ItemPropertyValue "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList\$UserSID" -Name ProfileImagePath
