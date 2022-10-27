#!/bin/sh

usage() {
     echo "Usage:"
     echo "Fortmat: $0 TEST_TARGET TEST_DIRECTORY"
     echo "   TEST_TARGET: arc/arc32/arc64"
     echo "   TEST_DIRECTORY: is a name directory that will be created"
     echo "                   inside ./testing dir for a new test run"
     echo "NOTE: ARC_QEMU_PATH and ARC_NSIM_PATH env variables are used"
     echo "to setup path qemu and nsim"
}

if [ -z $1 ]
then
    echo ">>> test target is not specified!"
    usage
    exit 0
fi

#TODO: Add check for targets

if [ -z $2 ]
then
    echo ">>> new test target directory is not specified!"
    usage
    exit 0
fi

#TODO: Check that directory is already exists

echo "Setup new glibc test environment for a target: $1"

# Create work directories
mkdir -p ./testing/$2
mkdir ./testing/$2/build
mkdir ./testing/$2/source
mkdir ./testing/$2/install
mkdir ./testing/$2/images

# Copy some support scripts to test run directory
cp ./scripts/save-test-results.sh ./testing/$2/
cp ./scripts/nsim-$1-run.sh ./testing/$2/
cp ./scripts/qemu-$1-run.sh ./testing/$2/

# Create environment script
CURRENT_DIR=$(pwd)
cd ./testing/$2

echo '#!/bin/sh' > setenv.sh
echo "" >> setenv.sh
echo 'export PATH='$(pwd)'/install/'${1}'/bin:$PATH' >> setenv.sh
echo "export ARC_TOOLCHAIN_INSTALL_DIR=$(pwd)/install/$1" >> setenv.sh
echo "export ARC_TOOLCHAIN_SYSROOT_DIR=$(pwd)/install/$1/sysroot" >> setenv.sh
echo "export ARC_LINUX_HEADERS_DIR=$(pwd)/source/arc-gnu-toolchain/linux-headers/include" >> setenv.sh
echo "export ARC_QEMU_PATH=${ARC_QEMU_PATH:-/usr/local/bin}" >> setenv.sh
echo "export ARC_NSIM_PATH=${ARC_NSIM_PATH:-../tools/nSIM64/bin}" >> setenv.sh
chmod +x ./setenv.sh

cd $CURRENT_DIR
echo "Setup completed, new glibc test directory: $CURRENT_DIR/testing/$2"