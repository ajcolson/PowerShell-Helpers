## LAPS Password Finder
## Last Modified: 4 Aug 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## This script helps find the LAPS password from AD for a given hostname.
## If no password is registered in AD, the script will return no results.
## Includes option to copy password directly to clipboard.

param(
    [string]$Hostname = $( Read-Host "Enter the hostname of the computer you are searching for" ),
    [switch]$ShowAll = $False,
    [switch]$CopyToClipboard = $False
)

# If no hostname is provided, exit
if ($Hostname -eq ""){
    Write-Host "No hostname specified. Exitting..."
    exit
}

# Check if the user would like us to copy to the clipboard if not specified.
$doCopyToClipboard = $CopyToClipboard
if ($CopyToClipboard -eq $False){
    $doCopyToClipboard = ((Read-Host "Should we copy the password directly to your clipboard if found? (y/n)") -eq "y")
}

# Check domain of user invoking script.
$curDomain= Get-ADDomain | Select-Object -ExpandProperty Name
Write-Warning "You will only see results from machines joined to the ""${curDomain}"" domain."


# List of comma seperated DCs
$DCs = "dc-na-01.contoso.com", "dc-na-02.contoso.com", "dc-eu-01.contoso.com"

Write-Host "Running queries now. This may take a few moments..."

$queryResults = foreach( $dc in $DCs ) {
    Write-Host "Pinging DC: ${dc}"
    $dcPassword = get-adcomputer -Identity $Hostname -Properties ms-Mcs-AdmPwd -Server $dc | Select-Object -ExpandProperty ms-Mcs-AdmPwd
    $expiresOnFromDC = get-adcomputer -Identity $Hostname -Properties ms-Mcs-AdmPwdExpirationTime -Server $dc | Select-Object -ExpandProperty ms-Mcs-AdmPwdExpirationTime    
    $expiresOn = ""
    
    # Format the expires date if not blank
    if ($expiresOnFromDC -ne ""){
        $expiresOn = [datetime]::FromFileTime($expiresOnFromDC)
    }

    # Copy to clipboard if allowed and password is not blank
    if (($dcPassword -ne "") -and ($doCopyToClipboard -eq $True)) {
        Set-Clipboard -Value $dcPassword
    }

    # Return Object with info
    New-Object PSObject -Property @{
        DC_NAME = $dc
        PASSWORD = $dcPassword
        EXPIRES_ON = $expiresOn
    } 
}
Write-Host "Done. Printing results..."
$queryResults | Format-Table
