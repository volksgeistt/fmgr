$PathStack = @()
$CurrentDir = Get-Location

function Show-Banner {
    Clear-Host
    Write-Host "- Current Directory: $CurrentDir" -ForegroundColor Cyan
    Write-Host ("-" * 50) -ForegroundColor Gray
}

function Change-Directory {
    $path = Read-Host "Enter directory path: "
    if (Test-Path $path -PathType Container) {
        $PathStack += $CurrentDir
        Set-Location $path
        $Global:CurrentDir = Get-Location
        Write-Host "Changed to: $CurrentDir" -ForegroundColor Green
    } else {
        Write-Host "Invalid path!" -ForegroundColor Red
    }
}

function Go-Back {
    if ($PathStack.Count -gt 0) {
        $prev = $PathStack[-1]
        $PathStack = $PathStack[0..($PathStack.Count - 2)]
        Set-Location $prev
        $Global:CurrentDir = Get-Location
        Write-Host "Back to: $CurrentDir" -ForegroundColor Green
    } else {
        Write-Host "No previous directory!" -ForegroundColor Yellow
    }
}

function Move-File {
    $src = Read-Host "Source path"
    $dst = Read-Host "Destination path"
    if (Test-Path $src) {
        try {
            Move-Item -Path $src -Destination $dst -Force
            Write-Host "Moved successfully!" -ForegroundColor Green
        } catch {
            Write-Host "Move failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Source not found!" -ForegroundColor Red
    }
}

function Copy-File {
    $src = Read-Host "Source path"
    $dst = Read-Host "Destination path"
    if (Test-Path $src) {
        try {
            Copy-Item -Path $src -Destination $dst -Recurse -Force
            Write-Host "Copied successfully!" -ForegroundColor Green
        } catch {
            Write-Host "Copy failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Source not found!" -ForegroundColor Red
    }
}

function Delete-File {
    $target = Read-Host "Path to delete"
    if (Test-Path $target) {
        $confirm = Read-Host "Delete '$target'? (Y/N)"
        if ($confirm -match '^[Yy]') {
            try {
                Remove-Item -Path $target -Recurse -Force
                Write-Host "Deleted successfully!" -ForegroundColor Green
            } catch {
                Write-Host "Delete failed: $_" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Path not found!" -ForegroundColor Red
    }
}

function Rename-File {
    $target = Read-Host "Path to rename"
    if (Test-Path $target) {
        $newName = Read-Host "New name"
        try {
            Rename-Item -Path $target -NewName $newName
            Write-Host "Renamed successfully!" -ForegroundColor Green
        } catch {
            Write-Host "Rename failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "File not found!" -ForegroundColor Red
    }
}

function Create-Directory {
    $folder = Read-Host "Folder name"
    $path = Join-Path $CurrentDir $folder
    if (-not (Test-Path $path)) {
        try {
            New-Item -ItemType Directory -Path $path | Out-Null
            Write-Host "Folder created!" -ForegroundColor Green
        } catch {
            Write-Host "Creation failed: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Folder already exists!" -ForegroundColor Yellow
    }
}

function Show-Menu {
    Show-Banner
    Write-Host "1. Change Directory"
    Write-Host "2. Go Back"
    Write-Host "3. Move File/Folder"
    Write-Host "4. Copy File/Folder"
    Write-Host "5. Delete File/Folder"
    Write-Host "6. Rename File/Folder"
    Write-Host "7. Create Folder"
    Write-Host "8. Exit"
    Write-Host ""
}

do {
    Show-Menu
    $choice = Read-Host "Choose option (1-8)"
    
    switch ($choice) {
        '1'  { Change-Directory }
        '2'  { Go-Back }
        '3'  { Move-File }
        '4'  { Copy-File }
        '5'  { Delete-File }
        '6'  { Rename-File }
        '7'  { Create-Directory }
        '8' { Write-Host "Goodbye!" -ForegroundColor Cyan; break }
        default { Write-Host "Invalid option!" -ForegroundColor Red }
    }
    
    if ($choice -ne '8') {
        Read-Host "`nPress Enter to continue"
    }
} while ($true)
