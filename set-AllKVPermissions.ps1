# Connect to Azure subscription if not already connected
Connect-AzAccount
# Check if the user is already connected to Azure
$context = Get-AzContext
if (-not $context) {
    Connect-AzAccount
}

# Get the list of subscriptions
$subscriptions = Get-AzSubscription

# Output the list of subscriptions
$subscriptions | ForEach-Object { Write-Host "$($_.Name) ($($_.Id))" }

# Ask the user to select a subscription
$selectedSubscriptionId = Read-Host "Enter the subscription ID to use"

# Set the selected subscription as the current context
Set-AzContext -SubscriptionId $selectedSubscriptionId



# Get all MySQL flexible servers in the subscription
$mysqlServers = Get-AzResource -ResourceType "Microsoft.DBforMySQL/flexibleServers"

# Create an array to store server names
$mysqlServerNames = @()

# Loop through each server and add the name to the array
foreach ($server in $mysqlServers) {
    $mysqlServerNames += $server.Name
}

$serversToHandle = @()

$mysqlServerNames | ForEach-Object { 
   $answer=Read-Host "Handle $_ ? (y/n)"
    if ($answer -eq 'y') {
         $serversToHandle += $_
    }
}

# Get all PostgreSQL flexible servers in the subscription
$postgresqlServers = Get-AzResource -ResourceType "Microsoft.DBforPostgreSQL/flexibleServers"

# Create an array to store server names
$postgresqlServerNames = @()

# Loop through each server and add the name to the array
foreach ($server in $postgresqlServers) {
    $postgresqlServerNames += $server.Name
}

$postgresqlServerNames | ForEach-Object { 
   $answer=Read-Host "Handle $_ ? (y/n)"
    if ($answer -eq 'y') {
         $serversToHandle += $_
    }
}


# Get all SQL servers in the subscription
$sqlServers = Get-AzResource -ResourceType "Microsoft.Sql/servers"

# Create an array to store server names
$sqlServerNames = @()

# Loop through each server and add the name to the array
foreach ($server in $sqlServers) {
    $sqlServerNames += $server.Name
}

$sqlServerNames | ForEach-Object { 
   $answer = Read-Host "Handle $_ ? (y/n)"
    if ($answer -eq 'y') {
         $serversToHandle += $_
    }
}

# Output the servers to handle
$serversToHandle