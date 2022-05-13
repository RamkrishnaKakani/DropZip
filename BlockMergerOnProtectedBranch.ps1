[CmdletBinding()]
param (
  [parameter(Mandatory=$True)]
  [string]$Token,
  [parameter(Mandatory=$True)]
  [string]$ownerName,
  [parameter(Mandatory=$True)]
  [string]$repoName,
  [parameter(Mandatory=$True)]
  [string]$protectedBranch,
  [parameter(Mandatory=$True)]
  [string]$pullNumber
)

#Creating Authentication Token (Header)
$base64token = [System.Convert]::ToBase64String([char[]]$Token);
$Headers = @{ Authorization = 'Basic {0}' -f $base64token;  };

$pullRequestUrl = "https://api.github.com/repos/$ownerName/$repoName/pulls/$pullNumber"
$pullReuqestDetails = Invoke-RestMethod -Headers $Headers -uri $pullRequestUrl -Method Get
$baseBranch = $pullReuqestDetails.base.ref

$branchUrl = "https://api.github.com/repos/$ownerName/$repoName/branches/$baseBranch"
$branchDetails = Invoke-RestMethod -Headers $Headers -uri $branchUrl -Method Get

if($branchDetails.protected -and $baseBranch -eq $protectedBranch)
{
    $pullRequestBody = @{
            "state" = "closed";
        } | ConvertTo-Json;

    $commentBody = @{
            "body" = "Cannot Merge Pull Request as Base Branch is Protected... Closing Pull Request!";
        } | ConvertTo-Json;

    $commentUrl = "https://api.github.com/repos/$ownerName/$repoName/issues/$pullNumber/comments"
    $addCommentOnPR = Invoke-RestMethod -Headers $Headers -uri $commentUrl -Body $commentBody -Method Post

    $updatePullRequest = Invoke-RestMethod -Headers $Headers -uri $pullRequestUrl -Body $pullRequestBody -Method Post
}
