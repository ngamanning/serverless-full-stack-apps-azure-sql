## server name: bus-server875044
## region: westus
## constr
##Server=bus-server875044.database.windows.net,1433;Initial Catalog=bus-db;User Id=cloudadmin;Password=pa$$w0rd%6!23sa!21;Connection Timeout=30;
# Step 1) Collect password 
$adminSqlLogin = "cloudadmin"
$password = "pa$$w0rd%6!23sa!21"
# Prompt for local ip address
$ipAddress = "73.225.105.98"
Write-Host "Password and IP Address stored"

# Step 2) Get resource group and location and random string
$resourceGroupName = "learn-76c36de2-2864-4eac-a418-d4b4674f0756"
$uniqueID = Get-Random -Minimum 100000 -Maximum 1000000
$location = $resourceGroup.Location
# The logical server name has to be unique in the system
$serverName = "bus-server$($uniqueID)"
# The sample database name
$databaseName = "bus-db"    
Write-Host "Please note your unique ID for future exercises in this module:"  
Write-Host $uniqueID
Write-Host "Your resource group name is:"
Write-Host $resourceGroupName
Write-Host "Your resources were deployed in the following region:"
Write-Host $location
Write-Host "Your server name is:"
Write-Host $serverName

#step 3: 
# Create a new server with a system wide unique server name
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

# Create a server firewall rule that allows access from the specified IP range and all Azure services
$serverFirewallRule = New-AzSqlServerFirewallRule `
    -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "AllowedIPs" `
    -StartIpAddress $ipAddress -EndIpAddress $ipAddress 
$allowAzureIpsRule = New-AzSqlServerFirewallRule `
    -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -AllowAllAzureIPs
# Create a database
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -Edition "GeneralPurpose" -Vcore 4 -ComputeGeneration "Gen5" `
    -ComputeModel Serverless -MinimumCapacity 0.5
Write-Host "Database deployed."