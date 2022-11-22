;assembly code that calculate the summatiuon of all even numbers from 0 to 5
; Even numbers in [0,5] are 0,2,4


mov rcx, 2

repeat:

add rax, rcx

add rcx, 2

cmp rcx, 6 ; 6 is the first number that is not in [0,5] so we stop when rcx is 6 or greater than 6 
; the cmp rcx, 6 means that if rcx is 6 or greater than 6 then the jump will be taken
jne repeat ; jump to repeat if rcx is not equal to 6

ret

;assembly code that calculate the summatiuon of all odd numbers from 0 to 5