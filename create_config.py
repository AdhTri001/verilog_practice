#!/usr/bin/env python3
"""
Example and testing script for Verilog Automation Framework
"""

import json
import os
import sys
from pathlib import Path

def create_sample_config(assignment_name: str, verilog_files: list) -> str:
    """
    Create a sample configuration file for an assignment.

    Args:
        assignment_name: Name of the assignment folder
        verilog_files: List of Verilog files to process

    Returns:
        Path to the created configuration file
    """
    config = {
        "folder": assignment_name,
        "files": []
    }

    for vfile in verilog_files:
        base_name = Path(vfile).stem
        vfile_path = Path(assignment_name) / vfile
        plot_enabled = True
        try:
            with open(vfile_path, 'r') as vf:
                content = vf.read()
                if "$dumpfile" not in content:
                    plot_enabled = False
        except Exception as e:
            print(f"Warning: Could not read {vfile_path}: {e}")
            plot_enabled = False

        file_config = {
            "name": vfile,
            "vcd_file": f"{base_name}.vcd",
            "variables": None,  # Plot all variables by default
            "module": "TEST",
            "plot": plot_enabled
        }
        config["files"].append(file_config)

    # Ensure config directory exists
    config_dir = Path('config')
    config_dir.mkdir(exist_ok=True)

    config_filename = config_dir / f"{assignment_name}.json"
    with open(config_filename, 'w') as f:
        json.dump(config, f, indent=2)

    print(f"Created configuration file: {config_filename}")
    return str(config_filename)

def discover_verilog_files(directory: str) -> list:
    """
    Discover all Verilog files in a directory.

    Args:
        directory: Directory to search

    Returns:
        List of Verilog file names
    """
    directory_path = Path(directory)
    if not directory_path.exists():
        print(f"Directory not found: {directory}")
        return []

    verilog_files = []
    for file_path in directory_path.glob("*.v"):
        verilog_files.append(file_path.name)

    return sorted(verilog_files)

def main():
    """Main function for creating sample configurations."""
    print("Verilog Automation Framework - Configuration Generator")
    print("=" * 60)

    # Check command line arguments
    if len(sys.argv) != 2:
        print("Usage: python create_config.py <assignment_folder>")
        print("Example: python create_config.py Asg1")
        return

    assignment_folder = sys.argv[1]
    assignment_path = Path(assignment_folder)

    # Check if the specified folder exists
    if not assignment_path.exists():
        print(f"Error: Directory '{assignment_folder}' not found.")
        return

    if not assignment_path.is_dir():
        print(f"Error: '{assignment_folder}' is not a directory.")
        return

    # Discover Verilog files in the specified directory
    verilog_files = discover_verilog_files(assignment_folder)

    if not verilog_files:
        print(f"No Verilog files found in directory '{assignment_folder}'.")
        return

    print(f"Found {len(verilog_files)} Verilog files in '{assignment_folder}':")
    for file in verilog_files:
        print(f"   - {file}")

    # Create configuration for the specified assignment
    print(f"\nCreating configuration file for '{assignment_folder}'...")
    config_file = create_sample_config(assignment_folder, verilog_files)

    print(f"\n✓ Configuration file created: {config_file}")
    print(f"\nTo run automation for this assignment, use:")
    print(f"  python verilog_automation.py {config_file}")

if __name__ == '__main__':
    main()
