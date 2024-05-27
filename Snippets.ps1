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

$apiCall = "_apis/wit/workitems/5?`$expand=relations&api-version=7.2-preview.3"
$completeUri = "$base/$organization/$project/$apiCall"

Write-Host
Write-Host "Debug uri:" -ForegroundColor Blue
Write-Host $completeUri

$base64AuthInfo= [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalAccessToken)"))
$headers = @{
    'Accept'='application/json'
    'Authorization'=("Basic {0}" -f $base64AuthInfo)
}

# $body = @"
# [
#     {
#         "id": 100000,
#         "state": "Completed",
#         "comment": "Example comment",
#         "associatedBugs": [
#             {
#                 "id": 4
#             }
#         ]
#     }
# ]
# "@

$body = @"
[
    {
        "op": "add",
        "path": "/relations/-",
        "value": {
            "rel": "ArtifactLink",
            "url": "vstfs:///TestManagement/TcmResult/118.100000",
            "attributes": {
                "comment": "Linked to Test Case"
            }
        }
    }
]
"@

$response = Invoke-RestMethod -Uri $completeUri -Method Get -Headers $headers

Write-Host
Write-Host "Response:" -ForegroundColor Blue
Write-Host $response
# $response.relations