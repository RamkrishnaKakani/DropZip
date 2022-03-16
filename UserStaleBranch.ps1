﻿cd C:\Users\R888066\source\repos\POH-BusinessServices-New

#Defining Arrays
[System.Collections.ArrayList]$results = @()
[System.Collections.ArrayList]$staleUserBranches = @()
[System.Collections.ArrayList]$branchesToBeDeleted = @()

#Creating Authentication Token (Header)
$Token = "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"
$base64token = [System.Convert]::ToBase64String([char[]]$Token);
$Headers = @{ Authorization = 'Basic {0}' -f $base64token;  };

#Organaisation & Repository Name
$ownerName = "allscriptshealthcare"
$repoName = "POH-BusinessServices"

Write-Host "`nGetting List of All Branches..."

#List of All Branches present in given repo
git fetch origin
$remoteBranches = git branch -a | Where-Object {$_ -like '*remotes/origin/*'} | ForEach-Object {$_.trim()}
$remoteBranches = $remoteBranches | Where-Object { ($_ -notlike 'remotes/origin/HEAD*') `
                                              -and ($_ -ne 'remotes/origin/main') `
                                              -and ($_ -ne 'remotes/origin/development') `
                                              -and ($_ -ne 'remotes/origin/master') }

Write-Host "`nStarting to calculate stale Branches..."

foreach( $branch in $remoteBranches)
{
    $branch = $branch.Replace('remotes/origin/','')

    #Retriving Branch Details
    $uri = "https://api.github.com/repos/$ownerName/$repoName/branches/$branch"
    $info = Invoke-RestMethod -Headers $Headers -uri $uri -Method Get

    $commiterName = $info.commit.commit.author.name
    $lastCommitDate = $info.commit.commit.author.date
    $userEmailID = $info.commit.commit.author.email

    $commitDate = (Get-Date $lastCommitDate)
    $today = (Get-Date).AddDays(-90)

    #Determine whether branch is stale or not
    if($today -gt $commitDate)
    {  
        $details = @{
             "Branch Name" = $branch
             "Last Commit by" = $commiterName
             "Email ID" = $userEmailID
             "Last Commit date" = $lastCommitDate
        }

        $branchDetails = New-Object PSObject -Property $details
        [void]$results.Add($branchDetails)

        #Determining Stale User Branches
        if( $branch -match "user/" -or $branch -match "User/" -or $branch -match "users/" -or $branch -match "Users/")
        {         
            sleep(1)   
            [void]$staleUserBranches.Add($branchDetails)

            $userUrl ="https://api.github.com/search/issues?q=is:pr+repo:$ownerName/$repoName+head:$branch+state:closed"
            $userBranchDetails = Invoke-RestMethod -Headers $Headers -uri $userUrl -Method Get

            if($userBranchDetails.items.Number)
            {
                $prNumber = $userBranchDetails.items.Number
                $prUrl = "https://api.github.com/repos/$ownerName/$repoName/pulls/$prNumber"
                $prDetails = Invoke-RestMethod -Headers $Headers -uri $prUrl -Method Get

                if($prDetails.merged -eq "True")
                {
                    [void]$branchesToBeDeleted.Add($branchDetails)
                }
            }
        }
    }
}

Write-Host "Generating Output Files"

#Generate List of All Stale Branches
$results | export-csv -Path C:\Users\R888066\Desktop\BS_AllStalesBranches.csv -NoTypeInformation

#Generate List of User Stale Branches
$staleUserBranches | export-csv -Path C:\Users\R888066\Desktop\BS_UserStalesBranches.csv -NoTypeInformation

#Generate List of User Stale Branches which we can Delete Automatically
$branchesToBeDeleted | export-csv -Path C:\Users\R888066\Desktop\BE_branchesToBeDeleted.csv -NoTypeInformation