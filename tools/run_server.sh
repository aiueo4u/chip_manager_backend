#!/bin/bash

rm -f tmp/pids/server.pid

yarn devserver --host 0.0.0.0 &
bundle exec rails s -p 3000 -b 0.0.0.0
