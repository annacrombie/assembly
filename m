nasm -felf32 along32.asm

nasm -felf32 -l$1.lst $1.asm

gcc -m32 $1.o along32.o -o $1

./${1}

rm ${1}.o
