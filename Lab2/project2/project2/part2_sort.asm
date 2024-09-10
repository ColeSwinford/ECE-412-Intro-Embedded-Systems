/*
 * part2_sort.asm
 *
 *  Created: 2/28/2024 2:24:08 PM
 *   Author: coles
 */ 
 
			.dseg
			.org	0x0100					;set starting memory location at 0x0100
output:		.byte	20						;allocates 20 bytes in SRAM to store the output value
			.cseg
			rjmp	main
main:		ldi		ZH,high(table<<1)		;load high byte of table int ZH
			ldi		ZL,low(table<<1)		;load low byte of table into ZL
			ldi		XH,high(output)			;load high byte of output into XH
			ldi		XL,low(output)			;load low byte of output into XL
			ldi		r16,20					;load (length) 20 into r16

temp:		lpm		r0,Z+					;load data pointed to by Z into r0 then increment Z
			st		X+,r0					;store r0 into X then increment X
			dec		r16						;decrement 16
			brne	temp					;loop back if r16 != 0

			ldi		r16,19					;load (length-1) 19 into r16 (outer counter)

outer:		ldi		r17,19					;load (length-1) 19 into r16 (inner counter)
			ldi		XH,high(output)			;load high byte of output into XH
			ldi		XL,low(output)+19		;load low byte of output+19 (end of length output) into XL

inner:		ld		r18,X					;load value pointed to by X into r18
			ld		r19,-X					;decrement X and load its value into r19
			cp		r18,r19					;compare r18 and r19 (cp = r18 - r19) find if r18 ?>= r19
			brpl	func_swap				;swap if positive or zero (if r18 >= r19)
			rjmp	no_swap					;don't swap if r18 < r19

func_swap:	mov		r20,r18					;temp var k (r20) = r18
			mov		r18,r19					;r18 = r19 (array[j] = array[j-1])
			mov		r19,r20					;r19 = r20 (array[j-1] = k)
			st		X+,r19					;store value of r19 in memory pointed to by X, then increment X
			st		X,r18					;store value of r18 in memory pointed to by X
			dec		XL						;decrement XL

no_swap:	dec		r17						;decrement r17 (inner counter)
			brne	inner					;if r17 != 0, branch to inner
			dec		r16						;decrement r16 (outer counter)
			brne	outer					;if r16 != 0, branch to outer

			ret								;return to effectively end program (set breakpoint here and check memory at 0x0100,data)
			;table is now sorted from largest to smallest at 0x0100,data

table:		.db		3, 34, 36, 37, 39, 41, 30, 45, 46, 48, 50, 4, 5, 55, 57, 59, 61, 63, 64, 70