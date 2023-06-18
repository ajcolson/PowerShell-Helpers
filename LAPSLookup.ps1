## LAPS Password Finder
## Last Modified: 19 Apr 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## This script helps find the LAPS password from AD for a given hostname.
## If no password is registered in AD, the script will return no results.

param(
    [string]$Hostname = $( Read-Host "Enter the hostname of the computer you are searching for" ),
    [switch]$ShowAll = $False
)

# Check domain of user invoking script.
$curDomain= Get-ADDomain | Select-Object -ExpandProperty Name
Write-Warning "You will only see results from machines joined to the ""${curDomain}"" domain."


# List of comma seperated DCs
$DCs = "dc-na-01.contoso.com", "dc-na-02.contoso.com", "dc-eu-01.contoso.com"

Write-Host "Running queries now. This may take a few moments..."

$queryResults = foreach( $dc in $DCs ) {
    Write-Host "Pinging DC: ${dc}"
    $dcPassword = get-adcomputer -Identity $Hostname -Properties ms-Mcs-AdmPwd -Server $dc | Select-Object -ExpandProperty ms-Mcs-AdmPwd
    New-Object PSObject -Property @{
        DC_NAME = $dc
        PASSWORD = $dcPassword
    }
    
    #If we aren't asked to show all results, we should stop after the first result that is not blank
    if ( ($dcPassword -ne "") -And ($ShowAll -eq $False) ){
        break
    }
}
Write-Host "Done. Printing results..."
$queryResults | Format-Table