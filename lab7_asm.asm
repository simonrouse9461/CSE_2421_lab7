; FILE:		lab7_asm.asm
; NAME:		Chuhan Feng
; DATE:		Feb 22, 2015
; CLASS:	CSE 2421, T/TH 8:00AM
; ID:		0x05194445

global	main				; export symbol "main"

extern	printf				; inport "printf"
extern	atoi				; import "atoi"

; the read-only data segment
section	.rodata
format_string db "(%d, %d): %d",0xa,0

; the read-write data segment
section	.data
some_static_int dd 0		; initialize "some_static_int"

; the code segment
section	.text

; function "complex_function"
complex_function:
	; set up stack frame
	push	ebp
	mov		ebp, esp
	; now <arg1> is in [ebp+0x8], <arg2> is in [ebp+0xc]

	; initialize variables
	mov		eax, [ebp+0x8]	; save arg1 in eax
	sub		eax, 7			; solve "temp1 = arg1 - 7"
	push	eax				; push <temp1> into [ebp-0x4]
	mov 	[ebp-0x10], eax	; save <retval> in [ebp-0x10]
	mov		eax, [ebp+0xc]	; save arg2 = temp2 in eax
	push	eax				; push <temp2> into [ebp-0x8]
	mul		dword [ebp+0x8]	; solve "temp3 = arg1 * arg2"
	push 	eax				; push lower 32 bit of <temp3> into [ebp-0xc]
	sub		esp, 0x4		; move stack top to [ebp-0x10]

	; start if statement
	cmp		dword [ebp-0x8], 0		; compare temp2 with 0
	jge		.else_0			; if temp >= 0, jump to else
	add		dword [ebp-0x10], 17	; perform "retval += 17"
	jmp		.done_0			; jump to done

.else_0:
	sub		dword [ebp-0x10], 13	; perform "retval -= 13"

.done_0:
	; start switch statement
	mov		eax, [ebp+0x8]	; move arg1 into eax
	test	eax, eax		; test the value of arg1
	jz		.case_0			; if arg1 == 0 jump to case 0
	dec		eax				; test the value of arg1 - 1
	jz		.case_1			; if arg1 == 1 jump to case 1
	dec		eax				; test the value of arg1 - 2
	jz		.case_2			; if arg1 == 2 jump to case 2
	dec		eax				; test the value of arg1 - 3
	jz		.case_3			; if arg1 == 3 jump to case 3
	jmp		.case_default	; jump to default

.case_0:
	; case arg1 == 0
	mov		eax, [ebp-0x8]	; move temp2 to eax
	; get value of temp2 + some_static_int + 4
	add		eax, [some_static_int]
	add		eax, 4
	; solve "retval = retval + temp2 + some_static_int + 4"
	add		[ebp-0x10], eax
	
.case_1:
	; case arg1 == 1
	mov		eax, [ebp-0x8]	; move temp2 to eax
	sub		eax, 5			; get value of temp2 - 5
	sub		[ebp-0x10], eax	; solve "retval = retval - temp2 + 5"
	jmp		.done_1			; break

.case_2:
	; case arg1 == 2
	mov		eax, [some_static_int]	; move some_static_int to eax
	; slove "retval = retval - 13 - some_static_int"
	sub		dword [ebp-0x10], 13
	sub		[ebp-0x10], eax
	jmp		.done_1			; break

.case_3:
	; case arg1 == 3
	mov		eax, [ebp-0xc]	; move temp3 into eax
	mov		edx, 0x7		; save 7 in edx
	mul		edx				; get the value of temp3 * 7
	sub		eax, [ebp-0x8]	; subtract lower 32 bit of temp3 * 7 with temp2
	add		[ebp-0x10], eax	; solve "retval = retval + (temp3 * 7) - temp2"

.case_default:
	; default
	inc		dword [ebp-0x10]	; increase retval by 1

.done_1:
	mov		eax, [ebp+0x8]	; move arg1 to eax
	mov		ebx, [ebp-0x10]	; move retval to ebx
	; perform "some_static_int = some_static_int - arg1 + retval"
	sub		[some_static_int], eax
	add		[some_static_int], ebx

	; save return value in eax
	mov		eax, [ebp-0x10]

	; restore stack frame and return
	leave
	ret

; main function
main:
	; set up stack frame
	push	ebp
	mov		ebp, esp
	
	; initialize variables
	; get outer_limit
	mov		ecx, [ebp+0xc]	; put argv in ecx
	mov		eax, [ecx+0x4]	; find out argv[1]
	push	eax				; push argv[1] into stack
	call	atoi			; call atoi(argv[1])
	add		esp, 0x4		; ignore argv[1] on stack
	push	eax				; save <outer_limit> in [ebp-0x4]
	; get inner_limit
	mov		ecx, [ebp+0xc]	; put argv in ecx
	mov		eax, [ecx+0x8]	; find out argv[2]
	push	eax				; push argv[2] into stack
	call	atoi			; call atoi(argv[2])
	add		esp, 0x4		; ignore argv[2] on stack
	push	eax				; save <inner_limit> in [ebp-0x8]

	; set up counter
	mov		ebx, 0			; <counter1> for outer loop is in ebx

.loop_0:
	; start outer loop
	cmp		ebx, [ebp-0x4]	; test loop condition
	jge		.done_loop_0	; jump out of loop if counter1 >= outer_limit

	; set up counter
	mov		ecx, 2			; <counter2> for inner loop is in ecx

.loop_1:
	;start inner loop
	cmp		ecx, [ebp-0x8]	; test loop condition
	jle		.done_loop_1	; jump out of loop if counter2 <= inner_limit

	; call complex_function(counter1, counter2)
	push	ecx				; push counter2 into stack
	push	ebx				; push counter1 into stack
	call	complex_function
	pop		ebx				; restore counter1
	pop		ecx				; restore counter2

	; call printf
	push	eax				; push the result of complex_function into stack
	push	ecx				; push counter2 into stack
	push	ebx				; push counter1 into stack
	push	format_string	; push pointer to "(%d, %d): %d\n" into the stack
	call	printf
	pop		eax				; pop out format_string
	pop		ebx				; restore counter1
	pop		ecx				; restore counter2
	add		esp, 0x4		; ingore format_string on stack
	dec		ecx				; decrease counter2
	jmp		.loop_1			; jump back to the start of the loop

.done_loop_1:
	inc		ebx				; increase counter1
	jmp		.loop_0			; jump back to the start of the loop

.done_loop_0:
	mov		eax, 0			; save return value

	; restore stack frame and return
	leave
	ret
