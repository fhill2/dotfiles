#!/usr/bin/env python
import sys, os, errno
from pathlib import Path


def do_symlink(source, destination):
    """Creates a symlink from the source file to the destination file.

    Args:
      source: The path to the source file.
      destination: The path to the destination file.

    Raises:
      FileNotFoundError: If the source file does not exist.
      OSError: If the symlink could not be created.

    """
    source = Path(source)
    destination = Path(destination)

    # Check if the source file exists.
    if not source.exists():
        print(f"Source file '{source}' does not exist.")
        return
    if destination.is_file():
        print(f"Destination file '{destination}' exists and is a file.")
        return
    if destination.is_symlink():
        # Check if the original file exists.
        if not destination.resolve().exists():
            # If the original file does not exist, prompt the user if they want to delete the symlink.
            print(
                f"Destination file '{destination}' symlink is broken - original file does not exist: '{original_file}' - does not exist. Do you want to delete '{destination}'?"
            )
            response = input("(y/N) ")

            # Delete the symlink if the user said yes.
            if response.lower() == "y":
                os.remove(destination)
        return

    # Create the symlink.
    try:
        os.symlink(source, destination)
    except OSError as e:
        if e.errno == errno.EACCES:
            # The symlink already exists, prompt the user if they want to create it as sudo.
            print(
                f"Symlink '{destination}' already exists. Do you want to create it as sudo?"
            )
            response = input("(y/N) ")

            # Create the symlink as sudo if the user said yes.
            if response.lower() == "y":
                subprocess.run(["sudo", "ln", "-s", source, destination])
        else:
            raise
    finally:
        print(f"Created Symlink: {source} -> {destination}")


if __name__ == "__main__":
    do_symlink(sys.argv[1], sys.argv[2])
