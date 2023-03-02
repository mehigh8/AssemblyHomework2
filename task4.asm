section .text
        extern atoi

global expression
global term
global factor

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        ; Salvez registrii vechi.
        push esi
        xor esi, esi
        push edi
        xor edi, edi
        push ebx
        xor ebx, ebx
        push ecx
        xor ecx, ecx
        push edx
        xor edx, edx

        mov esi, [ebp + 8]
        mov edi, [ebp + 12]

        xor eax, eax
; Verific daca in expresia curenta se afla alte caractere in afara de cifre.
check_not_digit:
        cmp byte[esi + ecx], 48
        jl not_digit
        cmp byte[esi + ecx], 57
        jg not_digit
        jmp digit
not_digit:
        inc edx
digit:
        ; Verific si daca intreaga expresie se afla intr-o paranteza.
        cmp byte[esi + ecx], 40
        jne close
        inc ebx
close:
        cmp byte[esi + ecx], 41
        jne next
        dec ebx
next:
        cmp ebx, 0
        jne end_check
        inc eax
        jmp end_check
end_check:
        inc ecx
        cmp byte[esi + ecx], 0
        je out_of_check
        jmp check_not_digit
out_of_check:
        ; Daca sunt doar cifre apelez functia atoi pentru a obtine numarul
        ; reprezentat de cifrele din sirul de caractere.
        cmp edx, 0
        jne end_factor

        push esi
        call atoi
        add esp, 4

        jmp end

remove_parentheses:
        ; Paranteza este stearsa prin mutarea adresei de inceput la caracterul
        ; urmator, si punerea caracterului null pe ultima pozitie nenula.
        dec ecx
        mov byte[esi + ecx], 0
        inc esi
        jmp removed

end_factor:
        ; Daca intreaga expresie se afla intr-o paranteza, functia sterge
        ; paranteza.
        cmp eax, 1
        je remove_parentheses
removed:
        ; In final, se trimite expresia functiei expression.
        push edi
        push esi
        call expression
        add esp, 8
        
end:
        ; Se restaureaza valorile registrilor.
        pop edx
        pop ecx
        pop ebx
        pop edi
        pop esi

        leave
        ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp
        ; Salvez registrii vechi.
        push esi
        xor esi, esi
        push edi
        xor edi, edi
        push ebx
        xor ebx, ebx
        push ecx
        xor ecx, ecx
        push edx
        xor edx, edx

        mov esi, [ebp + 8]
        mov edi, [ebp + 12]

        xor eax, eax
; Caut primul semn de * sau / care sa nu fie intre paranteze.
find_sign:
        ; Verific daca pe pozitia curenta se afla o paranteza deschisa.
        cmp byte[esi + ecx], 40
        jne not_open
        inc ebx
not_open:
        ; Sau inchisa.
        cmp byte[esi + ecx], 41
        jne resume
        dec ebx
resume:
        ; Verific daca ma aflu intr-o paranteza.
        cmp ebx, 0
        jne in
        ; Daca nu ma aflua intr-o paranteza, verifica daca pe pozitia curenta
        ; se afla un *.
        cmp byte[esi + ecx], 42
        je found_sign
        ; Sau un /.
        cmp byte[esi + ecx], 47
        je found_sign
in:
        ; Continui pana cand gasesc un semn sau pana se termina expresia.
        inc ecx
        cmp byte[esi + ecx], 0
        je out_of_find
        jmp find_sign
out_of_find:
        ; Daca s-a terminat expresia inseamna ca nu am putut gasi un * sau un
        ; /, prin urmare trimit expresia functiei factor.
        push edi
        push esi
        call factor
        add esp, 8
        jmp end_term
; Daca am gasit un semn, impart expresia in doua punand un null in locul
; semnului.
found_sign:
        xor ebx, ebx
        mov bl, byte[esi + ecx]
        mov byte[esi + ecx], 0
        inc ecx
        lea edx, [esi + ecx]
        ; Apelez functia factor pentru cele doua expresii obtinute.
        push edi
        push esi
        call factor
        add esp, 8
        ; Salvez rezultatul in ecx.
        xor ecx, ecx
        mov ecx, eax

        push edi
        push edx
        call factor
        add esp, 8
        ; Verific daca semnul este * sau /.
        cmp bl, 42
        jne division
        ; Daca este * cele doua numere trebuie inmultite.
        imul ecx
        ; Rezultatul se afla in eax.
        jmp end_term
division:
        ; Daca semnul este / cele doua numere trebuie impartite.
        xchg ecx, eax
        cdq
        idiv ecx
        ; Rezultatul este in eax.
end_term:
        ; Restaurez valorile registrilor.
        pop edx
        pop ecx
        pop ebx
        pop edi
        pop esi

        leave
        ret

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
        push    ebp
        mov     ebp, esp
        ; Salvez registrii vechi.
        push esi
        xor esi, esi
        push edi
        xor edi, edi
        push ebx
        xor ebx, ebx
        push ecx
        xor ecx, ecx
        push edx
        xor edx, edx
        
        mov esi, [ebp + 8]
        mov edi, [ebp + 12]

        xor eax, eax
; Caut primul semn de + sau de - care nu se afla intre paranteze.
search_sign:
        ; Verific daca pe pozitia curenta se afla o paranteza deschisa.
        cmp byte[esi + ecx], 40
        jne closed
        inc ebx
closed: 
        ; Sau inchisa.
        cmp byte[esi + ecx], 41
        jne continue
        dec ebx
continue:
        ; Verific daca nu ma aflu intr-o paranteza.
        cmp ebx, 0
        jne inside
        ; Verific daca pe pozitia curenta se afla un +.
        cmp byte[esi + ecx], 43
        je found
        ; Sau un -.
        cmp byte[esi + ecx], 45
        je found
inside:
        ; Continui cautarea pana la primul semn de + sau -, sau pana se
        ; termina expresia.
        inc ecx
        cmp byte[esi + ecx], 0
        je out_of_search
        jmp search_sign
out_of_search:
        ; Daca am iesit din cautare datorita faptului ca s-a terminat
        ; expresia, inseamna ca nu am putut gasi niciun semn de + sau -, prin
        ; urmare trimit expresia catre functia term.
        push edi
        push esi
        call term
        add esp, 8
        jmp end_expression
; Daca am gasit un semn, sparg expresia in doua expresii punand un caracter
; null in locul semnului.
found:
        xor ebx, ebx
        mov bl, byte[esi + ecx]

        mov byte[esi + ecx], 0
        inc ecx
        lea edx, [esi + ecx]
        ; Apelez functia term pentru cele doua expresii obtinute.
        push edi
        push esi
        call term
        add esp, 8
        ; Retin rezultatul in ecx.
        xor ecx, ecx
        mov ecx, eax

        push edi
        push edx
        call term
        add esp, 8
        ; Verific daca semnul gasit era + sau - si calculez suma sau diferenta
        ; celor doua valori obtinute.
        cmp bl, 43
        jne minus
        add eax, ecx
        jmp end_expression
minus:
        sub ecx, eax
        mov eax, ecx

end_expression:
        ; Restaurez valorile registrilor.
        pop edx
        pop ecx
        pop ebx
        pop edi
        pop esi
        leave
        ret
