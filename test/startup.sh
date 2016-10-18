#!/bin/sh
cd $KITURA_SAMPLE_HOME
rm -rf ./.build
mkdir -p ./Packages
./CodeGenerator/generate_function_runner.sh
swift build -Xcc -fblocks 
./.build/debug/KituraSample &
while inotifywait -r /usr/sst_functions ./Sources ./Package.swift -e create,modify,delete; do
	pkill KituraSample
	./CodeGenerator/generate_function_runner.sh
	swift build -Xcc -fblocks
	./.build/debug/KituraSample &
done