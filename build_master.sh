#!/bin/bash
if [ ! "${1}" = "skip" ] ; then
	./build_clean.sh
	./build_kernel.sh CC='$(CROSS_COMPILE)gcc' "$@"
fi

if [ -e boot.img ] ; then
	rm arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat version)".zip 2>/dev/null
	cp boot.img kernelzip/boot.img
	cd kernelzip/
	7z a -mx9 arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)"-tmp.zip *
	zipalign -v 4 arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)"-tmp.zip ../arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)".zip
	rm arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat ../version)"-tmp.zip
	cd ..
	ls -al arter97-kernel-"$(git rev-parse --abbrev-ref HEAD)"-"$(cat version)".zip
	rm kernelzip/boot.img
fi
