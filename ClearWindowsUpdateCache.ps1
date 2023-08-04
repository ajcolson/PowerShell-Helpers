## Clear Windows Update Cache
## Last Modified: 4 Aug 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## Run this is Windows updates are not installing, stalling, or fails outright.
## This must be run by a user account with local adminstirator rights.

net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
Rename-Item -Path "C:\Windows\SoftwareDistribution" -NewName "C:\Windows\SoftwareDistribution.old"
Rename-Item -Path "C:\Windows\System32\catroot2" -NewName "C:\Windows\System32\catroot2.old"
net start wuauserv
net start cryptSvc
net start bits
net start msiserver