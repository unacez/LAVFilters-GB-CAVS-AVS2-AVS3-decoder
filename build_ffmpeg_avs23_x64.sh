export PATH=/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/bin:$PATH

arch=x86_64
archdir=x64
cross_prefix=x86_64-w64-mingw32-

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
    --disable-autodetect            \
    --enable-w32threads             \
    --disable-demuxer=matroska      \
    --disable-filters               \
    --enable-filter=scale,yadif,w3fdif,bwdif \
    --disable-protocol=async,cache,concat,httpproxy,icecast,md5,subfile \
    --disable-muxers                \
    --enable-muxer=spdif            \
    --disable-bsfs                  \
    --enable-bsf=extract_extradata,vp9_superframe_split \
    --disable-avdevice              \
    --disable-postproc              \
    --disable-encoders              \
    --disable-devices               \
    --disable-programs              \
    --disable-debug                 \
    --disable-doc                   \
    --enable-avisynth               \
    --enable-bzlib                  \
    --enable-d3d11va                \
    --enable-dxva2                  \
    --enable-gnutls                 \
    --enable-gmp                    \
    --enable-libdav1d               \
    --enable-libspeex               \
    --enable-libopencore-amrnb      \
    --enable-libopencore-amrwb      \
    --enable-libxml2                \
    --enable-zlib                   \
    --enable-libdavs2               \
    --enable-libuavs3d              \
    --build-suffix=-lav             \
    --arch=${arch}"

  OPTIONS+=" --enable-cross-compile --cross-prefix=${cross_prefix} --target-os=mingw32 --pkg-config=pkg-config"

  export PKG_CONFIG_PATH="../thirdparty/64/lib/pkgconfig/:/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/x86_64-w64-mingw32/lib/pkgconfig"
  #export PKG_CONFIG_PATH="../thirdparty/64/lib/pkgconfig/"

  EXTRA_CFLAGS="-fno-tree-vectorize -D_WIN32_WINNT=0x0600 -DWINVER=0x0600"
  EXTRA_CFLAGS+=" -I../thirdparty/64/include -I/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/x86_64-w64-mingw32/include"
  EXTRA_LDFLAGS="-L../thirdparty/64/lib -L/home/hgfk/ffmpeg-windows-build-helpers/sandbox/cross_compilers/mingw-w64-x86_64/x86_64-w64-mingw32/lib"

  PKG_CONFIG_PREFIX_DIR="--define-variable=prefix=../thirdparty/64"

  ./configure --extra-ldflags="${EXTRA_LDFLAGS}" --extra-cflags="${EXTRA_CFLAGS}" --pkg-config-flags="--static ${PKG_CONFIG_PREFIX_DIR}" ${OPTIONS}

#make -j$NUMBER_OF_PROCESSORS
cd ..
