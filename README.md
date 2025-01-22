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
Detailed implementation of the filter, adding and pushing changes can be found in the script.sh file.
The result of the script testing can be found in analysis_result.csv.

In the second example (script01.sh), the logs are structured in a convenient way for reading and analysis.
Implementation of a filter by IP Address, Date & Time, Request, Status, Size:
```
awk '
{
  
    match($0, /^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) - - \[([^\]]+)\] "(.*)" ([0-9]+) ([0-9\-]+) .*$/, arr);
    if (arr[1] && arr[2] && arr[3] && arr[4] && arr[5]) {
       
        printf "%-15s | %-18s | %-50s | %-6s | %-6s\n", arr[1], arr[2], arr[3], arr[4], arr[5];
    }
}' "$LOG_FILE" >> "$OUTPUT_FILE"
```
The general design of the script can be found in script01.sh.

Run one of the scripts as follows:
```
./script.sh nginx.log analysis_result.csv "Add analyzed logs"
or
./script01.sh nginx.log output.csv "Add analyzed logs"
```
