#!/usr/bin/env bash

# Master script to set up dot files on new Linux virtual machine

#
DBUG=true  # we are still developing this script :-]
#

# If we are not running under bash, try to exec bash with all parameters
if [ ! "$BASH_VERSION" ] ; then
  exec /usr/bin/env bash "$0" "$@"
fi

#
# Some helper functions:
#
log() {
  printf '%(%F %T)T : ' -1
  echo "$*"
}

die() {
  log "$*"
  exit 3
}


# Determine if this script has already run and exit if we have.

# $DBUG && echo "$(grep -i -c SetUpDotFilesHasRun ~/.bashrc)"  ; exit 0

case "$(grep -i -c SetUpDotFilesHasRun ~/.bashrc)" in
 "0") # it appears we have not yet run 
    SetUpDotFilesHasRun=0 ;;
 *) die "SetUpDotFilesHasRun appears in ~/.bashrc, exiting" ;;
esac

# Configuration Variables
#
MyGitUserName="mitchwyle"
MyGitEmail="mfw@wyle.org"


# Boostrap editor preference and set up passwordles sudo:
SetEditorAndSudo() {
#
  touch ~/.bashrc
  cat >> ~/.bashrc  <<'EOF'
export EDITOR=vi
export VISUAL=vi
EOF
  . ~/.bashrc
  
  # This first sudo command will require a password
  set -x  # show the person what each command is doing / trying to do
  sudo touch ~root/.bashrc
  sudo cat >> ~root/.bashrc <<'EOF'
export EDITOR=vi
export VISUAL=vi
EOF
  
  echo '$USER ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo
  echo '$USER ALL NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
  set +x
}  

# Install git on ubuntu

InstallGitAndGithub() {
  apt-get install git-all
  git config --global user.name "$MyGitUserName"
  git config --global user.email "$MyGitEmail"
  git config --global color.ui true
  git config --global core.editor vi
  ssh-keygen -t rsa -C "MyGitEmail"
  cat ~/.ssh/id_rsa.pub

  echo ""
  echo "Select that RSA key, copy to the clipboard, web in to github, and add to your keys."
}

