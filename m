nasm -felf32 ${1}.asm&&gcc -m32 ${1}.o -o ${1}&&./${1} 8 4&&rm ${1}.o
