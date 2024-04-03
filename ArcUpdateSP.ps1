Import-module ActiveDirectory

[Parameter(Mandatory = $True)]
[System.String]$ServicePrincipalSecret

#Add Access to Domain Computers and Domain Controllers
$DomainComputersSID = (Get-ADDomain).DomainSID.Value + '-515'
$DomainComputersName = (Get-ADGroup -Filter "SID -eq `'$DomainComputersSID`'").Name
$DomainControllersSID = (Get-ADDomain).DomainSID.Value + '-516'
$DomainControllersName = (Get-ADGroup -Filter "SID -eq `'$DomainControllersSID`'").Name


# Encrypting the ServicePrincipalSecret to be decrypted only by the Domain Controllers and the Domain Computers security groups
$DomainComputersSID = "SID=" + $DomainComputersSID
$DomainControllersSID = "SID=" + $DomainControllersSID
$descriptor = @($DomainComputersSID, $DomainControllersSID) -join " OR "

Import-Module $PSScriptRoot\AzureArcDeployment.psm1
$encryptedSecret = [DpapiNgUtil]::ProtectBase64($descriptor, $ServicePrincipalSecret)
