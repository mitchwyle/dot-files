#!/usr/bin/env bash

# Master script to set up dot files on new Linux virtual machine

#
DBUG=true  # for script development :-]
$DBUG && export x=x
#

#
# Load some helper functions:
#
# shellcheck source=/dev/null
source ./utils.sh

HaveWeRun() {
# Determine if this script has already run and exit if we have.
# $DBUG && echo "$(grep -i -c SetUpDotFilesHasRun ~/.bashrc)"  ; exit 0
  BASHRC=${BASHRC-"$HOME"}
  case "$(grep -i -c SetUpDotFilesHasRun "$BASHRC")" in
   "0") # it appears we have not yet run 
     ;;
   *) die "SetUpDotFilesHasRun appears in $HOME/.bashrc, exiting" ;;
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
  touch "$BASHRC"
  cat >> "$BASHRC"  <<'EOF'
export EDITOR=vi
export VISUAL=vi
EOF
# shellcheck source=/dev/null
  source "$BASHRC"
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
  $(id $USER>&/dev/null) || die "The account $USER does not exist."
  SUDOCMD=${SUDOCMD-"sudo EDITOR='tee -a' visudo"}     # inject sudo command dependency
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
  echo "Select the above text -- your new RSA key, copy the text to the clipboard, web in to github, and add to your key."
}

# Install Oh My Bash and use the rana theme

InstallOhMyBash() {
  pushd .
  cd "$HOME" || die "Cannot find home directory: $HOME"

  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  ed ~/.bashrc << 'EOF'
/OSH_THEME=
.t.
s/=.*$/rana
w
q
EOF
  popd || die "Cannot pop directory stack popd failed."
}

