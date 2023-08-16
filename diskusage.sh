#!/bin/bash
#################################################
# Author:     Christo Deale                  
# Date  :     2023-08-16           
# diskusage:  Utility to review Disk Space Avail 
#             & Usage Locations            
#################################################
# Run the 'df -h' command and filter the output to show only /dev/mapper/*
df_output=$(df -h | awk '/\/dev\/mapper\//')

# Print the disk availability section in red
printf "\e[1;31m:: DISK AVAILABILITY ::\e[0m\n"
printf "\e[1;31m%-30s %-10s %-10s %-10s %-20s\e[0m\n" "Filesystem" "Used" "Avail" "Use%" "Mounted on"

# Loop through each line of the df output
while IFS= read -r line; do
    # Extract the columns
    filesystem=$(echo "$line" | awk '{print $1}')
    used=$(echo "$line" | awk '{print $3}')
    avail=$(echo "$line" | awk '{print $4}')
    use_percent=$(echo "$line" | awk '{print $5}')
    mounted_on=$(echo "$line" | awk '{print $6}')
    
    # Print the formatted line
    printf "%-30s %-10s %-10s %-10s %-20s\n" "$filesystem" "$used" "$avail" "$use_percent" "$mounted_on"
done <<< "$df_output"

# Print the disk usage locations section in red
printf "\n\e[1;31m:: DISK USAGE LOCATIONS ::\e[0m\n"
printf "\e[1;31m%-10s %-s\e[0m\n" "Used" "Location"

# Run the 'du' command and sort the output
du_output=$(du -hs /* 2>/dev/null | sort -rh | head -n 5)

# Loop through each line of the du output
while IFS= read -r line; do
    # Extract the columns
    used=$(echo "$line" | awk '{print $1}')
    location=$(echo "$line" | awk '{print $2}')
    
    # Print the formatted line
    printf "%-10s %-s\n" "$used" "$location"
done <<< "$du_output"
