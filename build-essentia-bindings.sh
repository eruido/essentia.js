#!/usr/bin/env bash

# env variables
LIB_DIR=$EMSCRIPTEN/system/local/lib
APP_BUILD=build
BINDING_CPP=src/cpp/bindings.cpp
TO_INCLUDE_ESS=src/cpp/include/essentiamin.cpp


rm -rf ./build
mkdir ./build

printf "\nCompiling the bindings to bitcode ... \n\n"
# compile the app to byte code
emcc --emrun --bind ${BINDING_CPP} ${TO_INCLUDE_ESS} -o essentiamin.bc || exit 1
# emcc --bind -Oz $1 ${TO_INCLUDE_ESS} -c || exit 1

printf "Linking and compiling the bindings with essentia and fftw to js and wasm files ..\n\n"

# without emcc debug mode
#emcc --emrun --bind -s DISABLE_EXCEPTION_CATCHING=0 -s ASSERTIONS=2 -s SAFE_HEAP=1 -s EXCEPTION_DEBUG -Oz essentiamin.bc ${LIB_DIR}/essentia.a -o ${APP_BUILD}/essentiamin.js -s WASM=0 -s || exit 1
emcc --emrun --bind -Oz essentiamin.bc ${LIB_DIR}/essentia.a -o ${APP_BUILD}/essentiamin.js -s WASM=0 -s EXCEPTION_DEBUG -s ASSERTIONS=2 || exit 1
#EMCC_DEBUG=1 (for compiling in debug mode of emcc compiler)

printf "\nRemoving unnecessary files ...\n"
rm essentiamin.bc

printf "\nCopying builds ...\n\n"
cp -rf ${APP_BUILD}/* ./web/dist/

echo " ... Done ..."
