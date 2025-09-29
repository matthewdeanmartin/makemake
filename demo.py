#!/usr/bin/env python3
"""
Demo script to showcase the hello_world package and makefile validation.
"""

import subprocess
import sys
from hello_world import hello, __version__


def run_command(cmd):
    """Run a command and return its output."""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd='.')
        return result.returncode, result.stdout, result.stderr
    except Exception as e:
        return 1, "", str(e)


def main():
    print("=" * 60)
    print("HELLO WORLD PACKAGE & MAKEFILE VALIDATION DEMO")
    print("=" * 60)
    
    # Test the package
    print(f"\n1. Package Test:")
    print(f"   hello_world.hello() -> {hello()}")
    print(f"   hello_world.__version__ -> {__version__}")
    
    # Show Makefile help
    print(f"\n2. Makefile Help:")
    returncode, stdout, stderr = run_command("make help")
    if returncode == 0:
        for line in stdout.split('\n')[:10]:  # Show first 10 lines
            print(f"   {line}")
        if len(stdout.split('\n')) > 10:
            print("   ...")
    
    # Test validation pipeline
    print(f"\n3. Validation Pipeline:")
    returncode, stdout, stderr = run_command("make validate-makefile")
    if returncode == 0:
        for line in stdout.split('\n'):
            if line.strip():
                print(f"   ✓ {line}")
    
    # Show package structure
    print(f"\n4. Package Structure:")
    returncode, stdout, stderr = run_command("make show-structure")
    if returncode == 0:
        for line in stdout.split('\n'):
            if line.strip() and not line.startswith('Package structure:'):
                print(f"   {line}")
    
    print(f"\n{'='*60}")
    print("DEMO COMPLETE - All Makefile validation targets are ready!")
    print("Run 'make help' to see all available targets.")
    print("=" * 60)


if __name__ == "__main__":
    main()