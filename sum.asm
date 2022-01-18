SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1
 
segment .data 
 
   msg1 db "Enter a number ", 0xA,0xD 
   len1 equ $- msg1 
 
   msg2 db "Please enter a second number", 0xA,0xD 
   len2 equ $- msg2 
 
   msg3 db "The sum is: "
   len3 equ $- msg3


segment .bss
   num1 resq 32
   num2 resq 32
   sum resq 32
section	.text
   global _start


strlen: ; arg1 == address of the string
   push ebp
   mov ebp, esp
   push esi
   xor eax, eax
   mov esi, edi ; arg1
.lp: cmp byte [esi], 0
   jz .quit
   inc esi
   inc eax
   jmp short .lp
.quit: pop esi
   pop ebp
   ret ; eax == return


_start:
   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg1         
   mov edx, len1 
   int 0x80                
 
   mov eax, SYS_READ 
   mov ebx, STDIN  
   mov ecx, num1
   mov edx, 32
   int 0x80            
 
   mov eax, SYS_WRITE        
   mov ebx, STDOUT         
   mov ecx, msg2          
   mov edx, len2         
   int 0x80
 
   mov eax, SYS_READ  
   mov ebx, STDIN  
   mov ecx, num2 
   mov edx, 32
   int 0x80 
 
   mov eax, SYS_WRITE         
   mov ebx, STDOUT         
   mov ecx, msg3          
   mov edx, len3         
   int 0x80

   mov edi, num1
   call strlen
   dec eax
   mov ecx, eax

   mov edi, num2
   call strlen
   dec eax

   ;used to add
   mov edi, eax
   mov esi, ecx

   ;No idea how it works, but here you need it (calculated experimentally).
   dec edi
   dec esi
   ;find the largest number 
   mov eax, edi
   cmp eax, esi
   cmovl eax, esi
   ;largest number
   mov ebx, eax
   inc ebx
   mov     ecx, 32
   clc

add_loop:  
   mov 	al, [num1 + esi]
   adc 	al, [num2 + edi]
   aaa
   pushf
   or 	al, 30h
   popf
	
   mov	[sum + ebx], al
   dec	esi
   dec   edi
   dec   ebx
   loop	add_loop

   mov eax, SYS_WRITE        
   mov ebx, STDOUT
   mov ecx, sum
   mov edx, 33     
   int 0x80
 
exit:    
   
   mov eax, SYS_EXIT   
   xor ebx, ebx 
   int 0x80