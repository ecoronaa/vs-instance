# Variables de configuración
$base = "https://dev.azure.com"
$organization = $env:ORG
$project = $env:PROJECT
$personalAccessToken = $env:PAT

Write-Host $organization
Write-Host $project
Write-Host $personalAccessToken

$uri = "$base/$organization"

$body = @"
[
    {
        "op": "add",
        "path": "/fields/System.Title",
        "from": null,
        "value": "Example"
    }
]
"@

$workItemsUri = "$uri/$project/_apis/wit/workitems/"+"$"+"Issue?api-version=6.0"
Write-Host $workItemsUri

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))

$response = Invoke-RestMethod -Uri $workItemsUri -ContentType "application/json-patch+json" -Method "PATCH" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Body $body

Write-Host responde.id