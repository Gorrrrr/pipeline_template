# choose one of the following to compile
all:
      as -o makewords makewords.s
      ld -o makewords makewords.o
#     as -o lowercase lowercase.s
      ld -o lowercase lowercase.o
#     as -o armscii2utf armscii2utf.s
      ld -o armscii2utf armscii2utf.o


test_lowercase:
      echo "AaBbccDDoOo" | ./lowercase
      cat text_to_spell | ./fmt -1 | ./lowercase | sort | tr '.' ' ' | uniq |  comm -23 - dictionary

test_makewords:
      echo "aaa aab, aac." | ./makewords
      cat text_to_spell | ./makewords | tr A-Z a-z | sort | tr '.' ' ' | uniq |  comm -23 - dictionary

test_armscii2utf:
      cat armscii | ./armscii2ut

.section __BSS,__bss
.comm var, 1
.align 8
.section __TEXT,__text
.globl _main
.align 8

_main:

loop:
      mov $0x2000003, %rax
      mov $0, %rdi
      mov var@GOTPCREL(%rip), %rsi
      mov $1, %rdx
      syscall
      cmp $0, %rax
      jle exit
      mov $var, %dl
      cmp $'A', %dl
      jl print
      cmp $'Z', %dl
      jle routin

print:
      mov $0x2000004, %rax
      mov $1, %rdi
      movv var@GOTPCREL(%rip), %rsi
      mov $1, %rdx
      syscall
      jmp loop    

routin:
      addb $32, var@GOTPCREL(%rip)
      jmp print

exit: 
      mov $0x2000001, %rax
      movb $0, %dil
      syscall
