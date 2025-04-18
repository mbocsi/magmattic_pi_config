#!/bin/bash

check_internet() {
  # Try to ping Google's DNS
  if ping -q -c 1 -W 1 8.8.8.8 > /dev/null; then
    return 0  # Internet is available
  else
    return 1  # No internet connection
  fi
}

BACKEND_DIR="/opt/magmattic_backend"
VENV_PATH="$BACKEND_DIR/env"
PYTHON_SCRIPT="$BACKEND_DIR/main.py"

mkdir -p $BACKEND_DIR
cd $BACKEND_DIR

# Activate venv
source "$VENV_PATH/bin/activate"

# Check if venv activation was successful
if [ $? -eq 0 ]; then
        if check_internet; then
                git pull || git clone git@github-backend:mbocsi/magmattic_backend.git .
                pip install -r "$BACKEND_DIR/requirements.txt"
        else
                echo "No internet connection -- skipping update"
        fi
        python "$PYTHON_SCRIPT"
        deactivate
else
        echo "Error: Failed to activate virtual environment."
        exit 1
fi
