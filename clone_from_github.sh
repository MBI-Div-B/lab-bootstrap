#!/bin/bash

showhelp()
{
  printf "Usage: $(basename $0) [-m]\n \
clones all pytango repositories of MBI-Div-B github account to current folder.
\t-m\tmirror repository\n "\
>&2
}


MIRROR=false

if [ "$1" = "-h" ]; then
  showhelp;
  exit 2
fi

if [ "$1" = "-m" ]; then
  MIRROR=true;
  shift 1;
fi

# Modified version of https://gist.github.com/caniszczyk/3856584#gistcomment-3157288

CLONE_REPO="pytango"
CLONED_REPO_COUNT=0
IGNORED_REPO_COUNT=0

ORG="MBI-Div-B"

# per_page maxes out at 100
PER_PAGE=100

# REPO_TYPE="private"
# TOKEN="TODO"

TEST_RUN=false


for ((PAGE=1; ; PAGE+=1)); do
  # Page 0 and 1 are the same
  # Change authorization method as needed
  # INPUT=$(curl -H "Authorization: token $TOKEN" -s "https://api.github.com/orgs/$ORG/repos?type=$REPO_TYPE&per_page=$PER_PAGE&page=$PAGE" | jq -r ".[].clone_url")
  INPUT=$(curl -s "https://api.github.com/orgs/$ORG/repos?per_page=$PER_PAGE&page=$PAGE" | jq -r ".[].clone_url")
  if [[ -z "$INPUT" ]]; then
    echo "All repos processed, cloned $CLONED_REPO_COUNT repo(s), ignored $IGNORED_REPO_COUNT repo(s) and stopped at page=$PAGE"
    if ! $MIRROR; then
      mkdir bin
      # Now link all stuff to bin
      for dsfolder in $(find . -mindepth 1 -maxdepth 1 -type d \( -name "pytango*" \) ) ; 
                                        # you can add pattern insted of * , here it goes to any folder 
                                        #-mindepth / maxdepth 1 means one folder depth   
      do
      ds=${dsfolder#"./pytango-"}
      ln -s "../"${dsfolder#"./"}/${ds}".py" bin/$ds
      done
    fi

    exit
  fi
  while read REPO_URL ; do
    if [[ "$REPO_URL" =~ $CLONE_REPO ]]; then
      if $TEST_RUN; then
        echo "git clone $REPO_URL"
      else
        #git clone "$REPO_URL" >/dev/null 2>&1 ||   # Pipe stdout and stderr to /dev/null
        #git clone --depth 1 "$REPO_URL" ||         # Shallow clone for faster cloning, within the repo use the following to get the full git history: git pull --unshallow
        if $MIRROR; then
            git clone --mirror $REPO_URL ||                    # Vanilla
              { echo "ERROR: Unable to clone $REPO_URL!" ; continue ; }
        else
            git clone $REPO_URL ||                    # Vanilla
              { echo "ERROR: Unable to clone $REPO_URL!" ; continue ; }
        fi
      fi
      CLONED_REPO_COUNT=$((CLONED_REPO_COUNT+1))
    else
      echo "*** IGNORING $REPO_URL"
      IGNORED_REPO_COUNT=$((IGNORED_REPO_COUNT+1))
    fi
# This syntax works as well /shrug
#  done <<< "$INPUT"
  done < <(echo "$INPUT")
done
