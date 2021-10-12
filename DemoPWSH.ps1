function printsign()
{
    param(
    [string]$_FilesToBeSigned,
    [string]$_FilesLocation
    )
    
    write-host $_FilesToBeSigned
    write-host $_FilesLocation
    
    $_AllFiles = Get-Content -Path $_FilesToBeSigned
    foreach($file in $_AllFiles)
    {
        $_filePath = $_FilesLocation + "\" + $file

        if(([System.IO.File]::Exists($_filePath)))
        {
            $_Signstatus = Get-AuthenticodeSignature -FilePath $_filePath
            if($_Signstatus -eq "NotSigned")
            {
			    Write-Host "Signing $file...." -BackgroundColor Green -ForegroundColor White
                #$_SignResult = azuresigntool.exe sign -kvu "https://poh-kv-cicd.vault.azure.net" -kvi "$(sp-ClientID)" -kvt "$(sp-TenantID)" -kvs "$(sp-Secret)" -kvc "scmbuildteamsigncert" -tr "http://timestamp.digicert.com" -td SHA256 -v $_filePath
            }
            else{
			    Write-Host "The DLL $file is already Signed...Skipping Signing" -BackgroundColor Blue -ForegroundColor White
		    }
        }
        else
        {
            Write-Host "$_filePath Does not exits" -BackgroundColor Red -ForegroundColor White
        }
    }
}

Write-Host "Demo.."
#printsign -_FilesToBeSigned "C:\Users\R888066\Desktop\Dustbin\Global_Infra_copy\SQL\DigitalSigning.txt" -_FilesLocation "C:\Users\R888066\Desktop\Dustbin\Global_Infra_copy\SQL"
printsign -_FilesToBeSigned $env:filename -_FilesLocation $env:loc
