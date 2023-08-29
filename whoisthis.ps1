## whoisthis
## Last Modified: 29 Aug 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## This script is like the builtin command whoami, but shows extra information.

systeminfo | findstr /B /C:"Domain"
Write-Output "Home Directory:            $($env:UserProfile)"
$userid = whoami | Out-String
Write-Output "User ID:                   $userid"