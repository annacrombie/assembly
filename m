#!/bin/bash

alongdir="along"
if [[ $1 = clean ]]; then
	rm "$alongdir/along32.o"
	rm src/along32.o
else
	fname="${1//src\//}"
	fname="${fname//\.asm/}"
	echo "$fname"
fi
if [[ ! -f "src/along32.o" ]]; then
	cd "$alongdir"
	nasm -felf32 along32.asm
	cd ../
fi

cd src
cp "../$alongdir/along32.inc" .
cp "../$alongdir/along32.o" .

nasm -felf32 -l${fname}.lst ${fname}.asm

gcc -m32 ${fname}.o along32.o -o ../bin/${fname//[0-9,_]/}

rm ${fname}.lst along32.o ${fname}.o along32.inc

../bin/${fname//[0-9,_]/}
