#!/bin/bash
# A simple loop that logs a message every 30 seconds.
# This simulates the behaviour of a long-running daemon.

while true; do
        echo "Hello, systemd world - $(date)"
        sleep 30
done