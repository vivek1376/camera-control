#!/bin/bash

# Start the Flask app in the background
nohup python3 control_app.py > /dev/null 2>&1 &

# Store the Flask app PID
FLASK_PID=$!

# Start the capture script in the background
nohup ./capture_script.sh > /dev/null 2>&1 &

# Store the capture script PID
CAPTURE_PID=$!

# Function to clean up background processes
cleanup() {
    echo "Stopping Flask app..."
    kill $FLASK_PID
    echo "Stopping capture script..."
    kill $CAPTURE_PID
    exit 0
}

# Trap the exit signal to clean up properly
trap cleanup EXIT

# Wait indefinitely to keep the script running
while true; do
    sleep 1
done

