# Functions

## `Select-AllDBServersKeyVaults`

This function retrieves all MySQL, PostgreSQL, and SQL servers in the Azure subscription and prompts the user to select which servers to handle. It returns an array of selected server names.

### Detailed Steps:
1. **Retrieve MySQL Servers**: Uses `Get-AzResource` to get all MySQL flexible servers.
2. **Prompt User for MySQL Servers**: Prompts the user to decide whether to handle each MySQL server.
3. **Retrieve PostgreSQL Servers**: Uses `Get-AzResource` to get all PostgreSQL flexible servers.
4. **Prompt User for PostgreSQL Servers**: Prompts the user to decide whether to handle each PostgreSQL server.
5. **Retrieve SQL Servers**: Uses `Get-AzResource` to get all SQL servers.
6. **Prompt User for SQL Servers**: Prompts the user to decide whether to handle each SQL server.
7. **Return Selected Servers**: Returns an array of server names that the user chose to handle.

## `Set-MultipleKeyVaultsRoleAssignments`

This function assigns specified roles to principals for a list of Key Vaults. It checks if the role assignment already exists and creates it if it does not.

### Detailed Steps:
1. **Initialize Role Assignments Array**: Initializes an empty array to store role assignments.
2. **Process Each Key Vault**: Loops through each Key Vault provided in the input.
3. **Check Existing Role Assignment**: Checks if the role assignment already exists for the given principal and role.
4. **Create Role Assignment if Needed**: If the role assignment does not exist, creates a new role assignment.
5. **Return Role Assignments**: Returns the array of role assignments, including both existing and newly created ones.
