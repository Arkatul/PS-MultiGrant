. .\Functions\Select-AllDBServersKV.ps1
. .\Functions\Set-MultipleKeyVaultsRoleAssignments.ps1
Function IIf($If, $Right, $Wrong) {If ($If) {$Right} Else {$Wrong}}

# Check if the user is already connected to Azure
$context = Get-AzContext
# Check if the user is already connected to Azure, if not, connect to Azure subscription
if (-not $context) {
    Connect-AzAccount
}


# Get the list of subscriptions
$subscriptions = Get-AzSubscription

# Output the list of subscriptions with a number
for ($i = 0; $i -lt $subscriptions.Count; $i++) {
    Write-Host "$($i+1). $($subscriptions[$i].Name) ($($subscriptions[$i].Id))"
}

# Ask the user to select a subscription by number
$selectedNumber = Read-Host "Enter the number of the subscription to use"

# Get the selected subscription ID
$selectedSubscriptionId = $subscriptions[$selectedNumber-1].Id

# Set the selected subscription as the current context
Set-AzContext -SubscriptionId $selectedSubscriptionId


# Define an array of objects for the principal types and names, and the role to assign to that principal
$principalNamesAndRole = @(
    [PSCustomObject]@{ Type = "Group"; Name = "RBL_AZP_DBa_Admin_AAD"; Role = "Key Vault Administrator" },
    [PSCustomObject]@{ Type = "Group"; Name = "RBL_AZP_DBa_Support_AAD"; Role = "Key Vault Secrets Officer" },
    [PSCustomObject]@{ Type = "ServicePrincipal"; Name = "slsaticingaprd002"; Role = "Key Vault Secrets User" }
)
$principalsObjectIdsAndRole = @()
# Loop through each object in the array and get the object ID for the principal
$principalNamesAndRole | ForEach-Object {
    $role = $_.Role
    $principalObjectID = IIf($_.Type -eq "Group") (Get-AzADGroup -DisplayName $_.Name).Id  (Get-AzADServicePrincipal -DisplayName $_.Name).Id
    $principalsObjectIdsAndRole += [PSCustomObject]@{ PrincipalObjectId = $principalObjectID; RoleDefinitionName = $role }
}

# Get the list of servers to handle
$serversToHandle = Select-AllDBServersKeyVaults

# Initialize arrays to hold classic and all key vaults
$classicKeyvaults = @()
$allKeyvaults = @()

# Loop through each server and get the key vault associated with it
$serversToHandle | ForEach-Object {
    $keyvault=  Get-AzKeyVault -VaultName "kv-$_"
    $allKeyvaults += $keyvault
    # Check if the key vault does not have RBAC authorization enabled
    if(-not $keyvault.EnableRbacAuthorization) {
        $classicKeyvaults += $keyvault
    }
}

# Enable RBAC authorization for classic key vaults
$classicKeyvaults | ForEach-Object {
    Write-Output "Enabling RBAC authorization for key vault $($_.VaultName)"
    Update-AzKeyVault -VaultName $_.VaultName -ResourceGroupName $_.ResourceGroupName -EnablePurgeProtection -EnableRbacAuthorization $true
}

# Assign roles to principals for all key vaults
$principalsObjectIdsAndRole | ForEach-Object {
    $allKeyvaults | Set-MultipleKeyVaultsRoleAssignments -RoleDefinitionName $_.RoleDefinitionName -PrincipalObjectId $_.PrincipalObjectId
}