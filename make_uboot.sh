make distclean
make s5p_v210_defconfig
# make -j8
 make -j4 ARCH=arm CROSS_COMPILE=/opt/EmbedSky/4.4.6/bin/arm-linux- 2>&1 | tee build.log
