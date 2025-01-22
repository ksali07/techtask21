#!/bin/bash

LOG_FILE=$1
OUTPUT_FILE=$2
COMMIT_MESSAGE=$3

if [ -z "$LOG_FILE" ] || [ -z "$OUTPUT_FILE" ] || [ -z "$COMMIT_MESSAGE" ]; then
    echo "Usage: $0 <nginx_log_file> <output_csv_file> <commit_message>"
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file $LOG_FILE does not exist."
    exit 1
fi

echo "NGINX Log Analysis" > "$OUTPUT_FILE"
echo "===================" >> "$OUTPUT_FILE"

echo "Top IPs by Count" >> "$OUTPUT_FILE"
echo "-----------------" >> "$OUTPUT_FILE"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | awk '{print $2 "," $1}' >> "$OUTPUT_FILE"

echo "-----------------" >> "$OUTPUT_FILE"

echo "Total Requests Count" >> "$OUTPUT_FILE"
echo "---------------------" >> "$OUTPUT_FILE"
TOTAL_REQUESTS=$(wc -l < "$LOG_FILE")
echo "Total Requests: $TOTAL_REQUESTS" >> "$OUTPUT_FILE"

echo "---------------------" >> "$OUTPUT_FILE"

echo "Excluding unnecessary files from Git..."
git rm --cached -r Dockerfile id_rsa known_hosts > /dev/null 2>&1 || true

echo "Adding and committing changes..."
git add "$OUTPUT_FILE"
git commit -m "$COMMIT_MESSAGE"
git push

echo "Analysis Complete! Results saved to $OUTPUT_FILE and changes pushed to Git."

