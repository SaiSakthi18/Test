#!/bin/bash

input_file="$1" temp_file="temp_file.txt"

while IFS= read -r line; do line_length=${#line} if [ "$line_length" -lt 1165 ]; then printf "%-1165s\n" "$line" >> "$temp_file" elif [ "$line_length" -gt 1165 ]; then echo "${line:0:1165}" >> "$temp_file" else echo "$line" >> "$temp_file" fi done < "$input_file"

mv "$temp_file" "$input_file" echo "File processed successfully."
