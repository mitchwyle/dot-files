#!/usr/bin/env bats

# Test the helper util functions

. utils.sh # Load utility functions, including log(), die()

# Debug tests
DBUG=true

# Log function:
#
@test "Happy path of log function" { 
  logMessage="hello world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}

@test "Corner Case Quoting Concerns 1 - log a naked apostrophe" { # Always avoid alliteration
  logMessage="hello ' world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}

@test "Corner Case Quoting Concerns 2 - log a naked double-quote" {
  logMessage="hello \" world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}

@test "Command injection attack" {
  touchFile="gotcha_$$"
  logMessage="hello \$(touch $touchFile) world"
  result="$(log $logMessage)"
#  $DBUG && echo "logMessage = $logMessage" > o
#  $DBUG && echo "result = $result" >> o
  [[ "$result" == *"$logMessage"* ]] && [[ ! -f $touchFile ]]
}
# End of Log function tests


# die function -- logs an error message and terminates with exit status 3 (known error):
#
@test "Verify exit code is neither 0 (normal), 1 (sub-command error), 2 (abornmal)" {
  run die "a painful death"
  [[ "$status" -ne 0 && "$status" -ne 1 && $status -ne 2 ]]

}

@test "Verify error message is displayed correctly by die and exit code is 3" {
  run die "a painful death"
  [[ "$status" -eq 3 && "${lines[0]}" = *"painful death"* ]]
}

@test "Verify die correctly swallows naked apostrophe" { # Always avoid alliteration
  logMessage="hello ' world"
  run die "$logMessage"
  [[ "status" -eq 3 && "${lines[0]}" = *"$logMessage"* ]] 
}

@test "Verify die correctly handles double-quote" {
  logMessage="hello \" world"
  run die "$logMessage"
  [[ "status" -eq 3 && "${lines[0]}" = *"$logMessage"* ]] 
}
