#!/bin/bash

# Log file path
LOG_FILE="./camera-control.log"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to log gphoto2 output
log_gphoto2() {
    gphoto2 --capture-image 2>&1 | while IFS= read -r line; do
        log "$line"
    done
}

# Check if any cameras are detected
if ! gphoto2 --auto-detect | grep -iq "usb:"; then
    log "Error: No cameras detected. Please connect a camera and try again."
    exit 1
fi

log "Camera detected. Starting infinite capture loop."

# Function to check if capturing is enabled
is_enabled() {
    curl -s http://localhost:5001/status | jq '.enabled' | grep -q true
}

# Infinite loop to capture images every 20 seconds
while true; do
    if is_enabled; then
        # Note the start time
        start_time=$(date +%s)
        log "Starting capture."

        # Capture photo using gphoto2 and log output
        log_gphoto2
        log "Capture complete."

        # Calculate how long the command took
        end_time=$(date +%s)
        duration=$((end_time - start_time))

        # Ensure we only sleep for a positive duration
        sleep_time=$((20 - duration))
        if [ $sleep_time -gt 0 ]; then
            log "Sleeping for $sleep_time seconds."
            sleep $sleep_time
        fi
    else
        log "Capture disabled. Waiting..."
        sleep 1
    fi
done

