#!/usr/bin/env bats

@test "Happy path of log function" {
  . utils.sh # Load utility functions, including log()
  logMessage="hello world"
  result="$(log $logMessage)"
  [[ "$result" == *"$logMessage"* ]] 
}
