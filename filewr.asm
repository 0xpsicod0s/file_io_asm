bits 64

section .rodata
    filename: db 'file.txt', 0
    msg: db 'Hello, world!', 0xa
    MSG_LEN equ $-msg

section .bss
    file_buffer resb 2048

section .text
    global _start
    _start:
        mov rax, 0x02 ; syscall: open
        lea rdi, [rel filename] ; nome do arquivo
        mov rsi, 0x242 ; flags: O_RDWR|O_CREAT|O_TRUNC
        mov rdx, 0x1b6 ; permissões: 0666
        syscall ; chamada da syscall

        mov rbx, rax ; salvando o file descriptor para uso posterior

        mov rax, 0x01 ; syscall: write
        mov rdi, rbx ; file descriptor salvo anteriormente
        lea rsi, [rel msg] ; mensagem escrita
        mov rdx, MSG_LEN ; tamanho da mensagem
        syscall ; chamada da syscall

        mov rax, 0x08 ; syscall: lseek
        mov rdi, rbx ; file descriptor
        xor rsi, rsi ; offset = 0
        xor rdx, rdx ; SEEK_SET
        syscall ; chamada da syscall
        
        mov rax, 0x00 ; syscall: read
        mov rdi, rbx ; file descriptor
        lea rsi, [rel file_buffer] ; buffer de saida
        mov rdx, 2048 ; maximo de bytes lidos
        syscall ; chamada da syscall

        mov rcx, rax ; tamanho do arquivo

        mov rax, 0x01 ; syscall: write
        mov rdi, 0x01 ; file descriptor: stdout
        lea rsi, [rel file_buffer] ; dados do arquivo
        mov rdx, rcx ; tamanho do conteudo
        syscall ; chamada da syscall
        
        mov rax, 0x03 ; syscall: close
        mov rdi, rbx ; file descriptor
        syscall ; chamada da syscall

        mov rax, 0x3c ; syscall: exit
        xor rdi, rdi ; codigo de erro
        syscall ; chamada da syscall
