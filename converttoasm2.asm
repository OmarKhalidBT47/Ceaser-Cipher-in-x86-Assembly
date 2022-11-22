;int x[4]={3,2,4,5}
  ;if(x[1]>4){
    ;x[1]=x[1]+1
    ;else{
 ;printf("%d",x[1])
 ;}

;Convert the following code to ASM

section .data 
      ;int x[4]={3,2,4,5}
      x: dd 3,2,4,5
      ;if(x[1]>4){
      ;x[1]=x[1]+1
      ;else{
      ;printf("%d",x[1])
      ;}
      section .text
      global _start
      _start:
      ;if(x[1]>4){
      mov eax, [x+4]
      cmp eax, 4
      jle else
      ;x[1]=x[1]+1
      mov eax, [x+4]
      add eax, 1
      mov [x+4], eax
      jmp end
      ;else{
      else:
      ;printf("%d",x[1])
      mov eax, 4
      mov ebx, 1
      mov ecx, x
      mov edx, 11
      int 0x80
      ;}
      end:
      mov eax, 1
      int 0x80

