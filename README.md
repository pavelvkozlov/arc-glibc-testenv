# arc-glibc-testenv
Set of scripts and configs used for glibc testing.
Helps to do initial setup for a new test configutation.

### Setup test environment
Setup test environment for a new test wit target ```arc64``` and new testrun directory glibc-234-arc64:
```
setup.sh arc64 arc64 glibc-234-arc64
```


### Configure and build

Configure and build toolchain

```
../../source/arc-gnu-toolchain/configure --target=arc64 --prefix=`pwd`/../../install/arc64 --enable-linux --disable-werror
make -j8
```

Configure and build glibc for testing
```
./../source/arc-gnu-toolchain/glibc/configure --host=arc64-linux-gnu --prefix=/usr --disable-werror --enable-shared --with-timeoutfactor=20 --enable-obsolete-rpc --with-headers=$ARC_LINUX_HEADERS_DIR --disable-multilib --libdir=/usr/lib libc_cv_slibdir=/lib libc_cv_rtlddir=/lib CFLAGS="-O2 -g3"
make -j8
```
