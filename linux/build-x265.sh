#!/bin/sh

if [ "$#" -ne 0 ] ; then
  exec $@
fi

if [   "${MAIN_LIB_STATIC}"   != 'ENABLED' \
    -a "${MAIN_LIB_SHARED}"   != 'ENABLED' \
    -a "${MAIN_CLI}"          != 'ENABLED' \
    -a "${MAIN10_LIB_STATIC}" != 'ENABLED' \
    -a "${MAIN10_LIB_SHARED}" != 'ENABLED' \
    -a "${MAIN10_CLI}"        != 'ENABLED' \
    -a "${MAIN12_LIB_STATIC}" != 'ENABLED' \
    -a "${MAIN12_LIB_SHARED}" != 'ENABLED' \
    -a "${MAIN12_CLI}"        != 'ENABLED' \
    -a "${MULTI_LIB_STATIC}"  != 'ENABLED' ] ; then
  echo "No environment variable set, nothing to do."
  echo "Please run the container with one of the following environment variable enabled:"
  echo "  MAIN_LIB_STATIC   - Builds a static version of the 8bit library   default: DISABLED"
  echo "  MAIN_LIB_SHARED   - Builds a shared version of the 8bit library   default: DISABLED"
  echo "  MAIN_CLI          - Builds an executable version supporting 8bit  default: DISABLED"
  echo "  MAIN10_LIB_STATIC - Builds a static version of the 10bit library  default: DISABLED"
  echo "  MAIN10_LIB_SHARED - Builds a shared version of the 10bit library  default: DISABLED"
  echo "  MAIN10_CLI        - Builds an executable version supporting 10bit default: DISABLED"
  echo "  MAIN12_LIB_STATIC - Builds a static version of the 12bit library  default: DISABLED"
  echo "  MAIN12_LIB_SHARED - Builds a shared version of the 12bit library  default: DISABLED"
  echo "  MAIN12_CLI        - Builds an executable version supporting 12bit default: DISABLED"
  echo "  MULTI_LIB_STATIC  - Builds a static version of the library supporting multiple bitdepths default: DISABLED"
  echo "Other usefull variables are:"
  echo "  CLONE_URL    - The url used for cloning the repository          default: https://bitbucket.org/multicoreware/x265"
  echo "  CLONE_BRANCH - The branch to be cloned (eg: master, stable,...) default: stable"
  exit
fi

NBCORES=$(cat /proc/cpuinfo | grep proc | wc -l)

hg clone -b "${CLONE_BRANCH}" "${CLONE_URL}"
cd x265/build/linux

if [ "${MAIN_LIB_STATIC}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=OFF -DENABLE_CLI=OFF
  make -j ${NBCORES}
  cp libx265.a /output/libx265_main.a
fi
if [ "${MAIN_LIB_SHARED}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=ON -DENABLE_CLI=OFF
  make -j ${NBCORES}
  cp libx265.so /output/libx265_main.so
fi
if [ "${MAIN_CLI}" = 'ENABLED' ] ; then
  echo ""
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=OFF -DENABLE_CLI=ON
  make -j ${NBCORES}
  cp x265 /output/x265_main
fi
if [ "${MAIN10_LIB_STATIC}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DHIGH_BIT_DEPTH=ON -DMAIN12=OFF
  make -j ${NBCORES}
  cp libx265.a /output/libx265_main10.a
fi
if [ "${MAIN10_LIB_SHARED}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=ON -DENABLE_CLI=OFF -DHIGH_BIT_DEPTH=ON -DMAIN12=OFF
  make -j ${NBCORES}
  cp libx265.so /output/libx265_main10.so
fi
if [ "${MAIN10_CLI}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=OFF -DENABLE_CLI=ON -DHIGH_BIT_DEPTH=ON -DMAIN12=OFF
  make -j ${NBCORES}
  cp x265 /output/x265_main10
fi
if [ "${MAIN12_LIB_STATIC}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DHIGH_BIT_DEPTH=ON -DMAIN12=ON
  make -j ${NBCORES}
  cp libx265.a /output/libx265_main12.a
fi
if [ "${MAIN12_LIB_SHARED}" = 'ENABLED' ] ; then
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=ON -DENABLE_CLI=OFF -DHIGH_BIT_DEPTH=ON -DMAIN12=ON
  make -j ${NBCORES}
  cp libx265.so /output/libx265_main12.so
fi
if [ "${MAIN12_CLI}" = 'ENABLED' ] ; then
  echo ""
  cmake -G "Unix Makefiles" ../../source -DENABLE_SHARED=OFF -DENABLE_CLI=ON -DHIGH_BIT_DEPTH=ON -DMAIN12=ON
  make -j ${NBCORES}
  cp x265 /output/x265_main12
fi
if [ "${MULTI_LIB_STATIC}" = 'ENABLED' ] ; then
  MAKEFLAGS="-j ${NBCORES}"
  ./multilib.sh
  cp 8bit/libx265.a /output/libx265.a
fi

echo "Finished compiling, here is the list of generated files :"
ls /output