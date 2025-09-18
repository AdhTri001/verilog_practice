<#
.SYNOPSIS
  Compiles and simulates Verilog files using iverilog and vvp, with optional waveform viewing in gtkwave.

.DESCRIPTION
  This script automates the process of compiling one or more Verilog source files using iverilog,
  running the resulting simulation with vvp, and optionally opening the generated VCD waveform file
  in gtkwave for visualization.

.PARAMETER Files
  One or more Verilog source files to compile and simulate. This parameter is mandatory.

.PARAMETER Plot
  Switch parameter. If specified, the script will attempt to open the generated VCD file in gtkwave
  after simulation.

.EXAMPLE
  .\ExecuteVerilog.ps1 -Files mytestbench.v -Plot

  Compiles 'mytestbench.v', runs the simulation, and opens the resulting waveform in gtkwave.

.EXAMPLE
  .\ExecuteVerilog.ps1 -Files module1.v,module2.v

  Compiles 'module1.v' and 'module2.v', runs the simulation, but does not open gtkwave.

.NOTES
  - Requires iverilog, vvp, and optionally gtkwave to be installed and available in the system PATH.
  - The script uses the base name of the first file for output file naming.
#>

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