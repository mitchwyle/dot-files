# Some bash utility functions

log() {
  printf '%(%F %T)T : ' -1
  echo "$*"
}

die() {
  log "$*"
  exit 3
}

