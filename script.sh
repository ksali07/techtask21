#!/bin/bash

LOG_FILE=$1
OUTPUT_FILE=$2
COMMIT_MESSAGE=$3

# Перевірка введених параметрів
if [[ -z "$LOG_FILE" || -z "$OUTPUT_FILE" || -z "$COMMIT_MESSAGE" ]]; then
	  echo "Usage: $0 <log_file> <output_csv> <commit_message>"
	    exit 1
    fi

    # Перевірка існування файлу логів
    if [[ ! -f "$LOG_FILE" ]]; then
	      echo "Error: Log file '$LOG_FILE' does not exist."
	        exit 1
	fi

	# Парсинг логів за допомогою awk
	awk 'BEGIN {
	  FS = " ";
	    print "IP,Date,Request,Status,Size";
    }
    {
	      match($0, /([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).* \[(.*)\] "(.*)" ([0-9]+) ([0-9]+)/, arr);
	        if (arr[1] != "") {
			    print arr[1] "," arr[2] "," arr[3] "," arr[4] "," arr[5];
			      }
		      }' "$LOG_FILE" > "$OUTPUT_FILE"

		      # Додавання файлу до Git, коміт і пуш
		      git add "$OUTPUT_FILE"
		      git commit -m "$COMMIT_MESSAGE"
		      git push

