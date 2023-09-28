# Get the list of available updates that haven't been installed
$notInstalledUpdates = Get-WUList -NotInstalled

# Display the list of updates to the user
for ($i = 0; $i -lt $notInstalledUpdates.Count; $i++) {
    Write-Host "$($i+1). $($notInstalledUpdates[$i].Title)"
}

# Prompt the user to select updates to install (similar to your previous code)
$selection = Read-Host "Enter the number(s) of the updates you want to install (comma-separated):"

# Convert user's input to selected indices (similar to your previous code)
$selectedIndices = $selection -split ',' | ForEach-Object { [int]$_ - 1 }

# Install the selected updates (similar to your previous code)
foreach ($index in $selectedIndices) {
    if ($index -ge 0 -and $index -lt $notInstalledUpdates.Count) {
        $updateToInstall = $notInstalledUpdates[$index]
        Write-Host "Installing $($updateToInstall.Title)..."
        if ($matchingUpdate) {
            $kbArticleID = $matchingUpdate.KB
            Write-Host "Found KB Article ID for '$updateToInstallTitle': $kbArticleID"
        } 
        else {
            Write-Host "Update with title '$updateToInstallTitle' not found."
        }
        Install-WindowsUpdate -KBArticleID $kbArticleID
    } else {
        Write-Host "Invalid selection: $($index + 1)"
    }
}



if ($matchingUpdate) {
    $kbArticleID = $matchingUpdate.KB
    Write-Host "Found KB Article ID for '$updateToInstallTitle': $kbArticleID"
} else {
    Write-Host "Update with title '$updateToInstallTitle' not found."
}