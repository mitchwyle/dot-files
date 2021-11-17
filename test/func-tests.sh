#!/usr/bin/env bats

# Test functions in setup-dot-files.sh

#. setup-dot-files.sh # load up the functions to test
. wuh.sh
  DBUG="true"

@test "Happy path of bashrc for SetEditorAndSudo" { 
      BASHRC="/tmp/test-bashrc_$$"      # test file name for ~/.bashrc
  ROOTBASHRC="/tmp/root-test-bashrc_$$" # test file name for ~root/.bashrc
  wuh="$(SetEditorForSudo)"
  $DBUG && echo "$BASHRC contains" ; cat $BASHRC ; echo ""
  [[ $(grep -Fx "EDITOR=vi" "$BASHRC" >/dev/null; echo $?) ]]
}

/bin/rm -f $BASHRC $ROOTBASHRC

