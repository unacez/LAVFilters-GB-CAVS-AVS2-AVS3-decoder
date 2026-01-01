arch=x86_64
archdir=x64
cross_prefix=x86_64-w64-mingw32-

cd ffmpeg

cp lib*/*-lav-*.dll ../bin_${archdir}
${cross_prefix}strip ../bin_${archdir}/*-lav-*.dll
cp -u lib*/*.lib ../bin_${archdir}/lib

cp lib*/*-lav-*.dll ../bin_${archdir}d
${cross_prefix}strip ../bin_${archdir}d/*-lav-*.dll
cp -u lib*/*.lib ../bin_${archdir}d/lib

