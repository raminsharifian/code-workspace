#!/usr/bin/env bash

# A CLI Tool for Optimally Installing a Reserved VSCode Extension List
cat ./exts/list.extensions | xargs -L 1 code --install-extension