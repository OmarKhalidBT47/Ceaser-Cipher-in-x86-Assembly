;int x[4]={3,2,4,5}
 ;   if(x[1]>4){
    ;    x[1]=x[1]+1;
       ; }
       ; printf("%d",x[1]);

       ;Convert the following code to ASM
    section .data
    x dd 3,2,4,5
    section .text
    global _start
    _start:
    mov eax, [x+1*4]
    cmp eax, 4
    jle printing
    add eax, 1
    mov [x+4], eax
    printing:
     mov rax, sys_write
        mov rdi, 1
        mov rsi, x+4
        mov rdx, 1
        syscall

            



