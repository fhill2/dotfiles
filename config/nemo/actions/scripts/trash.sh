#!/bin/bash
for item in "$@"
  do
    #notify-send "$item"
    trash-cli $item
  done
