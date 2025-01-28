function Set-MultipleKeyVaultsRoleAssignments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [object[]]$KeyVaults,
        [Parameter(Mandatory = $true)]
        [string]$RoleDefinitionName,
        [Parameter(Mandatory = $true)]
        [string]$PrincipalObjectId
    )
    begin {
        $roleAssignments = @()
    }
    process {
        $KeyVaults | ForEach-Object {
            $existingRoleAssignment = Get-AzRoleAssignment -ObjectId $PrincipalObjectId -RoleDefinitionName $RoleDefinitionName -Scope $_.ResourceId -ErrorAction SilentlyContinue
            if ($null -eq $existingRoleAssignment) {
                $roleAssignments += New-AzRoleAssignment -ObjectId $PrincipalObjectId -RoleDefinitionName $RoleDefinitionName -Scope $_.ResourceId
            } else {
                $roleAssignments += $existingRoleAssignment
            }
        }
    }
    end {
        return $roleAssignments
    }
}