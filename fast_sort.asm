;%include "io.inc" ;Оно ном не надо 

     section .data
    ;Неупорядоченный массив:
    List_1 dd 80, 58, 7, 7, 41, 32, 3, 65, 81, 28, 93, 52, 69, 73, 20, 62, 42, 99, 46, 62
    ;Частично упорядоченный по возрастанию:
    ;List_1 dd 3, 7, 28, 32, 41, 44, 58, 65, 80, 81, 93, 52, 73, 62, 20, 42, 56, 69, 46, 99
    ;Частично упорядоченный по убыванию:
    ;List_1 dd 81, 80, 65, 58, 44, 41, 32, 28, 7, 3, 93, 52, 73, 62, 20, 42, 56, 69, 46, 99
    ;List_1 dd 19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0
    ;List_1 dd 9,8,7,6,5,4,3,2,1,0
    razmer dd 20
    
    
    left dd 0 ;adress min elementa
    right dd 0 ;adress max elementa
    middle_index dd 0 ;adress middle elementa
    middle_value dd 0 ;value middle elementa
    start dd 0 
    end dd 0 
    right_start dd 0 
    ITER dd 0
    
    probel db ' ', 0  
    newline_buffer db 0
    ;--------------------------------------------
    msg_1 db "Исходный массив: ", 0x20
    len_msg_1 equ $-msg_1
    
    msg_2 db "Отсортированный массив: ", 0x20
    len_msg_2 equ $-msg_2
    
    msg_3 db "Количество итераций: ", 0x20
    len_msg_3 equ $-msg_3
    
    msg_4 db ": ", 0x20
    len_msg_4 equ $-msg_4
    ;--------------------------------------------    
    ;test_lable db '*', 0
    ;len equ $-test_lable
        
    section .bss
    buffer resb 32
    buffer_DEC resd 32
    msg resd 100
    len resd 100
    
    section .text
    
global _start
_start:
    mov ebp, esp; for correct debugging
;--------------------------------------------------------------    
    mov eax,[razmer]
    dec eax
    mov [end],eax
;--------------------------------------------------------------
;Print lable 
    call Print_NEWLINE
    mov eax, msg_1
    mov [msg], eax
    mov eax, len_msg_1
    mov [len],eax
    call Print_String
;--------------------------------------------------------------
Print_no_sort_List:
call Display_List
call Print_NEWLINE
;--------------------------------------------------------------   
;---------------------Sort process:----------------------------
call Fast_sort
;--------------------------------------------------------------
;Print lable   
    call Print_NEWLINE
    mov eax, msg_2
    mov [msg], eax
    mov eax, len_msg_2
    mov [len],eax
    call Print_String
;--------------------------------------------------------------
Print_List_sort:
call Display_List
;--------------------------------------------------------------
;;Print lable
;    call Print_NEWLINE
;    mov eax, msg_3
;    mov [msg], eax
;    mov eax, len_msg_3-1
;    mov [len],eax
;    call Print_String
;--------------------------------------------------------------
; Print_ITER:   
;    mov eax,[ITER]
;    mov [buffer_DEC], eax
;    call Print_DEC
    
;--------------------------------------------------------------
    call Print_NEWLINE
    call Print_NEWLINE    
    exit:
        mov eax, 1        
        xor ebx, ebx      
        int 0x80      
;-------------------------------------------------------
;-------------Процедуры  сортировки---------------------
;-------------------------------------------------------     
    Fast_sort:
    mov eax, [start]
    mov ebx, [end]
    
    if_sort:
    cmp eax, ebx
    JGE return_sort
    
    mov [left], eax
    mov [right], ebx
    call Select_main_element    
    mov esi, [right_start]
    ;push esi
    dec esi
    ;mov [right_start], esi
    mov [end], esi
    mov eax, 0
    call Fast_sort 
    ;pop esi ; = right_start
    
    mov esi, [right_start]
    mov eax, [razmer]
    dec eax
    mov [start], esi
    mov [end], eax
    call Fast_sort
   
    return_sort:
    ret
 ;-------------------------------------------------------       
 ;-------------------------------------------------------              
 Select_main_element: 
    ;-----------------------
    ;Вывод номера итерации
;    mov esi,[ITER]
;    inc esi
;    mov [ITER], esi
;     
;    mov eax,[ITER]
;    mov [buffer_DEC], eax
;    call Print_DEC
;    
;    mov eax, msg_4
;    mov [msg], eax
;    mov eax, len_msg_4-1
;    mov [len],eax
;    call Print_String
;    
;    call Display_List
    ;-----------------------
    ;Print right_start
;        mov eax,[right_start]
;        mov [buffer_DEC], eax
;        call Print_DEC
;        call Print_NEWLINE
    ;-----------------------
    
    mov ebx, 2
    mov eax, [left]
    add eax, [right]
    xor edx, edx
    div ebx
    mov [middle_index], eax
    mov edx, List_1[eax*4]
    mov [middle_value],edx
    ;eax - целое
    ;edx - остаток
    
while_1:

    mov eax, [left]
    mov ebx, [right]
    cmp eax,ebx
    JLE while_2
    JMP return
   
        while_2:                
            mov edx, [left]
            mov eax, List_1[edx*4]
            mov ebx, [middle_value]

            cmp eax, ebx
            JL _inc
            jmp while_3
            
                _inc:
                inc edx
                mov [left], edx
                jmp while_2
                
                    while_3:
                    mov edx, [right]
                    mov eax, List_1[edx*4]
                    mov ebx, [middle_value]
                     
                    cmp eax, ebx
                    JG _dec
                    jmp if
                        _dec:
                        dec edx
                        mov [right], edx
                        jmp while_3
                    
                            if:
                            mov eax, [left]
                            mov ebx, [right] 
                            cmp eax, ebx
                            JLE swap
                            JMP while_1
                                    swap:
                                    mov esi, List_1[eax*4]
                                    mov edi, List_1[ebx*4]                            
                                    xchg esi, edi

                                    mov List_1[eax*4], esi
                                    mov List_1[ebx*4], edi
                                    inc eax
                                    dec ebx
                                    mov [left], eax
                                    mov [right], ebx
                                    
                            JMP while_1

    return:
    
    mov [right_start], eax
    ret    
;-------------------------------------------------------
;-------------Процедуры  вывода на экран----------------
;------------------------------------------------------- 
Display_List:
    push esi
    push ecx
    push eax
    
    mov esi,0
    mov ecx, [razmer]
    ;inc ecx
    Loop_print:
    mov eax, List_1[esi*4] 
    mov [buffer_DEC], eax
    call Print_DEC
    call Print_Probel
    inc esi
    dec ecx
  JNZ Loop_print
call Print_NEWLINE   
;call Print_NEWLINE 

    pop esi
    pop ecx
    pop eax
    
    ret
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
    lea edx, [buffer + 31]
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