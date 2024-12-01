#!/bin/bash

# Path to your private key
private_key_path="/c/Users/ahmed.rasheed/.ssh/id_rsa"

# Base destination path on local machine
base_destination="//192.168.14.29/Common/Ahmed Alrasheed/test/Logs"

# Create a timestamp for the new directory
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
today_date=$(date +"%Y-%m-%d")

# Array of servers and their corresponding paths
declare -A servers
servers=(
    ["server1"]="arasheed@192.168.128.71:/home/arasheed/test"
    ["server2"]="arasheed@172.32.255.86:/home/arasheed/test"
)

#----------------------------------------------------------------Start the Job----------------------------------------------------------------

for server in "${!servers[@]}"; do
    echo "Connecting to $server..."

    # Extract the server and path from the associative array
    IFS=':' read -r server_hostname path_to_logs <<< "${servers[$server]}"

    # Set the local destination based on the server
    if [ "$server" == "server1" ]; then
        server_destination="$base_destination/folder1/$timestamp"
    elif [ "$server" == "server2" ]; then
        server_destination="$base_destination/folder2/$timestamp"
    fi

    # Create the destination directory for this server with timestamp
    mkdir -p "$server_destination"

    # Check for existing files with today's date and delete them
    find "$base_destination/folder1/" -maxdepth 1 -type d -name "*$today_date*" -exec rm -rf {} +
    find "$base_destination/folder2/" -maxdepth 1 -type d -name "*$today_date*" -exec rm -rf {} +

    # Copy all logs from the path
    scp -r -i "$private_key_path" "$server_hostname:$path_to_logs" "$server_destination"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Files copied successfully from $server_hostname:$path_to_logs to $server_destination."
    else
        echo "Failed to copy files from $server_hostname."
    fi
done

#----------------------------------------------------------------End the Job----------------------------------------------------------------