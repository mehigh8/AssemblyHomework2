section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	mov edi, [ebp + 8]
	mov esi, [ebp + 12]

	xor ecx, ecx

	mov eax, esi
	mov edx, eax

; Caut nodul cu valoarea 1.
find_one:
	cmp dword[eax], 1
	jne continue
	mov edx, eax
	jmp out_of_find
continue:
	inc ecx
	add eax, 8
	cmp ecx, edi
	je out_of_find
	jmp find_one
out_of_find:
	; Dupa ce gasesc nodul cu valoarea 1, ii salvez adresa pe stiva.
	xor ecx, ecx
	mov ecx, 2
	mov eax, edx
	push eax

; Loop-ul care parcurge nodurile
while:
	mov eax, esi
	xor ebx, ebx
; Caut nodul care contine urmatoare valoare (ecx).
find_next:
	cmp [eax], ecx
	jne resume
	; Daca am gasit nodul, ii salvez adresa in campul next al nodului cu
	; valoarea precedenta.
	mov [edx + 4], eax
	mov edx, eax
	jmp end_while
resume:
	inc ebx
	add eax, 8
	cmp ebx, edi
	je end_while
	jmp find_next
end_while:
	inc ecx
	cmp ecx, edi
	jg out_of_while
	jmp while
out_of_while:
	; La sfarsitul programului preiau de pe stiva valoarea salvata, care
	; reprezinta adresa nodului cu valoarea 1, si o pun in eax (valoarea de
	; return).
	pop eax

	leave
	ret
