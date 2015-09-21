OUTDIR=$1
ISREBOOT=$2

CMD='fastboot flash'

#$CMD lk lk.bin
$CMD boot $OUTDIR/boot.img
$CMD recovery $OUTDIR/recovery.img
$CMD secro $OUTDIR/secro.img
$CMD logo $OUTDIR/logo.bin
$CMD custom $OUTDIR/custom.img
$CMD tee1 $OUTDIR/trustzone.bin
$CMD tee2 $OUTDIR/trustzone.bin
$CMD system $OUTDIR/system.img
$CMD cache $OUTDIR/cache.img
$CMD userdata $OUTDIR/userdata.img

if [ $ISREBOOT ] then
	fastboot reboot 
endif
