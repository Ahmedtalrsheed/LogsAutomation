#!/bin/bash

# Path to your private key
private_key_path="/c/Users/ahmed.rasheed/.ssh/id_rsa.pub"

# Destination path on local machine
local_destination="/c/Users/ahmed.rasheed/Desktop/Logs_Project"

# Define server details and paths
declare -A servers
servers=(
    ["server1"]="arasheed@192.168.128.71"
    ["server2"]="arasheed@172.32.255.86"
)
echo 1
# Define paths for each server
#declare -A server1_paths
#server1_paths=(
#    ["path1"]="/WebsiteJobs/JOBS/scripts/ControlMtest/AdjustmentRun.sh"
#    ["path2"]="/WebsiteJobs/JOBS/scripts/ControlMtest/testGenretedfile.txt"
#)

declare -A server2_paths
server2_paths=(
    ["path1"]="/websiteJobs/ControlMtest/test"
)
echo 2
# Function to copy files from a server
copy_files_from_server() {
    local server=$1
    local paths=$2
    echo "Connecting to $server..."

    # Check if the SSH command is successful
    if ssh -i "$private_key_path" "$server" "exit"; then
        echo "Successfully connected to $server."

        # Loop through each path and copy files
        for path in "${!paths[@]}"; do
            echo "Copying ${paths[$path]} from $server..."
            scp -i "$private_key_path" "$server:${paths[$path]}" "$local_destination"
            
            if [ $? -eq 0 ]; then
                echo "Successfully copied ${paths[$path]} from $server."
            else
                echo "Failed to copy ${paths[$path]} from $server."
            fi
        done
    else
        echo "Failed to connect to $server."
    fi
}

# Copy files from each server
#copy_files_from_server "${servers[server1]}" server1_paths
copy_files_from_server "${servers[server2]}" server2_paths