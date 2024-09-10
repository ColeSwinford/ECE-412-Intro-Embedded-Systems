;
; demo_project.asm
;
; Created: 1/26/2024 5:03:46 PM
; Author : coles
;

;demo-project
		.cseg
		.org	0x0
start:	ldi		r30,10			;load immediate value of 10 into register 30
		ldi		r31,5			;load immediate value of 5 into register 31
		ldi		r29,3			;load immediate value of 1 into register 32

		;Can add and subtract two numbers showing result in a register
		add		r30,r31			;add r30 = r30 + r31, result is located at r30
		sub		r30,r31			;subtract r30 = r30 - r31, result is located at 30

		;Can multiply two numbers showing result in a register
		mul		r29,r31			;multiply r29 = r29 * r31, result is located at r0

		;Can negate a register and set bits in a register
		neg		r29				;negate bits by setting them to the two's compliment value
		sbr		r29,2			;set bits 0 and 1 to F

		;Can clear a register
		clr		r29				;clear register 29

		;Can transfer a number from a register to an SRAM location
		sts		0x011E,r30		;transfer value of r30 into SRAM at 0x011E (note, add 0x before the value in SRAM to get your number)

		;Can transfer a number from an SRAM location to a register
		lds		r29,0x011E		;transfer value of SRAM at 0x011E into r29

		;Copy one register to another
		mov		r28,r29			;copy value from r29 to r28

		;Can conditionally branch to another part of the code
		cp		r28,r29			;compare values of r28 and r29
		breq	equal			;jump to label "equal:" if the previous comparison has resulted in equal (BREQ - Branch if Equal)
		clr		r28				;without a branch, r28 would be cleared
equal:	nop						;destination of BREQ

		;Can unconditionally branch or jump to another part of the code
		jmp		jump			;jump to label "jump:"
		clr		r28				;without a jump, r28 would be cleared
jump:	nop						;destination of jmp

		;Set and Clear the carry bit in the status register
		sec						;set carry flag
		clc						;clear carry flag

		;Swap the two nibbles of an 8-bit register
		SWAP	r28				;swap the nibbles of the 8-bit integer 0x0A (10), resulting in 0xA0 (160)

		;Can create a DO-UNTIL loop
		ldi		r27,0			;load immediate value of 0 into register 27
do_until_loop:
		inc		r27				;increment r27 as the loop counter
		cpi		r27,2			;compare value of r27 to 2, so the loop should run twice
		brne	do_until_loop	;branch to do_until_loop if r27 != 2

		;Can create a FOR-NEXT loop
for_next_loop:
		dec		r27				;decrement r27 to reflect the loop being ran again
		cpi		r27,0			;compare value of r27 to 0, so the loop will run until r27 hits 0 (twice in this case)
		brne	for_next_loop	;branch to for_next_loop if r27 != 0