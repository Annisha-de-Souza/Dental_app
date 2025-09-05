#!/bin/bash

touch command.txt logs.txt
echo "[+] Remote Control Active at $(date)"

while true; do
  echo "⏳ Checking for commands..."
  git pull origin main --quiet

  CMD_RAW=$(tr -d '\r' < command.txt)
  CMD=$(echo "$CMD_RAW" | xargs)  # trims leading/trailing spaces

  if [ -n "$CMD" ]; then
    echo "📥 Found command: $CMD"
    echo "\$ $CMD" >> logs.txt
    eval "$CMD" >> logs.txt 2>&1
    echo "✅ Command executed."
    echo "" >> logs.txt

    # Wipe command.txt with a single space to avoid empty file issues
    echo " " > command.txt

    git add logs.txt command.txt
    git commit -m "Executed command: $CMD" --quiet
    git push origin main --quiet
    echo "🚀 Logs pushed to GitHub."
  else
    echo "🕵️‍♂️ No command or only whitespace found, waiting..."
  fi
  sleep 1
done
