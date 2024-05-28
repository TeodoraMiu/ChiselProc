#!/bin/bash

# Assemble code from provided program

cargo run --manifest-path /home/asus/Documents/assembler/Cargo.toml $1

if [ $? -eq 0 ]; then
	sbt -sbt-dir /home/asus/Documents/ChiselProc/ChiselProc "testOnly ProcessorSpec"
else
	echo "There was an error when assembling the code."
fi
