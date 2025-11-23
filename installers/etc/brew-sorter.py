#!/usr/bin/env python3
"""
Brew file array sorter - sorts FORMULAE and CASKS arrays in bash brew installer files.
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple, Optional


def parse_array(
    content: str, array_name: str
) -> Tuple[Optional[List[str]], Optional[int], Optional[int]]:
    """
    Parse an array from bash file content.
    Returns: (items, start_pos, end_pos) or (None, None, None) if not found
    """
    # Match array definition with multiline content
    pattern = rf"{array_name}=\s*\((.*?)\)"
    match = re.search(pattern, content, re.DOTALL)

    if not match:
        return None, None, None

    array_content = match.group(1)
    start_pos = match.start()
    end_pos = match.end()

    # Extract quoted items
    items = re.findall(r'["\']([^"\']+)["\']', array_content)

    return items, start_pos, end_pos


def format_array(array_name: str, items: List[str], indent: str = "  ") -> str:
    """Format items as a bash array."""
    if not items:
        return f"{array_name}=()"

    formatted_items = "\n".join(f'{indent}"{item}"' for item in items)
    return f"{array_name}=(\n{formatted_items}\n)"


def sort_arrays_in_file(
    filepath: Path, dry_run: bool = False
) -> Tuple[bool, List[str]]:
    """
    Sort FORMULAE and CASKS arrays in a file.
    Returns: (has_changes, change_messages)
    """
    try:
        with open(filepath, "r") as f:
            content = f.read()
    except Exception as e:
        return False, [f"Error reading file: {e}"]

    original_content = content
    changes = []

    # Process FORMULAE array
    formulae, f_start, f_end = parse_array(content, "FORMULAE")
    if formulae is not None:
        # Remove duplicates and sort
        original_formulae = formulae.copy()
        sorted_formulae = sorted(set(formulae))

        if original_formulae != sorted_formulae:
            # Calculate changes
            removed_dupes = len(original_formulae) - len(sorted_formulae)
            if removed_dupes > 0:
                changes.append(
                    f"  FORMULAE: removed {removed_dupes} duplicate(s), sorted {len(sorted_formulae)} items"
                )
            else:
                changes.append(f"  FORMULAE: sorted {len(sorted_formulae)} items")

            # Replace in content
            new_array = format_array("FORMULAE", sorted_formulae)
            content = content[:f_start] + new_array + content[f_end:]

    # Process CASKS array (adjust positions if FORMULAE was modified)
    casks, c_start, c_end = parse_array(content, "CASKS")
    if casks is not None:
        original_casks = casks.copy()
        sorted_casks = sorted(set(casks))

        if original_casks != sorted_casks:
            removed_dupes = len(original_casks) - len(sorted_casks)
            if removed_dupes > 0:
                changes.append(
                    f"  CASKS: removed {removed_dupes} duplicate(s), sorted {len(sorted_casks)} items"
                )
            else:
                changes.append(f"  CASKS: sorted {len(sorted_casks)} items")

            # Replace in content
            new_array = format_array("CASKS", sorted_casks)
            content = content[:c_start] + new_array + content[c_end:]

    # Write changes if any
    has_changes = content != original_content
    if has_changes and not dry_run:
        try:
            with open(filepath, "w") as f:
                f.write(content)
        except Exception as e:
            return False, [f"Error writing file: {e}"]

    return has_changes, changes


def process_files(
    file_paths: List[Path], dry_run: bool = False, verbose: bool = False
) -> None:
    """Process multiple files and display results."""
    total_files = 0
    modified_files = 0

    if verbose:
        print(f"Processing {len(file_paths)} file(s)...")
        print("=" * 60)

    for filepath in file_paths:
        if not filepath.is_file():
            if verbose:
                print(f"Skipping {filepath}: not a file")
            continue

        total_files += 1
        has_changes, changes = sort_arrays_in_file(filepath, dry_run)

        if has_changes:
            modified_files += 1
            if verbose:
                print(f"{filepath.name}")
                for change in changes:
                    print(change)
        else:
            if verbose:
                print(f"{filepath.name}")
                print("  No changes needed")

    if verbose:
        print(f"\n{'=' * 60}")
    print(f"Processed {total_files} file(s), modified {modified_files} file(s)")
    if dry_run:
        print("(dry-run mode - no files were actually modified)")


def main():
    """Main entry point."""
    import argparse

    parser = argparse.ArgumentParser(
        description="Sort FORMULAE and CASKS arrays in brew installer files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s file1.sh file2.sh           # Sort specific files
  %(prog)s                             # Sort all files in $MACHFILES_DIR/installers/brew
  %(prog)s --dry-run                   # Preview changes without modifying files
  %(prog)s --verbose                   # Show detailed output for each file
  %(prog)s -v -n                       # Verbose dry-run mode
  %(prog)s --directory /path/to/dir    # Sort all files in specified directory
        """,
    )

    parser.add_argument(
        "files",
        nargs="*",
        help="Bash files to process (if none provided, uses $MACHFILES_DIR/installers/brew)",
    )

    parser.add_argument(
        "-d", "--directory", type=Path, help="Directory to process all files in"
    )

    parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help="Preview changes without modifying files",
    )

    parser.add_argument(
        "-v",
        "--verbose",
        action="store_true",
        help="Show detailed output for each file",
    )

    args = parser.parse_args()

    # Determine which files to process
    file_paths = []

    if args.directory:
        # Process all files in specified directory
        if not args.directory.is_dir():
            print(f"Error: {args.directory} is not a directory", file=sys.stderr)
            sys.exit(1)
        file_paths = sorted(args.directory.glob("*"))
    elif args.files:
        # Process specified files
        file_paths = [Path(f) for f in args.files]
    else:
        # Default: use $MACHFILES_DIR/installers/brew
        machfiles_dir = os.environ.get("MACHFILES_DIR")
        if not machfiles_dir:
            print("Error: $MACHFILES_DIR environment variable not set", file=sys.stderr)
            print("Please either:", file=sys.stderr)
            print("  - Set $MACHFILES_DIR environment variable", file=sys.stderr)
            print("  - Specify files as arguments", file=sys.stderr)
            print("  - Use --directory option", file=sys.stderr)
            sys.exit(1)

        brew_dir = Path(machfiles_dir) / "installers" / "brew"
        if not brew_dir.is_dir():
            print(f"Error: {brew_dir} is not a directory", file=sys.stderr)
            sys.exit(1)

        file_paths = sorted(brew_dir.glob("*"))

    if not file_paths:
        print("No files to process", file=sys.stderr)
        sys.exit(1)

    # Filter to only regular files
    file_paths = [f for f in file_paths if f.is_file()]

    if not file_paths:
        print("No regular files found to process", file=sys.stderr)
        sys.exit(1)

    process_files(file_paths, dry_run=args.dry_run, verbose=args.verbose)


if __name__ == "__main__":
    main()
