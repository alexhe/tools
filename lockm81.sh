# Lock the hardware resources

timeout_ms=999000

# limit the maximum resources
# echo little_freq gpu_freq little_num > /sys/power/power_custom
echo "1300000 448500 8" > /sys/power/power_custom 
echo custom > /sys/power/power_mode

# lock big_freq,little_freq, gpu_freq, mif_freq, int_freq, little_num, big_num
echo "1300000 448500 8" > /sys/power/perf_custom
echo custom > /sys/power/perf_mode
echo $timeout_ms > /sys/power/perf_boost_timeout

# Force migration to big cpu
# 0: no force migration, 1: migrate with semi threshold, 2: force migration
# echo 0 > /sys/power/perf_boost_hmp

# Start boost
echo 1 > /sys/power/perf_boost

# Disable thermal manager
#echo $timeout_ms > /sys/power/power_level_timeout
#echo 6 > /sys/power/power_level

# Do your test here...
