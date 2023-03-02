section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	; La fel ca la primul subpunct, voi folosi operatia de or pentru a simula
	; operatia de mov.
	push ebp
	xor ebp, ebp
	or ebp, esp

	xor edi, edi
	or edi, [ebp + 8]
	xor esi, esi
	or esi, [ebp + 12]

	xor ecx, ecx

while:
	xor eax, eax
	or al, byte[esi + ecx]
	; Daca pozitia curenta are o paranteza deschisa, aceasta este adaugata pe
	; stiva.
	cmp al, 40
	je equal
	; Altfel inseamna ca este paranteza inchisa si verific daca mai sunt
	; paranteze deschise pe stiva.
	cmp esp, ebp
	je false
	; Daca mai sunt, scot o paranteza de pe stiva, altfel inseamna ca sirul de
	; paranteze este incorect.
	pop eax
	jmp end_while
equal:
	push eax
end_while:
	inc ecx
	cmp ecx, edi
	je out_of_while
	jmp while
out_of_while:
	; Dupa ce am parcurs sirul de paranteze verific daca au mai ramas alte
	; paranteze pe stiva.
	cmp esp, ebp
	jne false

true:
	xor eax, eax
	or eax, 1
	jmp end
false:
	xor eax, eax

end:
	xor esp, esp
	or esp, ebp
	pop ebp
	ret
