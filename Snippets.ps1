function GetUrl() {
    param(
        [string]$orgUrl,
        [hashtable]$header,
        [string]$AreaId
    )

    $orgResourceAreasUrl = [string]::Format("{0}/_apis/resourceAreas/{1}?api-version=6.0-preview.1", $orgUrl, $AreaId)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $results = Invoke-RestMethod -Uri $orgResourceAreasUrl -Headers $header

    if ("null" -eq $results) {
        $areaUrl = $orgUrl
    }
    else {
        $areaUrl = $results.locationUrl
    }

    return $areaUrl
}

$orgUrl = $ORG_URL
$personalToken = $PAT
$testAreaId = "3b95fb80-fdda-4218-b60e-1052d070ae6b"

Write-Host "Initialize authentication context" -ForegroundColor Yellow
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($personalToken)"))
$header = @{authorization = "Basic $token" }

$tfsBaseUrl = GetUrl -orgUrl $orgUrl -header $header -AreaId $testAreaId
