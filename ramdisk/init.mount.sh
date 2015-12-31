#!/res/busybox sh

export PATH=/res/asset:$PATH
export ext4=1

mount -t ext4 -o ro,noatime,nodiratime /dev/block/platform/sdhci-tegra.3/by-name/APP /system
mount -t f2fs -o ro,noatime,nodiratime /dev/block/platform/sdhci-tegra.3/by-name/APP /system

mount -t ext4 -o noatime,nodiratime,nosuid,nodev,data=writeback,noauto_da_alloc /dev/block/platform/sdhci-tegra.3/by-name/UDA /arter97/data
mount -t f2fs -o noatime,nodiratime,nosuid,nodev,background_gc=on,discard /dev/block/platform/sdhci-tegra.3/by-name/UDA /arter97/data && export ext4=0

if [ -f /arter97/data/.arter97/btaltrom ] ; then
	export ext4=0
	umount -f /system
	chmod 755 /arter97/data/arter97_secondrom/system
	chmod 771 /arter97/data/arter97_secondrom/data
	chmod 771 /arter97/data/arter97_secondrom/cache
	mount --bind /arter97/data/arter97_secondrom/system /system
	mount --bind /arter97/data/arter97_secondrom/data /data
	mount --bind /arter97/data/arter97_secondrom/cache /cache
	mkdir /arter97/data/.arter97
	mkdir /data/.arter97
	rm -rf /data/.arter97/*
	rm -rf /data/.arter97/.*
	chmod 777 /arter97/data/.arter97
	chmod 777 /data/.arter97
	mount --bind /arter97/data/.arter97 /data/.arter97
	mount --bind -o remount,suid,dev /system
	if [ -f /arter97/data/media/0/.arter97/shared ]; then
		rm -rf /arter97/data/arter97_secondrom/data/media/0/.arter97
		cp -rp /arter97/data/arter97_secondrom/data/media/* /arter97/data/media/
		mount --bind /arter97/data/media /data/media
	fi
	CUR_PATH=$PATH
	export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
	export LD_LIBRARY_PATH=/vendor/lib:/system/lib
	run-parts /arter97/data/arter97_secondrom/init.d
	export PATH=$CUR_PATH
else
	mount --bind /arter97/data /data
	mount -t ext4 -o noatime,nodiratime,nosuid,nodev,data=writeback,nodelalloc /dev/block/platform/sdhci-tegra.3/by-name/CAC /cache
	mount -t f2fs -o noatime,nodiratime,nosuid,nodev,background_gc=on,discard /dev/block/platform/sdhci-tegra.3/by-name/CAC /cache
fi

if [[ $ext4 == "1" ]]; then
	sed -i -e 's@# USERDATA@/dev/block/platform/sdhci-tegra.3/by-name/UDA /data ext4 noatime,nosuid,nodev,data=writeback,noauto_da_alloc wait,check,encryptable=/dev/block/platform/sdhci-tegra.3/by-name/MDA@g' /fstab.tn8
	umount -f /data
	umount -f /arter97/data
fi

touch /dev/block/mounted
