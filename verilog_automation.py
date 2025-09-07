#!/usr/bin/env python3

"""
Verilog Automation Framework
============================

A cross-platform Python framework for automating Verilog compilation,
simulation, and visualization tasks.

Features:
- Compile and simulate Verilog files using iverilog/vvp
- Capture terminal output as screenshots using termshot
- Generate waveform plots from VCD files using vcdvcd and matplotlib
- Configuration via JSON files for easy project management

Author: Adheesh Trivedi
"""

import json
import os
import sys
import subprocess
import platform
from pathlib import Path
from typing import Dict, List, Optional, Union
import argparse
import shutil

try:
    import matplotlib
    matplotlib.use('Agg')  # Use non-interactive backend
    import matplotlib.pyplot as plt
    from matplotlib.figure import Figure
except ImportError:
    print("Error: matplotlib not found. Please install: pip install matplotlib")
    sys.exit(1)

try:
    from vcdvcd import VCDVCD
except ImportError:
    print("Error: vcdvcd not found. Please install: pip install vcdvcd")
    sys.exit(1)


class VerilogAutomation:
    """Main class for Verilog automation framework."""

    def __init__(self, config_file: str, workspace_root: Optional[str] = None):
        """
        Initialize the automation framework.

        Args:
            config_file: Path to JSON configuration file
            workspace_root: Root directory for the workspace (default: current directory)
        """
        self.workspace_root = Path(workspace_root) if workspace_root else Path.cwd()
        self.config_file = Path(config_file)
        self.config = self._load_config()

        # Setup paths
        self.assignment_folder = self.workspace_root / self.config['folder'].lstrip('/')
        self.imgs_folder = self.assignment_folder / 'imgs'

        # Create imgs folder if it doesn't exist
        self.imgs_folder.mkdir(parents=True, exist_ok=True)

        print(f"Workspace root: {self.workspace_root}")
        print(f"Assignment folder: {self.assignment_folder}")
        print(f"Images folder: {self.imgs_folder}")

    def _load_config(self) -> Dict:
        """Load configuration from JSON file."""
        try:
            with open(self.config_file, 'r') as f:
                config = json.load(f)

            # Validate required fields
            if 'folder' not in config:
                raise ValueError("Config must contain 'folder' field")
            if 'files' not in config:
                raise ValueError("Config must contain 'files' field")

            return config
        except FileNotFoundError:
            raise FileNotFoundError(f"Configuration file not found: {self.config_file}")
        except json.JSONDecodeError as e:
            raise ValueError(f"Invalid JSON in configuration file: {e}")

    def _run_command(self, command: List[str], cwd: Optional[Path] = None, capture_output: bool = True) -> subprocess.CompletedProcess:
        """
        Run a shell command with proper error handling.

        Args:
            command: Command as list of strings
            cwd: Working directory
            capture_output: Whether to capture stdout/stderr

        Returns:
            CompletedProcess object
        """
        try:
            if cwd is None:
                cwd = self.assignment_folder

            print(f"Running: {' '.join(command)} (in {cwd})")

            result = subprocess.run(
                command,
                cwd=cwd,
                capture_output=capture_output,
                text=True,
                check=False
            )

            if result.returncode != 0:
                print(f"Command failed with return code {result.returncode}")
                if result.stderr:
                    print(f"Error: {result.stderr}")

            return result
        except FileNotFoundError:
            raise FileNotFoundError(f"Command not found: {command[0]}. Please ensure it's installed and in PATH.")

    def compile_verilog(self, verilog_files: List[str], output_name: str) -> bool:
        """
        Compile Verilog files using iverilog.

        Args:
            verilog_files: List of Verilog source files
            output_name: Output VVP file name (without extension)

        Returns:
            True if compilation successful, False otherwise
        """
        print(f"\n=== Compiling Verilog files ===")

        # Check if iverilog is available
        try:
            subprocess.run(['iverilog', '-V'], capture_output=True, check=True)
        except (FileNotFoundError, subprocess.CalledProcessError):
            print("Error: iverilog not found. Please install Icarus Verilog.")
            return False

        # Verify all input files exist
        for vfile in verilog_files:
            file_path = self.assignment_folder / vfile
            if not file_path.exists():
                print(f"Error: Verilog file not found: {file_path}")
                return False

        # Compile
        vvp_file = f"{output_name}.vvp"
        command = ['iverilog', '-o', vvp_file] + verilog_files
        result = self._run_command(command)

        if result.returncode == 0:
            print(f"✓ Compilation successful: {vvp_file}")
            return True
        else:
            print(f"✗ Compilation failed")
            return False

    def simulate_verilog(self, vvp_file: str) -> bool:
        """
        Simulate Verilog using vvp.

        Args:
            vvp_file: VVP file to simulate

        Returns:
            True if simulation successful, False otherwise
        """
        print(f"\n=== Running simulation ===")

        # Check if vvp is available
        try:
            subprocess.run(['vvp', '-V'], capture_output=True, check=True)
        except (FileNotFoundError, subprocess.CalledProcessError):
            print("Error: vvp not found. Please install Icarus Verilog.")
            return False

        vvp_path = self.assignment_folder / vvp_file
        if not vvp_path.exists():
            print(f"Error: VVP file not found: {vvp_path}")
            return False

        # Run simulation
        command = ['vvp', vvp_file]
        result = self._run_command(command, capture_output=False)

        if result.returncode == 0:
            print(f"✓ Simulation completed successfully")
            return True
        else:
            print(f"✗ Simulation failed")
            return False

    def capture_terminal_output(self, vvp_file: str, output_image: str) -> bool:
        """
        Capture terminal output using termshot executable.

        Args:
            vvp_file: VVP file to run
            output_image: Output image file name

        Returns:
            True if capture successful, False otherwise
        """
        print(f"\n=== Capturing terminal output ===")

        # Check if termshot executable is available
        termshot_cmd = 'termshot'
        if platform.system() == 'Windows':
            # On Windows, check for termshot.exe
            termshot_cmd = 'termshot.exe'

        if not shutil.which(termshot_cmd):
            print(f"Warning: {termshot_cmd} not found in PATH.")
            print("Please install termshot from: https://github.com/homeport/termshot")
            print("Skipping terminal screenshot capture.")
            return False

        vvp_path = self.assignment_folder / vvp_file
        if not vvp_path.exists():
            print(f"Error: VVP file not found: {vvp_path}")
            return False

        output_path = self.imgs_folder / output_image

        # Change to assignment folder for proper paths
        original_cwd = os.getcwd()
        try:
            os.chdir(self.assignment_folder)

            # Use termshot to capture terminal output
            # Run vvp command and capture its output as a screenshot
            command = [termshot_cmd, '--filename', str(output_path), '-c', '--', 'vvp', vvp_file]

            result = self._run_command(command)
            if result.returncode == 0:
                print(f"✓ Terminal output captured: {output_path}")
                return True
            else:
                print(f"✗ Failed to capture terminal output")
                print(f"Command output: {result.stderr}")
                return False

        except Exception as e:
            print(f"Error with termshot: {e}")
            print("Continuing without terminal screenshot...")
            return False
        finally:
            os.chdir(original_cwd)

    def plot_vcd(self, vcd_file: str, variables: Optional[List[str]] = None,
                 module: str = "TEST", output_image: str = "waveform.png") -> bool:
        """
        Generate waveform plots from VCD file using vcdvcd and matplotlib.

        Args:
            vcd_file: VCD file to plot
            variables: List of variables to plot (None for all)
            module: Module name to extract signals from
            output_image: Output image file name

        Returns:
            True if plotting successful, False otherwise
        """
        print(f"\n=== Generating waveform plots ===")

        vcd_path = self.assignment_folder / vcd_file
        if not vcd_path.exists():
            print(f"Error: VCD file not found: {vcd_path}")
            return False

        try:
            # Load VCD file
            vcd = VCDVCD(str(vcd_path))

            # Get all signals for the specified module
            module_signals = {}

            # vcd.signals is a list of signal names
            # vcd.data contains the actual time-value data keyed by signal identifiers
            # We need to map signal names to their data

            for signal_name in vcd.signals:
                if signal_name.startswith(f"{module}.") or module == "TEST":
                    clean_name = signal_name.replace(f"{module}.", "") if signal_name.startswith(f"{module}.") else signal_name
                    if '.' in clean_name:
                        continue  # Skip hierarchical signals
                    if variables is None or clean_name in variables:
                        # Find the signal identifier for this signal name
                        if signal_name in vcd.references_to_ids:
                            signal_id = vcd.references_to_ids[signal_name]
                            if signal_id in vcd.data:
                                module_signals[clean_name] = vcd.data[signal_id]

            if not module_signals:
                print(f"Warning: No signals found for module '{module}' in VCD file")
                print(f"Available signals: {vcd.signals}")
                return False

            # Create subplot for each signal with GTKWave-like styling
            num_signals = len(module_signals)

            # Set up GTKWave-like dark theme
            plt.style.use('dark_background')
            fig, axes = plt.subplots(num_signals, 1, figsize=(12, .8 * num_signals),
                                   sharex=True, squeeze=False)
            fig.patch.set_facecolor('#BBBBBB')  # Greyish white background outside plot area

            # axes is always a 2D array when squeeze=False, so we need to access [i, 0]
            # Plot each signal
            for i, (signal_name, signal_data) in enumerate(module_signals.items()):
                ax = axes[i, 0]  # Access the axes correctly for squeeze=False

                # Extract time and value data from Signal object
                times = []
                values = []
                values_str = []

                # signal_data is a Signal object with .tv attribute containing [(time, value), ...]
                for timestamp, value in signal_data.tv:
                    times.append(timestamp // 1000)  # Convert to picoseconds
                    # Convert value to int if possible, otherwise keep as string
                    try:
                        if isinstance(value, str):
                            values.append(int(value, 2))
                        else:
                            values.append(int(value))
                    except (ValueError, TypeError):
                        values.append(0)
                    # Format value as binary string for annotation
                    # if len(value) % 4 == 0:
                    #     values_str.append(f"0x{int(value, 2):X}")
                    # else:
                    values_str.append("0b"+value)

                times.append(signal_data.endtime // 1000)  # End time in picoseconds
                values.append(values[-1] if values else 0)

                # GTKWave-like styling
                ax.set_facecolor('#000000')  # Black background

                # Plot as step function for digital signals with green color
                if times and values:
                    ax.step(times, values, where='post', linewidth=2, color='#00FF00')  # Green traces

                    # Add value annotations on the plot - centered vertically
                    max_val = max(values) if values else 1
                    center_y = max_val / 2  # Vertical center of the plot

                    for j, (time, value, value_str) in enumerate(zip(times[:-1], values[:-1], values_str)):
                        if j < len(times) - 1:  # Don't annotate the last extended point
                            # Position text at the middle of each time segment
                            next_time = times[j + 1] if j + 1 < len(times) else time + 1000
                            text_x = time

                            # Add text annotation at vertical center.
                            ax.text(text_x, center_y, value_str,
                                color='#FFFFFF', fontsize=10,
                                fontfamily=['Adwaita Mono'],
                                ha='left', va='center')

                    # Signal name label on the left
                    ax.set_ylabel(signal_name, rotation=0, ha='right', va='center',
                                color='black', fontsize=10, fontweight='bold')

                    # Remove y-axis ticks and labels
                    ax.set_yticks([])
                    ax.tick_params(left=False)

                    # Grid styling - both horizontal and vertical lines
                    ax.grid(True, alpha=0.3, color='#0080FF', linewidth=0.5)
                    ax.grid(True, axis='x', alpha=0.4, color='#0080FF', linewidth=0.5)
                    ax.grid(True, axis='y', alpha=0.2, color='#0080FF', linewidth=0.3)

                    # Set proper y-limits for digital signals
                    max_val = max(values) if values else 1
                    ax.set_ylim(-0.2, max_val + 0.2)

                    # Remove top and right spines, keep bottom for x-axis only on last subplot
                    ax.spines['top'].set_visible(False)
                    ax.spines['right'].set_visible(False)
                    ax.spines['left'].set_visible(False)

                    # Show x-axis only on the last subplot
                    if i == num_signals - 1:
                        ax.spines['bottom'].set_visible(True)
                        ax.spines['bottom'].set_color('black')
                        ax.spines['bottom'].set_linewidth(1)

                        # X-axis styling - show ticks only on last subplot with black color
                        ax.tick_params(axis='x', colors='black', labelsize=8)

                        # Show minor x-ticks for better time resolution
                        ax.minorticks_on()
                        ax.tick_params(axis='x', which='minor', colors='black', length=2)
                    else:
                        # Hide x-axis for all other subplots
                        ax.spines['bottom'].set_visible(False)
                        ax.tick_params(axis='x', which='both', bottom=False, labelbottom=False)

            # Set common x-axis label on the last (bottom) subplot
            axes[-1, 0].set_xlabel('Time (ps)', color='black', fontweight='bold')

            # Title styling - change text color to black
            plt.suptitle(f'Waveform Plot - {vcd_file}', fontsize=14, fontweight='bold', color='black')
            plt.tight_layout(h_pad=0)  # Set vertical gap to 0

            # Save plot
            output_path = self.imgs_folder / output_image
            plt.savefig(output_path, dpi=300, bbox_inches='tight')
            plt.close()

            print(f"✓ Waveform plot saved: {output_path}")
            return True

        except Exception as e:
            print(f"Error plotting VCD file: {e}")
            return False

    def process_file(self, file_config: Dict) -> bool:
        """
        Process a single file configuration.

        Args:
            file_config: File configuration dictionary

        Returns:
            True if processing successful, False otherwise
        """
        if 'name' not in file_config:
            print("Error: File configuration missing 'name' field")
            return False

        file_name = file_config['name']
        base_name = Path(file_name).stem

        print(f"\n{'='*60}")
        print(f"Processing file: {file_name}")
        print(f"{'='*60}")

        # Get VCD file name (default to base_name.vcd)
        vcd_file = file_config.get('vcd_file', f"{base_name}.vcd")

        # Get variables to plot (default to None for all variables)
        variables = file_config.get('variables', None)

        # Get module name (default to TEST)
        module = file_config.get('module', 'TEST')

        # Check if plotting is enabled (default to True)
        plot_enabled = file_config.get('plot', True)

        # Compile Verilog
        if not self.compile_verilog([file_name], base_name):
            return False

        # Simulate
        vvp_file = f"{base_name}.vvp"
        if not self.simulate_verilog(vvp_file):
            return False

        # Capture terminal output
        terminal_image = f"{base_name}_terminal.png"
        self.capture_terminal_output(vvp_file, terminal_image)

        # Generate waveform plot
        waveform_image = f"{base_name}_waveform.png"
        if plot_enabled:
            if not self.plot_vcd(vcd_file, variables, module, waveform_image):
                print(f"Warning: Could not generate waveform plot for {vcd_file}")
        else:
            print(f"Skipping waveform plot for {file_name} (plot disabled in config)")

        print(f"✓ Completed processing {file_name}")
        return True

    def run(self) -> bool:
        """
        Run the complete automation process for all files in the configuration.

        Returns:
            True if all files processed successfully, False otherwise
        """
        print(f"Starting Verilog automation for: {self.config_file}")
        print(f"Assignment folder: {self.assignment_folder}")

        success_count = 0
        total_files = len(self.config['files'])

        for file_config in self.config['files']:
            try:
                if self.process_file(file_config):
                    success_count += 1
            except Exception as e:
                print(f"Error processing file: {e}")

        print(f"\n{'='*60}")
        print(f"SUMMARY")
        print(f"{'='*60}")
        print(f"Successfully processed: {success_count}/{total_files} files")
        print(f"Output directory: {self.imgs_folder}")

        return success_count == total_files


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(description='Verilog Automation Framework')
    parser.add_argument('config', help='JSON configuration file')
    parser.add_argument('--workspace', '-w', help='Workspace root directory (default: current directory)')
    parser.add_argument('--verbose', '-v', action='store_true', help='Enable verbose output')

    args = parser.parse_args()

    try:
        automation = VerilogAutomation(args.config, args.workspace)
        success = automation.run()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)


if __name__ == '__main__':
    main()
