#!/system/bin/sh

# Reset perf mode
echo normal > /sys/power/perf_mode

# Reset power mode
echo normal > /sys/power/power_mode
