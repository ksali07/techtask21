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

# Створення або очищення вихідного файлу
echo "NGINX Log Analysis" > "$OUTPUT_FILE"
echo "===================" >> "$OUTPUT_FILE"

# Форматування таблиці
HEADER="IP Address    | Date & Time        | Request                                             | Status | Size"
SEPARATOR="------------------------------------------------------------------------------------------------------------"

# Додати заголовок таблиці
echo "$HEADER" >> "$OUTPUT_FILE"
echo "$SEPARATOR" >> "$OUTPUT_FILE"

# Обробка лог-файлу
awk '
{
    # Витягуємо IP, Date, Request, Status, Size з логу
    match($0, /^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+) - - \[([^\]]+)\] "(.*)" ([0-9]+) ([0-9\-]+) .*$/, arr);
    if (arr[1] && arr[2] && arr[3] && arr[4] && arr[5]) {
        # Форматуємо в таблицю
        printf "%-15s | %-18s | %-50s | %-6s | %-6s\n", arr[1], arr[2], arr[3], arr[4], arr[5];
    }
}' "$LOG_FILE" >> "$OUTPUT_FILE"

# Додавання роздільника після таблиці
echo "$SEPARATOR" >> "$OUTPUT_FILE"

# Виключення зайвих файлів перед комітом
git rm --cached -r Dockerfile id_rsa known_hosts > /dev/null 2>&1 || true

# Додавання та пуш змін
echo "Adding and committing changes..."
git add "$OUTPUT_FILE"
git commit -m "$COMMIT_MESSAGE"
git push

echo "Analysis Complete! Results saved to $OUTPUT_FILE and changes pushed to Git."

