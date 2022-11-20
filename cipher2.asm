;  Program to demonstrate file I/O.  This Program
;  will open a file, read the data and cipher it
;  and  write some information to the file, 
;  and close the file. Note, the file name and
;  write message are hard-coded.

section .data
; -----
;  Define standard constants.
; -----
    LF equ 10
    NULL equ 0
    EXIT_SUCCESS equ 0
    EXIT_FAILURE equ 1
    STDIN equ 0
    STDOUT equ 1
    STDERR equ 2

    SYS_READ equ 0
    SYS_WRITE equ 1
    SYS_OPEN equ 2
    SYS_CLOSE equ 3
    SYS_EXIT equ 60

    O_CREAT equ 64
    O_TRUNC equ 512
    O_APPEND equ 1024

    O_WRONLY equ 1
    O_RDONLY equ 0
    O_RDWR equ 2

    S_IRUSR equ 256
    S_IWUSR equ 128
    S_IXUSR equ 64

; -----
; Variables for main
; -----
    BUFF_SIZE equ 1000

    inputFile db "msg.txt", NULL
    inputFile_len equ $ - inputFile
    outputFile db "cipher.txt", NULL
    outputFile_len equ $ - outputFile

    fileDesc dq 0
    fileSize dq 0
    errorMsgOpen db "Error opening file", LF, NULL
    errorMsgOpen_len equ $ - errorMsgOpen
    errorMsgRead db "Error reading file", LF, NULL
    errorMsgRead_len equ $ - errorMsgRead
    errorMsgClose db "Error closing file", LF, NULL
    errorMsgClose_len equ $ - errorMsgClose
    errorMsgWrite db "Error writing to file", LF, NULL
    errorMsgWrite_len equ $ - errorMsgWrite

    fileOpened db "File opened successfully", LF, NULL
    fileOpened_len equ $ - fileOpened
    fileClosed db "File closed successfully", LF, NULL
    fileClosed_len equ $ - fileClosed
    fileRead db "File read successfully", LF, NULL
    fileRead_len equ $ - fileRead
    fileWritten db "File written successfully", LF, NULL
    fileWritten_len equ $ - fileWritten
    ReadData db "Read data: ", LF, NULL
    ReadData_len equ $ - ReadData
    WriteData db "Write data: ", LF, NULL
    WriteData_len equ $ - WriteData


; -----
; Variables for reserve memory
; -----
section .bss
    buffer resb BUFF_SIZE
    


section .text
global _start
_start:

    ; Open file
    mov rax, SYS_OPEN
    mov rdi, inputFile
    mov rsi, O_RDONLY
    syscall

    ; Check for error
    cmp rax, 0
    jge openSuccess

    ; Error opening file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, errorMsgOpen
    mov rdx, errorMsgOpen_len
    syscall

    ; Exit with error
    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

openSuccess:
    ; Save file descriptor
    mov qword [fileDesc], rax

    ; File opened successfully
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fileOpened
    mov rdx, fileOpened_len
    syscall

    ; Read from file
    mov rax, SYS_READ
    mov rdi, qword [fileDesc]
    mov rsi, buffer
    mov rdx, BUFF_SIZE
    syscall

    ; Check for error
    cmp rax, 0
    jge readSuccess

    ; Error reading file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, errorMsgRead
    mov rdx, errorMsgRead_len
    syscall

    ; Exit with error
    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

readSuccess:
    ; Save file size
    mov qword [fileSize], rax

    ; File read successfully
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fileRead
    mov rdx, fileRead_len
    syscall


    ; Close file
    ;mov rax, SYS_CLOSE
    mov rdi, qword [fileDesc]
    syscall

    ; Check for error
    cmp rax, 0
    jge closeSuccess

    ; Error closing file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, errorMsgClose
    mov rdx, errorMsgClose_len
    syscall

    ; Exit with error
    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

closeSuccess:

    ; File closed successfully
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fileClosed
    mov rdx, fileClosed_len
    syscall

    ; File Read Data
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, ReadData
    mov rdx, ReadData_len
    syscall

    ; Print read data
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer
    mov rdx, qword [fileSize]
    syscall

    ; Cipher the message
    mov rdi, buffer
    mov rsi, rax
    call cipher

    ; File Write Data
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, WriteData
    mov rdx, WriteData_len
    syscall

    ; Print write data
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, buffer
    mov rdx, qword [fileSize]
    syscall

    ; Open file
    mov rax, SYS_OPEN
    mov rdi, outputFile
    mov rsi, O_WRONLY | O_CREAT | O_TRUNC
    mov rdx, S_IRUSR | S_IWUSR
    syscall

    ; Check for error
    cmp rax, 0
    jge openSuccess2

    ; Error opening file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, errorMsgOpen
    mov rdx, errorMsgOpen_len
    syscall

    ; Exit with error
    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

