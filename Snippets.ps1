# Variables de configuración
$base = "https://dev.azure.com"
$organization = $ORG
$project = $PROJECT
$personalAccessToken = $PAT

Write-Host "==================================="
Write-Host "Debug env:" -ForegroundColor Blue
Write-Host $organization
Write-Host $project
Write-Host $personalAccessToken

$apiCall = "_apis/wit/workitems/6?`$expand=relations&api-version=7.2-preview.3"
# $apiCall = "_apis/wit/workitems/6?api-version=7.2-preview.3"
$completeUri = "$base/$organization/$project/$apiCall"

Write-Host
Write-Host "Debug uri:" -ForegroundColor Blue
Write-Host $completeUri

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headersGet = @{
    'Accept'='application/json'
    'Authorization'=("Basic {0}" -f $base64AuthInfo)
}

$headersPatch = @{
    'Accept'='application/json'
    'Content-Type'='application/json-patch+json'
    'Authorization'=("Basic {0}" -f $base64AuthInfo)
}

$body = @"
[
    {
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": "Microsoft.VSTS.Common.TestedBy-Forward",
            "url": "https://dev.azure.com/ecoronaaqa/1ac16919-9bfe-4e56-b000-e31f12c52c49/_apis/wit/workItems/3",
            "attributes": {
                "name": "Tested By"
            }
        }
    },
    {
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": "ArtifactLink",
            "url": "vstfs:///Build/Build/80",
            "attributes": {
                "name": "Found in build"
            }
        }
    },
    {
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": "ArtifactLink",
            "url": "vstfs:///TestManagement/TcmResult/118.100000",
            "attributes": {
                "name": "Test Result"
            }
        }
    },
    {
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": "ArtifactLink",
            "url": "vstfs:///TestManagement/TcmTest/tcm.643699128",
            "attributes": {
                "name": "Test"
            }
        }
    }
]
"@

$response = Invoke-RestMethod -Uri $completeUri -Method Get -Headers $headersGet
# $response = Invoke-RestMethod -Uri $completeUri -Method Patch -Headers $headersPatch -Body $body

Write-Host
Write-Host "Response:" -ForegroundColor Blue
Write-Host $response
# $response.relations