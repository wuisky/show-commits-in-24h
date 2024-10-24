#!/bin/bash

BLUE='\033[1;34m'
NC='\033[0m' # No Color

function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/'
}

function search_git_repos {
  local dir="$1"
  local git_dir=".git"
  local repo=()

  # Check if the directory is a Git repository
  if [[ -d "$dir/$git_dir" ]]; then
      echo -e -n "${BLUE}$dir${NC}"
      cd $dir;echo $(parse_git_branch)
      git log --since="24 hours ago"
  fi

  # Recursively search subdirectories
  for sub_dir in "$dir"/*; do
    if [[ -d "$sub_dir" ]]; then
      search_git_repos "$sub_dir"
    fi
  done
}

# Start searching from the current directory
search_git_repos "$1"
