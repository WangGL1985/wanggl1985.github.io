#!/usr/bin/env bash


git add --all
read -rp "Please input commit message: " cmsg
git commit -a -m "${cmsg}"
