#!/bin/bash

# Check if the zip file name is provided as an argument
if [ -z "$1" ]; then
  echo "Please provide the name of the zip file as an argument."
  exit 1
fi

zip_file="$1"
hash_file="pass.hash"
password_list="/usr/share/wordlists/rockyou.txt"

# Run zip2john to extract the hash
zip2john "$zip_file" > "$hash_file"

# Check if the hash file was successfully created
if [ ! -f "$hash_file" ]; then
  echo "Failed to create the hash file. Please make sure 'zip2john' is installed and accessible."
  exit 1
fi

# Run john the ripper to crack the password
john --format=PKZIP "$hash_file" --wordlist="$password_list"

# Check if the password was cracked
if [ -f "$hash_file" ]; then
  echo "Password cracked successfully."
  john --show "$hash_file"
else
  echo "Failed to crack the password. Please try using a different password list or check if 'john the ripper' is installed and accessible."
fi
