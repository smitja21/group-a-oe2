
#!/bin/bash
# diskmon.sh - Disk usage monitoring agent
# Logs usage for all mounted filesystems to systemd journal

THRESHOLD=${DISK_WARN_THRESHOLD:-80} # configurable via environment

while true; do
        TIMESTAMP=$(date --iso-8601=seconds)

        # Loop over all real mounted filesystems
        while IFS= read -r line; do
                USAGE=$(echo "$line" | awk '{print $5}' | tr -d '%')
                MOUNT=$(echo "$line" | awk '{print $6}')
                DEVICE=$(echo "$line" | awk '{print $1}')

                if [ "$USAGE" -ge "$THRESHOLD" ] 2>/dev/null; then
                        echo "[WARN] ${TIMESTAMP} device=${DEVICE} mount=${MOUNT} usage=${USAGE}% threshold=${THRESHOLD}%"
                else
                        echo "[INFO] ${TIMESTAMP} device=${DEVICE} mount=${MOUNT} usage=${USAGE}%"
                fi
        done < <(df -h --output=source,size,used,avail,pcent,target --exclude-type=tmpfs --exclude-type=devtmpfs | tail -n +2)
        sleep 30
done

