#!/bin/bash

# 📌 Define paths and variables
SOURCE_DIR="/tmp/MultiEsamwad/recording"
DEST_DIR="/backup/recordings"   # 🔹 Destination directory on 192.168.0.11
DEST_SERVER="192.168.0.11"      # 🔹 Target server

# 📌 Create a temporary directory for compressed files
TMP_DIR="/tmp/compressed_recordings"
mkdir -p "$TMP_DIR"

# 📌 Find and compress recordings larger than 50MB
echo "Compressing files greater than 50MB..."
find "$SOURCE_DIR" -type f -size +50M | while read FILE; do
    BASENAME=$(basename "$FILE")
    tar -czf "$TMP_DIR/$BASENAME.tar.gz" -C "$SOURCE_DIR" "$BASENAME" && rm -f "$FILE"
done

# 📌 Move compressed files to 192.168.0.11
echo "Moving compressed files to $DEST_SERVER..."
rsync -av "$TMP_DIR/" "$DEST_SERVER:$DEST_DIR/"

# 📌 Clean up local compressed files (only from 192.168.0.110)
rm -rf "$TMP_DIR"

# 📌 Add script to crontab if not already added
CRON_JOB="50 23 * * * /bin/bash $(realpath $0) >> /var/log/move_recordings.log 2>&1"
(crontab -l | grep -q "$CRON_JOB") || (echo "$CRON_JOB" | crontab -)

echo "✅ Script execution completed successfully!"

