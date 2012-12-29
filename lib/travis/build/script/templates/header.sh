travis_start() {
  echo "`date +%s.%N` [$1] start" >> <%= LOGS[:state] %>
}

travis_end() {
  echo "`date +%s.%N` [$1] end, result: $?" >> <%= LOGS[:state] %>
}

travis_assert() {
  if [ $? != 0 ]; then
    echo "Command did not exit with 0. Exiting." >> <%= LOGS[:build] %>
    echo "`date +%s.%N` Command did not exit with 0. Exiting." >> <%= LOGS[:state] %>
    kill $$
  fi
}

travis_timeout() {
  local pid=$!
  local start=$(date +%s)
  while ps aux | awk '{print $2 }' | grep -q $pid 2> /dev/null; do
    if [ $(expr $(date +%s) - $start) -gt $1 ]; then
      echo "Command timed out after $1 seconds. Exiting." >> <%= LOGS[:build] %>
      kill -9 $pid
      kill $$
    fi
  done
  wait $pid
}

rm -rf   <%= BUILD_DIR %>
mkdir -p <%= BUILD_DIR %>
cd       <%= BUILD_DIR %>

<%= LOGS.map { |name, path| "touch #{path}; > #{path}" }.join("\n") %>

