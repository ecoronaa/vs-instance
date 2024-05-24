function GetUrl() {
    param(
        [string]$orgUrl,
        [hashtable]$header,
        [string]$AreaId
    )

    $orgResourceAreasUrl = [string]::Format("{0}/_apis/resourceAreas/{1}?api-version=6.0-preview.1", $orgUrl, $AreaId)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-RestMethod -Uri $orgResourceAreasUrl -Headers $header
}

$orgUrl = $ORG_URL
$personalToken = $PAT

Write-Host "Initialize authentication context" -ForegroundColor Yellow
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalToken)"))
$header = @{authorization = "Basic $token" }

GetUrl -orgUrl $orgUrl -header $header -AreaId $testAreaId