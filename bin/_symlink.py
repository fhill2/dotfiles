#!/usr/bin/env python
import sys, os, errno


def do_symlink(source, destination):
    """Creates a symlink from the source file to the destination file.

    Args:
      source: The path to the source file.
      destination: The path to the destination file.

    Raises:
      FileNotFoundError: If the source file does not exist.
      OSError: If the symlink could not be created.

    """

    # Check if the source file exists.
    if not os.path.exists(source):
        raise FileNotFoundError(f"Source file '{source}' does not exist.")

    # Check if the destination file exists.
    if os.path.exists(destination):
        # Get the path to the original file.
        original_file = os.readlink(destination)

        # Check if the original file exists.
        if not os.path.exists(original_file):
            # If the original file does not exist, prompt the user if they want to delete the symlink.
            print(
                f"Destination file '{destination}' original file: '{original_file}' - does not exist. Do you want to delete '{destination}'?"
            )
            response = input("(y/N) ")

            # Delete the symlink if the user said yes.
            if response.lower() == "y":
                os.remove(destination)

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