#!/bin/bash

LOG_FILE=$1
OUTPUT_FILE=$2
COMMIT_MESSAGE=$3

# Виключення зайвих файлів перед комітом
echo -e "Dockerfile\nid_rsa\nknown_hosts" > .gitignore
git add .gitignore
git commit -m "Update .gitignore" || true

# Парсинг логів
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

# Додавання та пуш змін
git add "$OUTPUT_FILE"
git commit -m "$COMMIT_MESSAGE" || true
git push

