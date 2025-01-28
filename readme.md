# PS-MultiGrant

This PowerShell script automates the process of assigning roles to principals for multiple Azure Key Vaults. It connects to an Azure subscription, retrieves a list of database servers, and assigns specified roles to groups and service principals for the associated Key Vaults.

## Functions

### `Select-AllDBServersKeyVaults`

This function retrieves all MySQL, PostgreSQL, and SQL servers in the subscription and prompts the user to select which servers to handle. It returns an array of selected server names.

### `Set-MultipleKeyVaultsRoleAssignments`

This function assigns specified roles to principals for a list of Key Vaults. It checks if the role assignment already exists and creates it if it does not.

## Main Script

1. **Check Azure Connection**: The script checks if the user is already connected to Azure and prompts for login if not.
2. **Select Subscription**: The user is prompted to select an Azure subscription from a list.
3. **Define Principals and Roles**: An array of objects is defined, specifying the type, name, and role for each principal.
4. **Retrieve Key Vaults**: The script retrieves the Key Vaults associated with the selected database servers using the `Select-AllDBServersKeyVaults` function.
5. **Enable RBAC Authorization**: For Key Vaults without RBAC authorization enabled, it enables RBAC.
6. **Assign Roles**: The script assigns the specified roles to the principals for all Key Vaults using the `Set-MultipleKeyVaultsRoleAssignments` function.
