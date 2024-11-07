#!/bin/sh

# Cambiar al directorio de trabajo

# NASM
# -f formato de salida
# -g genera información de depuración
# -F formato de depuración
# -l genera un archivo de listado
# -o archivo de salida
# $1.asm archivo de entrada

nasm -f elf64 -g -F dwarf -l $1.lst -o $1.o $1.asm

# GCC
# -no-pie evita que se genere un archivo ejecutable independiente de posición
# -o archivo de salida
# $1.o archivo de entrada

gcc -no-pie -o $1 $1.o

# Ejecutar el archivo generado

./$1