#!/bin/sh
# Wait for the data partition filesystem to be readable before erlinit tries to mount it
# This works around a race condition with PINCTRL_GEMINILAKE delaying device readiness

# Unconditional output to prove script is running (output to all consoles)
echo "===== WAIT-FOR-DATA-PARTITION SCRIPT STARTED =====" > /dev/console 2>&1 || true
echo "===== WAIT-FOR-DATA-PARTITION SCRIPT STARTED =====" > /dev/tty1 2>&1 || true
echo "===== WAIT-FOR-DATA-PARTITION SCRIPT STARTED =====" > /dev/tty2 2>&1 || true
echo "===== WAIT-FOR-DATA-PARTITION SCRIPT STARTED ====="

DEVICE="/dev/rootdisk0p4"
MAX_ATTEMPTS=30
SLEEP_INTERVAL=1

echo "wait-for-data-partition: Checking if $DEVICE is ready..."

attempt=1
while [ $attempt -le $MAX_ATTEMPTS ]; do
    # Try to read the first block from the device - if it succeeds, device is ready
    if dd if="$DEVICE" of=/dev/null bs=512 count=1 2>/dev/null; then
        echo "wait-for-data-partition: $DEVICE readable after $attempt attempt(s)"
        # Extra delay to ensure filesystem is fully settled
        sleep 1
        exit 0
    fi
    echo "wait-for-data-partition: Waiting for $DEVICE... (attempt $attempt/$MAX_ATTEMPTS)"
    sleep $SLEEP_INTERVAL
    attempt=$((attempt + 1))
done

echo "wait-for-data-partition: WARNING - $DEVICE not ready after $MAX_ATTEMPTS attempts"
exit 0