openSuccess2:

    ; Save file descriptor
    mov qword [fileDesc], rax

    ; File opened successfully
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fileOpened
    mov rdx, fileOpened_len
    syscall

    ; Write to file
    mov rax, SYS_WRITE
    mov rdi, qword [fileDesc]
    mov rsi, buffer
    mov rdx, qword [fileSize]
    syscall

    ; Check for error
    cmp rax, 0
    jge writeSuccess

    ; Error writing to file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, errorMsgWrite
    mov rdx, errorMsgWrite_len
    syscall

    ; Exit with error
    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

writeSuccess:

    ; File written successfully
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fileWritten
    mov rdx, fileWritten_len
    syscall

    ; Close file
    mov rax, SYS_CLOSE
    mov rdi, qword [fileDesc]
    syscall

    ; Check for error
    cmp rax, 0
    jge closeSuccess2

    ; Error closing file
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, errorMsgClose
    mov rdx, errorMsgClose_len
    syscall

    ; Exit with error
    mov rax, SYS_EXIT
    mov rdi, EXIT_FAILURE
    syscall

closeSuccess2:

    ; File closed successfully
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, fileClosed
    mov rdx, fileClosed_len
    syscall

    ; Exit
    mov rax, SYS_EXIT
    mov rdi, EXIT_SUCCESS
    syscall



; -----
;  Cipher the message
; -----
cipher:
    push rbp
    mov rbp, rsp

    ; Cipher the message
    mov rax, 0
cipherLoop:

    ; Check if end of message
    cmp rax, rsi
    jge cipherEnd

    ; Get the character
    mov rbx, 0
    mov bl, byte [rdi + rax]

    ; Check if it is a letter
    cmp rbx, 65
    jl cipherNext
    cmp rbx, 90
    jl uppercase
    cmp rbx, 97
    jl cipherNext
    cmp rbx, 122
    jg cipherNext
    jmp lowercase

uppercase:
    ; Uppercase letter
    sub rbx, 65
    add rbx, 3
    push rax
    mov rdx, 0
    mov rax, rbx
    mov rbx, 26
    div rbx
    pop rax
    mov rbx, rdx
    add rbx, 65
    jmp cipherNext

lowercase:
    ; Lowercase letter
    sub rbx, 97
    add rbx, 3
    push rax
    mov rdx, 0
    mov rax, rbx
    mov rbx, 26
    div rbx
    pop rax
    mov rbx, rdx
    add rbx, 97
    jmp cipherNext

   
cipherNext:
    mov byte [rdi + rax], bl

    ; Increment the counter
    inc rax
    jmp cipherLoop

cipherEnd:

    ; swap the place of odd postions with even positions
    mov rax, 0
swapLoop:

    ; Check if end of message
    cmp rax, rsi
    jge swapEnd

    ; Get the character
    mov rbx, 0
    mov bl, byte [rdi + rax]

    ; Increment the counter
    add rax, 2

    ; Check if it is last character
    cmp rax, rsi
    jge swapEnd

    ; Decrease the counter
    dec rax

    ; Get the next character
    mov rcx, 0
    mov cl, byte [rdi + rax]

    ; Swap the characters
    mov byte [rdi + rax - 1], cl
    mov byte [rdi + rax], bl

nextSwap:

    ; Increment the counter
    inc rax
    jmp swapLoop

swapEnd:

    ; Cipher the message
    mov rax, 0
cipherLoop2:

    ; Check if end of message
    cmp rax, rsi
    jge cipherEnd2

    ; Get the character
    mov rbx, 0
    mov bl, byte [rdi + rax]

    ; Check if it is a letter
    cmp rbx, 65
    jl cipherNext2
    cmp rbx, 90
    jl uppercase2
    cmp rbx, 97
    jl cipherNext2
    cmp rbx, 122
    jg cipherNext2
    jmp lowercase2

uppercase2:
    ; Uppercase letter
    sub rbx, 65
    add rbx, 3
    push rax
    mov rdx, 0
    mov rax, rbx
    mov rbx, 26
    div rbx
    pop rax
    mov rbx, rdx
    add rbx, 65
    jmp cipherNext2

lowercase2:
    ; Lowercase letter
    sub rbx, 97
    add rbx, 3
    push rax
    mov rdx, 0
    mov rax, rbx
    mov rbx, 26
    div rbx
    pop rax
    mov rbx, rdx
    add rbx, 97
    jmp cipherNext2

   
cipherNext2:
    mov byte [rdi + rax], bl

    ; Increment the counter
    inc rax
    jmp cipherLoop2

cipherEnd2:

    pop rbp
    ret

; -----
;  End of file
; -----
