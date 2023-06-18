## Get Current Joined Domain
## Last Modified: 11 Apr 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## This script returns the name of the currently joined Domain

Get-ADDomain | Select-Object -ExpandProperty Name