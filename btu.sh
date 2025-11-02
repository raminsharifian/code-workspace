#!/usr/bin/env bash

# Back Them Up! (BTU)
# A simple tool that saves your installed VS Code extensions to a list in exts/list.extensions

mkdir ./exts
code --list-extensions > ./exts/list.extensions