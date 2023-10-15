#!/bin/bash

MANIFEST= # manifest rom
BRANCH= # branch rom
DEVICE= # DEVICE LU
BUILD= # ENG,USERDEBUG,USER
ROM= # lineage,derp,aosp dan kawan kawan

mkdir -p /tmp/rom
cd /tmp/rom

# Repo init command, that -device,-mips,-darwin,-notdefault part will save you more time and storage to sync, add more according to your rom and choice. Optimization is welcomed! Let's make it quit, and with depth=1 so that no unnecessary things.
repo init --no-repo-verify --depth=1 -u "$MANIFEST" -b "$BRANCH" -g default,-device,-mips,-darwin,-notdefault

# Sync source with -q, no need unnecessary messages, you can remove -q if want! try with -j30 first, if fails, it will try again with -j8
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j30 || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# ccache-fix
mkdir tempcc
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=$PWD/tempcc
ccache -M 100G -F 0

# Remove yang mau di ubah 
rm -rf

# Sync KT VT DT dibawah ini
git clone

# Sync Hals hardware qcom device kalo ada kalo nggak ada yaudah
git clone

# Normal build steps
. build/envsetup.sh
export TZ=Asia/Jakarta #put before last build command
lunch "$ROM"_"$DEVICE"-"$BUILD"

# upload function for uploading rom zip file! I don't want unwanted builds in my google drive haha!
up(){
	curl --upload-file $1 https://oshi.at/$(basename $1); echo
	# 14 days, 10 GB limit
}

mka sym # make build
up out/target/product/"$DEVICE"/*zip
up out/target/product/"$DEVICE"/*json
