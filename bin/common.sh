error() {
  echo " !     $*" >&2
  exit 1
}

status() {
  echo "-----> $*"
}

protip() {
  echo
  echo "PRO TIP: $*" | indent
  echo "See https://devcenter.heroku.com/articles/nodejs-support" | indent
  echo
}

# sed -l basically makes sed replace and buffer through stdin to stdout
# so you get updates while the command runs and dont wait for the end
# e.g. npm install | indent
indent() {
  c='s/^/       /'
  case $(uname) in
    Darwin) sed -l "$c";; # mac/bsd sed: -l buffers on line boundaries
    *)      sed -u "$c";; # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

cat_npm_debug_log() {
  test -f $build_dir/npm-debug.log && cat $build_dir/npm-debug.log
}

unique_array() {
  echo "$*" | tr ' ' '\n' | sort -u | tr '\n' ' '
}

init_log_plex_fifo() {
  for log_file in $*; do
    echo "mkdir -p `dirname ${log_file}`"
  done
  for log_file in $*; do
    echo "rm -f ${log_file}"
    echo "mkfifo ${log_file}"
  done
}

init_log_plex() {
  for log_file in $*; do
    echo "mkdir -p `dirname ${log_file}`"
  done
  for log_file in $*; do
    echo "touch ${log_file}"
  done
}

tail_log_plex() {
  for log_file in $*; do
    echo "tail -n 0 -qF --pid=\$\$ ${log_file} &"
  done
}

# Show script name and line number when errors occur to make buildpack errors easier to debug
trap 'error "Script error in $0 on or near line ${LINENO}"' ERR
