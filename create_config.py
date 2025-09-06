#!/usr/bin/env python3
"""
Example and testing script for Verilog Automation Framework
"""

import json
import os
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
        file_config = {
            "name": vfile,
            "vcd_file": f"{base_name}.vcd",
            "variables": None,  # Plot all variables by default
            "module": "TEST"
        }
        config["files"].append(file_config)

    config_filename = f"{assignment_name}.json"
    with open(config_filename, 'w') as f:
        json.dump(config, f, indent=2)

    print(f"Created configuration file: {config_filename}")
    return config_filename

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

    # Discover assignments
    current_dir = Path.cwd()
    print(f"Current directory: {current_dir}")

    # Look for assignment directories
    assignment_dirs = []
    for item in current_dir.iterdir():
        if item.is_dir() and not item.name.startswith('.'):
            verilog_files = discover_verilog_files(item)
            if verilog_files:
                assignment_dirs.append((item.name, verilog_files))

    if not assignment_dirs:
        print("No assignment directories with Verilog files found.")
        return

    print(f"\nFound {len(assignment_dirs)} assignment directories:")
    for i, (dir_name, files) in enumerate(assignment_dirs, 1):
        print(f"{i}. {dir_name} ({len(files)} Verilog files)")
        for file in files:
            print(f"   - {file}")

    # Create configurations for all assignments
    print(f"\nCreating configuration files...")
    for dir_name, files in assignment_dirs:
        config_file = create_sample_config(dir_name, files)

    print(f"\n✓ Configuration files created!")
    print(f"\nTo run automation for an assignment, use:")
    for dir_name, _ in assignment_dirs:
        print(f"  python verilog_automation.py {dir_name}.json")

if __name__ == '__main__':
    main()
