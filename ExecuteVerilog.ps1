param (
  [Parameter(Mandatory = $true)]
  [string[]]$Files,

  [switch]$Plot
)

# Ensure at least one file is provided
if ($Files.Count -eq 0) {
  Write-Error "Please provide at least one Verilog file."
  exit 1
}

# Get the base name of the first file (without extension)
$FirstFile = $Files[0]
$BaseName = [System.IO.Path]::GetFileNameWithoutExtension($FirstFile)

# Step 1: Compile with iverilog
Write-Host ""
Write-Host "Compiling with iverilog..."
$CompileCmd = "iverilog -o ${BaseName}.vvp $Files"
Invoke-Expression $CompileCmd

# Step 2: Run with vvp
if (Test-Path -Path "${BaseName}.vvp") {
  Write-Host ""
  Write-Host "Running simulation with vvp..."
  Write-Host ""
  $RunCmd = "vvp ${BaseName}.vvp"
  Invoke-Expression $RunCmd
}

# Step 3: Open in gtkwave
if ($Plot -and (Test-Path -Path "${BaseName}.vcd")) {
  Write-Host ""
  Write-Host "Opening waveform with gtkwave..."
  $WaveCmd = "gtkwave ${BaseName}.vcd"
  Invoke-Expression $WaveCmd
}