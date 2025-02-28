# Makefile
all: main.nes

main.nes: main.o
    ca65 -o main.o main.asm
    ld65 -C nes.cfg -o main.nes main.o

clean:
    rm -f *.o *.nes