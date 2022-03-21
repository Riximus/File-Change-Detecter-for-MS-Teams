###########################
# Author: Riximus
# Date: 21.03.2022
############################
# Description:
# In a defined MS Teams-Channel it will output a message if a file changed.
# To work properly you need to synchronise the MS Teams-Channel Folder
# to have access to the files.
############################

function ChangeSayer {
    # Deklarierungen
    $dir_path = $null # Directory Path of the synchronized path
    $uri_path = $null # Webhook Path
    $max_seconds = -30 # Timeframe window of how old the change should be
    $sleep_seconds = 30

    Write-Output "Script started :)"
    while ($true) {
        $currentTime = Get-Date
        # Filtering of the files
        $pathFiles = Get-ChildItem -Path $dir_path -Recurse -File -Exclude *.tmp | Where-Object { $_.LastWriteTime -ge $currentTime.AddSeconds($max_seconds) }

        foreach ($file in $pathFiles) {
            # MS Teams-Channel message
            $message = "A file got recently modified named **$($file.Name)** in folder **$($file.Directory.Name)** at **$($file.LastWriteTime)**"

            # Console debugging
            Write-Output $currentTime
            Write-Output "Changed file" 
            Write-Output "------------" $file.Name

            # MS Teams message output
            Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body "{'text': '$message'}" -Uri $uri_path
        }
        Start-Sleep -Seconds $sleep_seconds
    }
}
