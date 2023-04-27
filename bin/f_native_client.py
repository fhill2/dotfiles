#!/usr/bin/env python3
import sys
from f.native_client import send_message
if __name__ == '__main__':
    args = list(sys.argv[1:])
    send_message(*args)
