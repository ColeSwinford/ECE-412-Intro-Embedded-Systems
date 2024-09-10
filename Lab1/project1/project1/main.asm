;
; AssemblerApplication1.asm
;
; Created: 1/18/2024 5:39:06 PM
; Author : coles
;

;Screenshot 7 code
/*
		.eseg					;EEPROM data segment, 0x0 to 0x3FF
		.org	0x0				;Begin EEPROM segment at address 0x0
eevar:	.dw		0xfaff			;Store a constant 16-bit data in EEPROM
msg:	.db		"HelloWorld"	;Store a constant string data in EEPROM
		.dseg					;SRAM data segment, 0x100 to 0x8FF
		.org	0x100			;Begin data segment at address 0x100
string:	.byte	3				;a three byte variable
		.cseg					;FLASH code segment, 0x0 to 0x3FF
		.org	0x0				;Begin code at address 0x0
start:	ldi		r30,56			;load immediate value 56 into register 30
		ldi		r31,24			;load immediate value 24 into register 31
		add		r31,r30			;56+24=80 ; store 80 into register 31 and overwrite 24
here:	jmp		here			;jump to here forever or infinite loop
		.exit
*/

;Screenshot 17 code
/*
		.cseg					;operation-flags comment here
		.org	0x0
start:	ldi		r26,0x00		;load immediate value of 0 into register 26
		ldi		r27,0x01		;load immediate value of 1 into register 27
		ldi		r30,56			;load immediate value of 56 into register 30
		ldi		r31,24			;load immediate value of 24 into register 31
		add		r31,r30			;add r31 = r31 + r30, result is located at r31
		sub		r31,r30			;add r31 = r31 - r30, result is located at r31
		and		r30,r31			;performs a bitwise and function on r30 and r31, storing the value in r30
		mul		r30,r31			;add r31 = r31 * r30, result is located at r31
		st		X,r30			;store r30 in data space location X
		clr		r30				;clear register 30
		ser		r31				;loads 0xFF directly to register r31
here:	jmp		here			;jumps to label here:
		.exit
*/

;Screenshot 19 code
/*
		.cseg					;FLASH code segment
		.org	0x0				;Begin EEPROM segment at address 0x0
start:	ldi		r26,0x00
		ldi		r27,0x01
		ldi		r30,56
		ldi		r31,24
		sub		r31,r30
		brmi	here			;"branch if minus," conditionally branch to label here: if the N "negative" flag is active
		st		X,r30			;store r30 in data space X register
		nop						;"no operation" does nothing
		clr		r30				;clear register 30
here:	breq	here			;”branch if equal,” conditionally branch to label here: if the Z “zero” equal flag is active
		.exit
*/

;Screenshot 20 code

		.cseg					;FLASH code segment
		.org	0x0
start:	ldi		r26,0x00
		ldi		r27,0x01
		ldi		r30,0xAC
		lsl		r30				;"logical shift left" shifts all bits in r30 one place to the left, which basically multiplies signed and unsigned values by two
		lsr		r30				;"logical shift right" shifts all bits in r30 one place to the right, which basically divides an unsigned value by two
		asr		r30				;"arithmetic shift right" shifts all bits in r30 one place to the right, which basically divides the signed value by two without changing its sign
		bset	2				;"bit set in SREG" sets flag to 2 which corresponds to flag N "negative"
		bclr	2				;"bit clear in SREG" clears flag 2 from the SREG which corresponds to flag N "negative" being turned off
		brmi	here
		st		X+,r30
		st		X+,r30
		st		X+,r30
here:	jmp		here
		.exit
