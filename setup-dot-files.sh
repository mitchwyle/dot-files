#!/usr/bin/env bash

# Master script to set up dot files on new Linux virtual machine

#
DBUG=true  # for script development :-]
#

#
# Load some helper functions:
#
. ./utils.sh

HaveWeRun() {
# Determine if this script has already run and exit if we have.
# $DBUG && echo "$(grep -i -c SetUpDotFilesHasRun ~/.bashrc)"  ; exit 0
  BASHRC=${BASHRC-"~/.bashrc"}
  case "$(grep -i -c SetUpDotFilesHasRun $BASHRC)" in
   "0") # it appears we have not yet run 
      SetUpDotFilesHasRun=0 ;;
   *) die "SetUpDotFilesHasRun appears in ~/.bashrc, exiting" ;;
  esac
}

# Configuration Variables
#
MyGitUserName="mitchwyle"
MyGitEmail="mfw@wyle.org"


# Boostrap editor preference and set up passwordles sudo:
SetEditorForSudo() {
#
# BASHRC test value is pre-set by testing framework; real value is $USER's .bashrc
  BASHRC=${BASHRC-"~/.bashrc"} 
  touch $BASHRC
  cat >> $BASHRC  <<'EOF'
export EDITOR=vi
export VISUAL=vi
EOF
  . $BASHRC
# # More importantly, set these variables for root so that visudo and other commands do not use emacs
# #  ROOTBASHRC=${ROOTBASHRC-"~root/.bashrc"}
# #  sudo touch $ROOTBASHRC # This first sudo command will require a password
# #  sudo cat >> $ROOTBASHRC <<'EOF'
# # export EDITOR=vi
# # export VISUAL=vi
# # EOF
#   

}


# Enable $USER to sudo without a password
NoPasswdSudo() {
  SUDOCMD=${SUDOCMD-"sudo EDITOR='tee -a' visudo"}     # test value for sudo set by tests; real value is sudo
  echo "$USER ALL=(ALL:ALL) ALL" | $SUDOCMD
  echo "$USER ALL=NOPASSWD: ALL" | $SUDOCMD
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

# Install Oh My Bash and use the rana theme

InstallOhMyBash() {
  pushd .
  cd ~/
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  ed ~/.bashrc << 'EOF'
/OSH_THEME=
.t.
s/=.*$/rana
w
q
EOF
  popd
}

