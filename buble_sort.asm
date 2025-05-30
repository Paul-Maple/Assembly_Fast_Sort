
     section .data
    ;Неупорядоченный массив:
    List_1 dd 80, 58, 7, 44, 41, 32, 3, 65, 81, 28, 93, 52, 69, 73, 20, 56, 42, 99, 46, 62
    ;Частично упорядоченный по возрастанию:
    ;List_1 dd 3, 7, 28, 32, 41, 44, 58, 65, 80, 81, 93, 52, 73, 62, 20, 42, 56, 69, 46, 99
    ;Частично упорядоченный по убыванию:
    ;List_1 dd 81, 80, 65, 58, 44, 41, 32, 28, 7, 3, 93, 52, 73, 62, 20, 42, 56, 69, 46, 99
    
    razmer dd 20
    
    probel db ' ', 0  
    
    newline_buffer db 0
    
    ;--------------------------------------------
    msg_1 db "Исходный массив:", 10
    len_msg_1 equ $-msg_1
    
    msg_2 db "Отсортированный массив:", 10
    len_msg_2 equ $-msg_2
    ;--------------------------------------------    
    ;test_lable db '*', 0
    ;len equ $-test_lable
        
    section .bss
    buffer resb 32
    buffer_DEC resb 32
    msg resd 100
    len resd 100
    
    section .text
global _start
_start:
    mov ebp, esp; for correct debugging
;--------------------------------------------------------------
 Print_List_no_sort:   
 call Print_NEWLINE
    mov eax, msg_1
    mov [msg], eax
    mov eax, len_msg_1
    mov [len],eax
    call Print_String
;--------------------------------------------------------------
    mov esi,0
    mov ecx, [razmer]
    Loop_print_List_no_sort:
        mov eax, List_1[esi*4] 
        mov [buffer_DEC], eax
        call Print_DEC
        call Print_Probel 
        inc esi
        dec ecx
    JNZ Loop_print_List_no_sort
call Print_NEWLINE
;--------------------------------------------------------------   
    mov ecx,[razmer]
    dec ecx
    mov [razmer],ecx
    
    mov ecx, [razmer]
print_forI:
  push ecx
  mov esi,0
  mov ecx, [razmer]
  print_forJ:                      
    mov eax, [List_1+ esi*4]
    mov ebx, [List_1+ (esi+1)*4]
    cmp eax, ebx   
    jle ne_swapaem
    
    xchg eax, ebx                    
    mov [List_1 + esi*4], eax       
    mov [List_1 + (esi+1)*4], ebx 
    ne_swapaem:
    
    inc esi
    dec ecx
  JNZ print_forJ
  pop ecx
  dec ecx
JNZ print_forI
;--------------------------------------------------------------
 Print_List_sort:   
 call Print_NEWLINE
    mov eax, msg_2
    mov [msg], eax
    mov eax, len_msg_2
    mov [len],eax
    call Print_String
;--------------------------------------------------------------
    mov esi,0
    mov ecx, [razmer]
    inc ecx
    Loop_print:
    mov eax, List_1[esi*4] 
    mov [buffer_DEC], eax
    call Print_DEC
    call Print_Probel
    
    inc esi
    dec ecx
    JNZ Loop_print
call Print_NEWLINE   
call Print_NEWLINE 
    ;--------------------------------------------------------------
    exit:
        mov eax, 1        
        xor ebx, ebx      
        int 0x80 
        
;-------------------------------------------------------
;--------------------Процедуры--------------------------
;-------------------------------------------------------    
    Print_DEC:
        push eax             
        push ebx             
        push ecx      
        push edx
    mov edi, [buffer_DEC]     
    lea eax, [edi]
    lea edi, [buffer + 31]  ;Вычитание адресов
    mov DWORD [edi], 0x0A   ;Добавление символа новой строки
    
    convert:
    dec edi
    xor edx, edx ; edx = NULL_ptr (т.е. edx = 0)
    mov ecx, 10
    div ecx
    add dl, 30h ; 30h = "0" в таблице ASCII
    mov [edi], dl
    test eax, eax ; eax - остаток
    jnz convert ; if ZF = 0 (т.е. eax не 0)

    ; Print to console
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    lea edx, [buffer +31]
    sub edx, ecx
    int 0x80
        pop edx             
        pop ecx             
        pop ebx      
        pop eax 
    ret
    
    Print_Probel:
        push eax             
        push ebx             
        push ecx      
        push edx
        
            mov eax, 4
            mov ebx, 1
            mov ecx, probel
            mov edx, 1
            int 0x80
        
        pop edx             
        pop ecx             
        pop ebx      
        pop eax  
         
        ret
        
       Print_NEWLINE:
        push eax             
        push ebx             
        push ecx      
        push edx
        
            mov dl,0
            add dl, 0x0A  ; 0x0A  = "\n" в таблице ASCII
            mov [newline_buffer], dl
            mov eax, 4
            mov ebx, 1
            mov ecx,0
            add ecx, newline_buffer
            mov edx, 1
            int 0x80
        
        pop edx             
        pop ecx             
        pop ebx      
        pop eax  
         
        ret  
        
        Print_String:
        push eax             
        push ebx             
        push ecx      
        push edx
       
            mov eax, 4
            mov ebx, 1
            mov ecx, [msg]
            mov edx, [len]
            int 0x80
                    
        pop edx             
        pop ecx             
        pop ebx      
        pop eax 
        
        ret       