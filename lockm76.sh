# Lock the hardware resources

timeout_ms=999000

# limit the maximum resources
# big_freq, little_freq, gpu_freq, mif_freq, int_freq, disp_freq, isp_freq, little_num, big_num
echo "2000000 1500000 600 825000 543000 317000 777000 4 4" > /sys/power/power_custom 
echo custom > /sys/power/power_mode

# lock big_freq,little_freq, gpu_freq, mif_freq, int_freq, little_num, big_num
echo "1800000 1500000 500 825000 543000 4 4" > /sys/power/perf_custom
echo custom > /sys/power/perf_mode
echo $timeout_ms > /sys/power/perf_boost_timeout
echo $timeout_ms > /sys/power/perf_boost_hmp_timeout


# Force migration to big cpu
# 0: no force migration, 1: migrate with semi threshold, 2: force migration
echo 0 > /sys/power/perf_boost_hmp

# Start boost
echo 1 > /sys/power/perf_boost

# Disable thermal manager
echo $timeout_ms > /sys/power/power_level_timeout
echo 6 > /sys/power/power_level

# Do your test here...
