/*
 * part1_nested.asm
 *
 *  Created: 2/28/2024 2:26:34 PM
 *   Author: coles
 */

;view stack at 0x08FF,data
 			.dseg 
			.org	0x100			;Originate data storage at address 0x100
quotient:	.byte	1				;uninitialized quotient variable stored in SRAM aka data segment
remainder:	.byte	1				;uninitialized remainder variable stored in SRAM
			.set	count = 0		;initialized count variable stored in SRAM

			.cseg					;Declare and Initialize Constants (modify them for different results)
			.equ	dividend = 13	;8-bit dividend constant (positive integer) stored in FLASH memory aka code segment
			.equ	divisor = 3		;8-bit divisor constant (positive integer) stored in FLASH memory

;Vector Table (partial)
			.org	0x0				;RESET Vector at address 0x0 in FLASH memory (handled by MAIN)
reset:		jmp		main			;External interrupt vector at address 0x2 in Flash memory (handled by int0)
int0v:		jmp		int0h

;MAIN entry point to program
			.org	0x100			;originate MAIN at address 0x100 in FLASH memory (step through the code)
main:		call	init			;initialize variables subroutine, set break point here, check the STACK,SP,PC
endmain:	jmp		endmain

;subroutines			
init:		lds		r0,count		;get initial count, set break point here and check the STACK,SP,PC
			sts		quotient,r0		;use the same r0 value to clear the quotient-
			sts		remainder,r0	;and the remainder storage locations
			call	getnums			;Check the STACK,SP,PC here.
			ret						;return from subroutine, check the STACK,SP,PC here.
getnums:	ldi		r30,dividend	;Check the STACK,SP,PC here.
			ldi		r31,divisor
			call	test			;Check the STACK,SP,PC here.
			ret						;Check the STACK,SP,PC here.
test:		cpi		r30,0			;is dividend == 0 ?
			brne	test2
test1:		jmp		test1			;halt program, output = 0 quotient and 0 remainder
test2:		cpi		r31,0			;is divisor == 0 ?
			brne	test4
			ldi		r30,0xEE		;set output to all EE's = Error division by 0
			sts		quotient,r30
			sts		remainder,r30
test3:		jmp		test3			;halt program, look at output
test4:		cp		r30,r31			;is dividend == divisor ?
			brne	test6
			ldi		r30,1			;then set output accordingly
			sts		quotient,r30
test5:		jmp		test5			;halt program, look at output
test6:		brpl	test8			;is dividend < divisor ?
			ser		r30
			sts		quotient,r30	
			sts		remainder,r30	;set output to all FF's = not solving Fractions in this pro
test7:		jmp		test7			;halt program look at output
test8:		call	divide			;Check the STACK,SP,PC here.
			ret						;otherwise, return to do positive integer div
divide:		lds		r0,count		;loads value of count variable into r0
divide1:	inc		r0				;increment value of r0
			sub		r30,r31			;subtract r30 = r30 - r31, result is located at r30 (subtracts divisor from dividend)
			brpl	divide1			;checks carry flag, jumping to divide1 if sub r30,r31 is results in a positive value
			dec		r0				;decrement value of r0--keeping track of how many times the divisor can be subtracted from the dividend
			add		r30,r31			;add r30 = r30 + r31, result is located at r30. (adds divisor to remainder)
			sts		quotient,r0		;stores value of r0 in quotient variable
			sts		remainder,r30	;stores value of r30 in remainder variable
divide2:	ret						;returns, which exits the subtroutine
int0h:		jmp		int0h			;interrupt 0 handler goes here
			.exit