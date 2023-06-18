## Get AD Group Membership For User
## Last Modified: 11 Apr 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## This script will list all group memberships for a particular user.

param(
    [string]$username = $( Read-Host "Enter the username you want to find the groups of" )
)
$curDomain = Get-ADDomain | Select-Object -ExpandProperty Name
Write-Warning ("You will only be able to see results for accounts on the '{0}' domain from this machine." -f $curDomain)

(Get-ADUser $username -Properties MemberOf).memberof | Get-ADGroup | Select-Object -ExpandProperty name