nasm -felf32 math.asm&&gcc -m32 math.o -o math&&./math
rm math math.o
