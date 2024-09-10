/*
 * part2.asm
 *
 *  Created: 2/28/2024 2:26:01 PM
 *   Author: coles
 */ 

 			.dseg
			.org	0x100
output:		.byte	1				;Allocates 1 byte in SRAM to store the output value
			.cseg
			.org	0x0
			jmp		main			;partial vector table at address 0x0
			.org	0x100			;MAIN entry point at address 0x200 (step through the code)
main:		ldi		ZL,low(2*table)	;loads immediate value of the lower 8 bits(last 8 bits of each number) from the table(doubled for byte addressing) into the lower byte of the Z register
			ldi		ZH,high(2*table);student loads immediate value of the higher 8 bits(first 8 bits of each number) from the table(doubled for byte addressing) into the higher byte of the Z register
			ldi		r16,celsius		;loads the value from celsius constant(5) into r16
			add		ZL,r16			;adds lower byte of register Z (ZL) = ZL + r16
			ldi		r16,0			;loads immediate value of 0 into r16
			adc		ZH,r16			;adds higher byte of register Z (ZH) = ZH +r16
			lpm						;lpm = lpm r0,Z "load program memory" loads memory pointed to by Z register into r0
			sts		output,r0		;store look-up result to SRAM
			ret						;returns the subroutine, but effectively ends the program execution because there's no explicit call to main

; Fahrenheit look-up table
table:		.db		32, 34, 36, 37, 39, 41, 43, 45, 46, 48, 50, 52, 54, 55, 57, 59, 61, 63, 64, 66
			.equ	celsius = 5		;modify Celsius from 0 to 19 degrees for different results