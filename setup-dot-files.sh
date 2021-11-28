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
# $DBUG && echo "$(grep -i -c SetUpDotFilesHasRun $HOME/.bashrc)"  ; exit 0
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
  BASHRC=${BASHRC-"$HOME/.bashrc"} 
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

  # Verify variables are set (MyGitUsername, MyGitEmail)
  [ -z "$MyGitUserName" ] && die "The variable MyGitUsername is not set."
  [ -z "$MyGitEmail" ] && die "The variable MyGitEmail is not set."

  SshKeyFileName="${SshKeyFileName-'$HOME/ssh/github_rsa'}"  # test version will create keys in /tmp and delete them

  [ $DBUG ] && echo "SshKeyFileName is now: $SshKeyFileName"
  [ $DBUG ] && echo "MyGitUserName = $MyGitUserName"
  [ $DBUG ] && echo "MyGitEmail = $MyGitEmail"

  echo "Installing git commands and their dependencies. . ."
  sudo apt-get install git-all || die "sudo apt-get install git-all failed" # already installed returns 0, cool!
  git config --global user.name "$MyGitUserName"
  git config --global user.email "$MyGitEmail"
  git config --global color.ui true
  git config --global core.editor vi
  ssh-keygen -N "" -t rsa -f "$SshKeyFileName" -C "$MyGitEmail" # -t type of key, -f filename -C email -N pass phrase
  echo "Here is the text of your new ssh key for github:"
  echo ""
  cat $SshKeyFileName".pub"

  echo << 'EOF'

  Select the above text -- your new RSA ssh key -- and copy the text to your clipboard.
  Web in to:  https://github.com/settings/keys/new
  Enter a Title for your new key.
  Paste the text of your new key into the "Key" text box
  Click the "Add SSH key" button and your git / github setup will be complete.

EOF
}


# Install Oh My Bash and use the zork theme

InstallOhMyBash() {
  pushd .
SshKeyFileName  cd "$HOME" || die "Cannot find home directory: $HOME"

  bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
  ed $HOME/.bashrc << 'EOF'
/OSH_THEME=
.t.
s/=.*$/zork
w
q
EOF
  popd || die "Cannot pop directory stack popd failed."
}

