global get_words
global compare_func
global sort

section .data
	string_delimiters db 32, 44, 46, 10, 0

section .text
	extern qsort
	extern strtok
	extern strcpy
	extern strlen
	extern strcmp

;; compare (void *s1, void *s2)
; Functia de comparare necesara pentru a sorta cuvintele in functie de
; lungime, respectiv lexicografic.
compare:
	enter 0, 0
	; Salvez registrii vechi.
	push esi
	xor esi, esi
	push edi
	xor edi, edi
	push ebx
	xor ebx, ebx
	push ecx
	xor ecx, ecx

	mov esi, [ebp + 8]
	mov edi, [ebp + 12]

	mov esi, [esi]
	mov edi, [edi]
	; Calculez lungimea cuvintelor primite ca parametru folosind strlen.
	push esi
	call strlen
	add esp, 4
	mov ebx, eax

	push edi
	call strlen
	add esp, 4
	mov ecx, eax

	; Daca lungimile sunt diferite returnez diferenta lor.
	cmp ebx, ecx
	jne dif
	; Altfel folosesc functie strcmp pentru a compara sirurile de caractere
	; din punct de vedere lexicografic.
	push edi
	push esi
	call strcmp
	add esp, 8
	jmp end_compare

dif:
	xor eax, eax
	mov eax, ebx
	sub eax, ecx
end_compare:
	
	; Restaurez valorile registrilor.
	pop ecx
	pop ebx
	pop edi
	pop esi
	leave
	ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    mov esi, [ebp + 8]
    mov edi, [ebp + 12]
    mov edx, [ebp + 16]

    ; Pun pe stiva toti parametrii necesari functiei qsort, care este folosita
    ; pentru sortare.
    push compare
    push edx
    push edi
    push esi
    call qsort
    add esp, 16

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    mov esi, [ebp + 8]
    mov ebx, [ebp + 12]
    mov edi, [ebp + 16]
	
	; Folosesc functia strtok pentru a sparge in cuvinte sirul de caractere.
	push string_delimiters
	push esi
	call strtok
	add esp, 8

; Parcurg sirul de caractere cuvant cu cuvant pana cand nu mai sunt cuvinte
; (eax este 0(valoarea de retur a strtok-ului este null)).
for:
	cmp eax, 0
	je out

	mov edx, [ebx]
	; Fiecare cuvant este copiat in words folsind strcpy.
	push eax
	push edx
	call strcpy
	add esp, 8

	add ebx, 4
	push string_delimiters
	push 0
	call strtok
	add esp, 8
	jmp for
out:

    leave
    ret
