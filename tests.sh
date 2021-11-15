#!/usr/bin/env bats

# Test the helper util functions

# Debug tests
DBUG=true

@test "Happy path of log function" {
  . utils.sh # Load utility functions, including log()
  logMessage="hello world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}

@test "Corner Case Quoting Concerns 1 - apostrophe" { # Always avoid alliteration
  . utils.sh
  logMessage="hello ' world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}

@test "Corner Case Quoting Concerns 2 - double-quote" {
  . utils.sh
  logMessage="hello \" world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}

@test "Command injection attack" {
  . utils.sh
  touchFile="gotcha_$$"
  logMessage="hello \$(touch $touchFile) world"
  result="$(log $logMessage)"
  $DBUG && echo "logMessage = $logMessage" > o
  $DBUG && echo "result = $result" >> o
  [[ "$result" == *"$logMessage"* ]] && [[ ! -f $touchFile ]]
}




