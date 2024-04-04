Import-Module AzureArcDeployment.psm1

$DomainFQDN = "DOMAIN.FQDN"
$ServicePrincipalSecret = "ServicePrincipalPlainText"
$SecretFile = "PATH_TO_ARC_DEPLOY\encryptedServicePrincipalSecret"

$DomainNetbios = (Get-ADDomain $DomainFQDN).NetBIOSName
$DomainComputersSID = (Get-ADDomain).DomainSID.Value + '-515'
$DomainComputersName = (Get-ADGroup -Filter "SID -eq `'$DomainComputersSID`'").Name
$DomainControllersSID = (Get-ADDomain).DomainSID.Value + '-516'
$DomainControllersName = (Get-ADGroup -Filter "SID -eq `'$DomainControllersSID`'").Name


$identity = "$DomainNetbios\$DomainComputersName"
$identity2 = "$DomainNetbios\$DomainControllersName"

$DomainComputersSID = "SID=" + $DomainComputersSID
$DomainControllersSID = "SID=" + $DomainControllersSID
$descriptor = @($DomainComputersSID, $DomainControllersSID) -join " OR "

$encryptedSecret = [DpapiNgUtil]::ProtectBase64($descriptor, $ServicePrincipalSecret)
$encryptedSecret | Out-File -FilePath $SecretFile -Force
