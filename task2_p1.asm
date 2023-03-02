section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	; Pentru ca nu pot folosi enter, leave sau mov ma voi folosi pe parcursul
	; rezolvarii de faptul ca operatia or aplicata pe 2 numere, dintre care
	; primul este 0, va rezulta in copierea numarului al doilea in primul
	; (practic simuleaza un mov).
	push ebp
	xor ebp, ebp
	or ebp, esp

	xor edi, edi
	or edi, [ebp + 8]
	xor esi, esi
	or esi, [ebp + 12]

	xor ebx, ebx
	or ebx, edi
	xor ecx, ecx
	or ecx, esi
; Calculez cel mai mare divizor comun al celor doua numere.
cmmdc:
	cmp ebx, ecx
	jg greater
	sub ecx, ebx
	jmp end_cmmdc
greater:
	sub ebx, ecx
end_cmmdc:
	cmp ebx, ecx
	je out_of_cmmdc
	jmp cmmdc
out_of_cmmdc:
	; Dupa ce am calculat cmmdc-ul, acesta se afla in ebx (sau ecx, fiindca
	; sunt egale).
	xor eax, eax
	or eax, edi
	; Inmultesc cele doua numere (a - eax si b - esi)
	mul esi
	; Rezultatul este in eax, si trebuie impartit la ebx (cmmdc)
	div ebx
	; Rezultatul este in eax

	xor esp, esp
	or esp, ebp
	pop ebp
	ret
