param (
    [Parameter(Mandatory = $true)]
    [string]$Assignment
)

# Validate assignment folder exists
$AssignmentFolder = $Assignment
if (-not (Test-Path -Path $AssignmentFolder -PathType Container)) {
    Write-Error "Assignment folder '$AssignmentFolder' not found."
    exit 1
}

# Check for PDF files in assignment folder
$PdfFiles = Get-ChildItem -Path $AssignmentFolder -Filter "*.pdf" -File
if ($PdfFiles.Count -eq 0) {
    Write-Warning "No PDF files found in '$AssignmentFolder' folder. Continuing without them..."
}

# Get all .v files from assignment folder
$VerilogFiles = Get-ChildItem -Path $AssignmentFolder -Filter "*.v" -File
if ($VerilogFiles.Count -eq 0) {
    Write-Error "No .v files found in '$AssignmentFolder' folder."
    exit 1
}

# Create output zip filename
$ZipFile = "${Assignment}_submission.zip"

# Remove existing zip if it exists
if (Test-Path -Path $ZipFile) {
    Write-Host "Removing existing '$ZipFile'..."
    Remove-Item -Path $ZipFile -Force
}

# Build 7z command
$FilesToZip = @()
$FilesToZip += $VerilogFiles | ForEach-Object { $_.FullName }
if ($PdfFiles.Count -gt 0) {
    $FilesToZip += $PdfFiles | ForEach-Object { $_.FullName }
}

Write-Host ""
Write-Host "Creating '$ZipFile' with:"
$VerilogFiles | ForEach-Object { Write-Host "  - $($_.Name)" }
if ($PdfFiles.Count -gt 0) {
    $PdfFiles | ForEach-Object { Write-Host "  - $($_.Name)" }
}

# Run 7z command
$7zCmd = "7z a `"$ZipFile`" " + ($FilesToZip | ForEach-Object { "`"$_`"" }) -join " "
try {
    Invoke-Expression $7zCmd
    Write-Host ""
    Write-Host "Successfully created '$ZipFile'" -ForegroundColor Green

    # Show file size
    $ZipInfo = Get-Item $ZipFile
    $SizeKB = [math]::Round($ZipInfo.Length / 1KB, 1)
    Write-Host "  Size: $SizeKB KB" -ForegroundColor Gray

    # List contents of the zip file
    Write-Host ""
    Write-Host "Contents of '$ZipFile':" -ForegroundColor Cyan
    $ListCmd = "7z l `"$ZipFile`""
    Invoke-Expression $ListCmd
}
catch {
    Write-Error "Failed to create zip file: $($_.Exception.Message)"
    exit 1
}