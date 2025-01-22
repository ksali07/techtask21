# Analyze nginx log file and convert it to CSV

## What will be required?
Linux operating system (AlmaLinux 8.10 was used in this example) and access to the term (preferably root access).
Availability of nginx log.

# Realization options
Analyzing, sorting, and converting the log file to CSV will be implemented via Bash + awk.
In the first implementation (script.sh), we will create a sorting of IP addresses by the number of requests using awk:
```
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | awk '{print $2 "," $1}' >> "$OUTPUT_FILE"
```
We will also add a count of the total number of requests:
```
TOTAL_REQUESTS=$(wc -l < "$LOG_FILE")
```
