export PATH=/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-i686/bin:$PATH

arch=x86
archdir=win32
cross_prefix=i686-w64-mingw32-

make_dirs() (
  mkdir -p bin_${archdir}/lib
  mkdir -p bin_${archdir}d/lib
)


make_dirs
cd ffmpeg

OPTIONS="
    --enable-shared                 \
    --disable-static                \
    --enable-gpl                    \
    --enable-version3               \
    --enable-w32threads             \
    --disable-demuxer=matroska      \
    --disable-filters               \
    --enable-filter=scale,yadif,w3fdif \
    --disable-protocol=async,cache,concat,httpproxy,icecast,md5,subfile \
    --disable-muxers                \
    --enable-muxer=spdif            \
    --disable-bsfs                  \
    --enable-bsf=extract_extradata,vp9_superframe_split \
    --disable-cuda                  \
    --disable-cuvid                 \
    --disable-nvenc                 \
    --enable-libdav1d               \
    --enable-libdavs2               \
    --enable-libspeex               \
    --enable-libopencore-amrnb      \
    --enable-libopencore-amrwb      \
    --enable-avresample             \
    --enable-avisynth               \
    --disable-avdevice              \
    --disable-postproc              \
    --disable-swresample            \
    --disable-encoders              \
    --disable-devices               \
    --disable-programs              \
    --disable-debug                 \
    --disable-doc                   \
    --disable-schannel              \
    --enable-gnutls                 \
    --enable-gmp                    \
    --build-suffix=-lav             \
    --arch=${arch}"

  EXTRA_CFLAGS="-fno-tree-vectorize -D_WIN32_WINNT=0x0600 -DWINVER=0x0600"
  OPTIONS="${OPTIONS} --cpu=i686"
  OPTIONS+=" --enable-cross-compile --cross-prefix=${cross_prefix} --target-os=mingw32 --pkg-config=pkg-config"

  EXTRA_CFLAGS+=" -mmmx -msse -msse2 -mfpmath=sse -mstackrealign -I../thirdparty/32/include -I/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-i686/i686-w64-mingw32/include"
  EXTRA_LDFLAGS="-L../thirdparty/32/lib -L/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-i686/i686-w64-mingw32/lib"
  PKG_CONFIG_PREFIX_DIR="--define-variable=prefix=../thirdparty/32"

  #export PKG_CONFIG_PATH="../thirdparty/32/lib/pkgconfig/:/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-i686/i686-w64-mingw32/lib/pkgconfig"
  export PKG_CONFIG_PATH="../thirdparty/32/lib/pkgconfig/"

  ./configure --extra-ldflags="${EXTRA_LDFLAGS}" --extra-cflags="${EXTRA_CFLAGS}" --pkg-config-flags="--static ${PKG_CONFIG_PREFIX_DIR}" ${OPTIONS}

#make -j$NUMBER_OF_PROCESSORS
cd ..
