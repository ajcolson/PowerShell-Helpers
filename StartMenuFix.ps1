## Get Current Joined Domain
## Last Modified: 18 June 2023
## Created By: Alex Colson <hello@ajcolson.com>
##
## Fixes error with ACLs locking users from accessing the start menu.

$acl1 = Get-Acl "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\"
#$person = [System.Security.Principal.NTAccount]"all application packages" ##S-1-15-2-1
$sid = New-Object System.Security.Principal.SecurityIdentifier ("S-1-15-2-1")
$person_temp = $sid.Translate( [System.Security.Principal.NTAccount])
$person = $person_temp.Value.Split("\")[1]
$access = [System.Security.AccessControl.RegistryRights]"ReadKey"
$inheritance = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
$propagation = [System.Security.AccessControl.PropagationFlags]"None"
$type = [System.Security.AccessControl.AccessControlType]"Allow"
$rule = New-Object System.Security.AccessControl.RegistryAccessRule($person,$access,$inheritance,$propagation,$type)
$acl1.AddAccessRule($rule)
$acl1 | Set-Acl

if (-not (Get-AppxPackage Microsoft.AAD.BrokerPlugin)) { Add-AppxPackage -Register "$env:windir\SystemApps\Microsoft.AAD.BrokerPlugin_cw5n1h2txyewy\Appxmanifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown } Get-AppxPackage Microsoft.AAD.BrokerPlugin
