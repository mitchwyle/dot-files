#!/usr/bin/env bats

# Test functions in setup-dot-files.sh

#. setup-dot-files.sh # load up the functions to test
. setup-dot-files.sh

@test "Happy path of bashrc for SetEditorAndSudo" { 
      BASHRC="/tmp/test-bashrc_$$"      # test file name for ~/.bashrc
  ROOTBASHRC="/tmp/root-test-bashrc_$$" # test file name for ~root/.bashrc
  wuh="$(SetEditorForSudo)"
  [[ $(grep -Fx "EDITOR=vi" "$BASHRC" >/dev/null; echo $?) ]]
  /bin/rm -f $BASHRC $ROOTBASHRC
}

@test "Happy path of adding $USER to sudo without a password" {
  TMPTESTFILE="/tmp/TestNoPasswdSudo_$$"
  SUDOCMD="tee $TMPTESTFILE"
  wuh="$(NoPasswdSudo)"
  [[ $(grep -Fx "$USER ALL=NOPASSWD" $TMPTESTFILE >/dev/null; echo $?) ]]
  /bin/rm -f $TMPTESTFILE
}

@test "What happens if \$USER has no account when adding to sudoers" {
  TSTUSR="$USER"
  USER="thisUserDoesNotExist"
  [[ wuh="$(NoPasswdSudo >&/dev/null ; echo $?)" ]]
  USR=$TSTUSR  # set USER back to original value
}
 
@test "Happy path test of installing git and github" {
  SshKeyFileName="/tmp/test-ssh-key-gen-$$"
  wuh="$(InstallGitAndGithub >& /dev/null)"
  [[ $(grep -q ssh-rsa "$SshKeyFileName"* ; echo $?) ]]
  /bin/rm -f "$SshKeyFileName".*

}

