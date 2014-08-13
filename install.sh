#!/bin/bash
for d in $(pwd)/*; do
  if [ -d $d ]; then
    stow -t $HOME -R $(basename $d)
  fi
done
