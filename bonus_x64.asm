section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0

; Parametrii functiei se afla in registrii rdi, rsi, rdx, rcx, r8, r9, in ordine.
while:
	; Verific daca am ajuns la sfarsitul primului vector.
	cmp rsi, 0
	je over1
	; Daca nu am ajuns, mut valoarea curenta la sfarsitul vectorului v.
	xor rax, rax
	mov eax, [rdi]
	mov [r8], eax
	dec rsi
	add rdi, 4
	add r8, 4
over1:
	; Verific daca am ajuns la sfarsitul celui de-al doilea vector.
	cmp rcx, 0
	je over2
	; Daca nu am ajuns, mut valoarea curenta la sfarsitul vectorului v.
	xor rax, rax
	mov eax, [rdx]
	mov [r8], eax
	dec rcx
	add rdx, 4
	add r8, 4
over2:
	; La sfarsitul loop-ului verific daca am ajuns la sfarsitul ambilor
	; vectori, caz in care ies din loop.
	cmp rsi, 0
	jne while
	cmp rcx, 0
	jne while

	leave
	ret
