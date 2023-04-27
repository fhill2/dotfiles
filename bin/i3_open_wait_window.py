#!/usr/bin/env python3

from f.i3.window import open_wait_window
import sys

if __name__ == '__main__':
    if len(sys.argv) > 1:
        open_wait_window(sys.argv[1], cli=True)
