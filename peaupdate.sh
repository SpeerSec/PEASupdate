#!/bin/bash
""" Made by SpeerSec - free for use, credit if modified or reused """

# Base URL for download
base_url="https://github.com/carlospolop/PEASS-ng/releases/download"

# Getting todays date in YYYYMMDD format
today=$(date +"%Y%m%d")

# Determine if user wants linux or windows
read -p "Is this for a Linux or Windows machine? (l/w) " opersy

# Check if date is valid
found=false

# Set the URL either linpeas or winpeas
if [ "$opersy" = "l" ] || [ "$opersy" = "linux" ]; then
  mkdir 'linpeas'
  cd ./linpeas/
  main_url="$base_url/linpeas.sh"
else
  main_url="$base_url/winPEAS.bat"
  mkdir 'winpeas'
  cd ./winpeas/
fi

echo 'Finding the latest PEAS...'

# Iterate back from todays date
for ((i=0; i<365; i++)); do

  # Set the date starting at today
  date=$(date -d "$today - $i days" +"%Y%m%d")

  # Concatonate full URL
  main_url="$base_url/$date/${main_url##*/}"

  # Try to download the selected file
  wget "$main_url" --spider -q

  # Check the exit status of the request
  if [ $? -eq 0 ]; then

    # The request was successful so set the found check and break the loop
    found=true
    break
  fi
done

if [ "$found" = true ]; then

  # Download the main file
  wget "$main_url" -q --show-progress 


  if [ "$opersy" = "l" ] || [ "$opersy" = "linux" ]; then

    # Download all the files that begin with "linpeas"

    wget "$base_url/$date/linpeas_darwin_amd64" -q --show-progress 
    wget "$base_url/$date/linpeas_darwin_arm64" -q --show-progress 
    wget "$base_url/$date/linpeas_linux_386" -q --show-progress 
    wget "$base_url/$date/linpeas_linux_amd64" -q --show-progress 
    wget "$base_url/$date/linpeas_linux_arm" -q --show-progress 
    wget "$base_url/$date/linpeas_linux_arm64" -q --show-progress 

  # Change the permissions on the file to allow execution
  chmod +x "${main_url##*/}"

  else
  
    # Download all the files that begin with "winPEAS"

    wget "$base_url/$date/winPEASany.exe" -q --show-progress 
    wget "$base_url/$date/winPEASany_ofs.exe" -q --show-progress 
    wget "$base_url/$date/winPEASx64.exe" -q --show-progress 
    wget "$base_url/$date/winPEASx64_ofs.exe" -q --show-progress 
    wget "$base_url/$date/winPEASx86.exe" -q --show-progress 
    wget "$base_url/$date/winPEASx86_ofs.exe" -q --show-progress 
  fi
else
  # The main file was not found, so print an error message
  echo "Error: Could not find any valid file. Sorry."
fi
