## Get Bitlocker Key From DC
## Last Modified: 11 Apr 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## This script returns a Bitlocker Recovery Key from a defined DC in Active Dictory

param(
    [string]$Hostname= $( Read-Host "Enter the hostname of the computer to lookup" ),
    [switch]$ShowAll = $False
)

# List of comma seperated DCs
$DCs = "dc-na-01.contoso.com", "dc-na-02.contoso.com", "dc-eu-01.contoso.com"

Write-Host "Running queries now. This may take a few moments..."

$queryResults = foreach( $dc in $DCs ) {
    Write-Host "Pinging DC: ${dc}"
    
    $computer = Get-ADComputer $Hostname -Server $dc
    $RecoveryKey = Get-ADObject -Server $dc -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -SearchBase $computer.DistinguishedName -Properties whenCreated, msFVE-RecoveryPassword | Sort-Object whenCreated -Descending | Select-Object whenCreated, msFVE-RecoveryPassword
    
    New-Object PSObject -Property @{
        DC_NAME = $dc
        RECOVERY_KEY = $RecoveryKey
    }
    
    #If we aren't asked to show all results, we should stop after the first result that is not blank
    if ( ($RecoveryKey -ne "") -And ($ShowAll -eq $False) ){
        break
    }
}
Write-Host "Done. Printing results..."
$queryResults | Format-Table
