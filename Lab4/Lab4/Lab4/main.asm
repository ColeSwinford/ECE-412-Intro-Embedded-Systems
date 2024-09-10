 ; Lab4
 ;
 ; Created: 3/24/2018 4:15:16 AM
 ; Author : Eugene Rockey

		 .org 0				;student discuss interrupts and vector table in report
		 jmp RESET			;student discuss in report
		 jmp INT0_H			;student discuss in report
		 jmp INT1_H			;student discuss in report
		 jmp PCINT0_H			;student discuss in report
		 jmp PCINT1_H			;student discuss in report
		 jmp PCINT2_H			;student discuss in report
		 jmp WDT			;student discuss in report
		 jmp TIM2_COMPA			;student discuss in report
		 jmp TIM2_COMPB			;student discuss in report
		 jmp TIM2_OVF			;student discuss in report
		 jmp TIM1_CAPT			;student discuss in report
		 jmp TIM1_COMPA			;student discuss in report
		 jmp TIM1_COMPB			;student discuss in report
		 jmp TIM1_OVF			;student discuss in report
		 jmp TIM0_COMPA			;student discuss in report
		 jmp TIM0_COMPB			;student discuss in report
		 jmp TIM0_OVF			;student discuss in report
		 jmp SPI_TC			;student discuss in report
		 jmp USART_RXC			;student discuss in report
		 jmp USART_UDRE			;student discuss in report
		 jmp USART_TXC			;student discuss in report
		 jmp ADCC			;student discuss in report
		 jmp EE_READY			;student discuss in report
		 jmp ANA_COMP			;student discuss in report
		 jmp TWI			;student discuss in report
		 jmp SPM_READY			;student discuss in report
	

RESET:	;Initialize the ATMega328P chip for the THIS embedded application.
		;initialize PORTB for Output
		cli
		ldi	r16,0xFF				;PB1 or OC1A Output
		out	DDRB,r16
;initialize and start Timer A, compare match, interrupt enabled
		ldi	r16,0xC0			;set OC to compare match set output to high level
		sts TCCR1A,r16			;store r16 value (0xC0) into register TCCR1A (TC1 Control Register A, which sets OC1A on compare match and sets output to high)
		ldi r16,0x04			;set clock prescaler
		sts TCCR1B,r16			;store r16 value (0x04) into register TCCR1B (TC1 Control Register B, which sets the clock prescalar)
		ldi r16,0x80			;force output compare, set PB1 high
		sts TCCR1C,r16			;store r16 value (0x80) into register TCCR1C (TC1 Control Register C, which forces an output compare for channels A and B, sets PB1 to high)
		ldi r16,0x40			;load immediate value 0x40 into register r16
		sts TCCR1A,r16			;store 0x40 into TCCR1A register (TC1 Control Register A, which sets OC1A on compare match and clears OC1A on TOP)
		ldi	r18,0x0B			;load immediate value 0x0B into register r18
		ldi r17,0xB8			;load immediate value 0xB8 into register r17
		lds r16,TCNT1L			;load TCNT1L (TC1 Counter Value Low byte) register value into register r16
		add r17,r16				;add TCNT1L value in r16 to r17 (r17 = r17 + r16)
		lds r16,TCNT1H			;load TCNT1H (TC1 Counter Value High byte) register value into register r16
		adc r18,r16				;add TCNT1H value in r16 to r18 with carry (r18 = r18 + r16)
		sts OCR1AH,r18			;store r18 value into OCR1AH (Output Compare Register 1 A High byte) register
		sts OCR1AL,r17			;store r17 value into OCR1AL (Output Compare Register 1 A Low byte) register
		ldi r19,0				;loads immediate value 0 into register r19
		ldi r16,0x02			;loads immediate value 0x02 into register r16
		sts TIMSK1,r16			;store 0x02 into TIMSK1 register (Timer/Counter 1 Interrupt Mask Register, enable output compare A interrupt)
		out TIFR1,r16			;write 0x02 to TIFR1 register (clear pending interrupts)
		sei						;enable global interrupts
here:	rjmp here
		
INT0_H:
		nop			;external interrupt 0 handler
		reti
INT1_H:
		nop			;external interrupt 1 handler
		reti
PCINT0_H:
		nop			;pin change interrupt 0 handler
		reti
PCINT1_H:
		nop			;pin change interrupt 1 handler
		reti
PCINT2_H:
		nop			;pin change interrupt 2 handler
		reti
WDT:
		nop			;watch dog time out handler
		reti
TIM2_COMPA:
		nop			;TC 2 compare match A handler
		reti
TIM2_COMPB:
		nop			;TC 2 compare match B handler
		reti
TIM2_OVF:
		nop			;TC 2 overflow handler
		reti
TIM1_CAPT:
		nop			;TC 1 capture event handler
		reti

;;;; default TIM1_COMPA
;TIM1_COMPA:			;TC 1 compare match A handler
;		sbrc	r19,0				;skip if bit 0 of r19 is clear
;		rjmp	ONE					;unconditional relative jump to label ONE
;		ldi		r17,0x04			;load immediate value 0x04 into register r17
;		ldi		r18,0x01			;load immediate value 0x01 into register r18
;		ldi		r19,1				;load immediate value 1 into register r19
;		rjmp	BEGIN				;unconditional relative jump to label BEGIN
;ONE:	ldi		r17,0x04			;load immediate value 0x04 into register r17
;		ldi		r18,0x01			;load immediate value 0x01 into register r18
;		ldi		r19,0				;load immediate value 0 into register r19
;BEGIN:	lds		r16,OCR1AL			;load OCR1AL (Output Compare Register 1 A Low byte) register value into register r16
;		add		r17,r16				;add r16 to r17 (r17 = r17 + r16)
;		lds		r16,OCR1AH			;load OCR1AH (Output Compare Register 1 A High byte) register value into register r16
;		adc		r18,r16				;add r16 to r18 (r18 = r18 + r16) with carry
;		sts		OCR1AH,r18			;store r18 into OCR1AH register (output compare register high byte)								;OCR1AH needs to be updated to change the signal to 120hz, it specifically needs to be moved up to the max and down to the minimum over and over to "breathe"
;		sts		OCR1AL,r17			;store r17 into OCR1AL register (output compare register low byte)


TIM1_COMPA:			;TC 1 compare match A handler
		sbrc	r19,0				;skip if bit 0 of r19 is clear
		rjmp	ONE					;unconditional relative jump to label ONE
		ldi		r17,0x04			;load immediate value 0x04 into register r17
		ldi		r18,0x01			;load immediate value 0x01 into register r18
		ldi		r19,1				;load immediate value 1 into register r19

		rjmp	IFB
		rjmp	IFE
IFB:	cpi		r19,1
		breq	ANDB
		jmp		ELSEB
ANDB:	lds		r16,OCR1AH
		cpi		r16,25
		brlt	BEGIN
		jmp		ELSEB
ELSEB:	ldi		r19,0
IFE:	cpi		r19,0
		breq	ANDE
		jmp		ELSEE
ANDE:	lds		r16,OCR1AH
		cpi		r16,25
		brge	END
		jmp		ELSEE
ELSEE:	ldi		r19,1
ONE:	ldi		r17,0x04			;load immediate value 0x04 into register r17
		ldi		r18,0x01			;load immediate value 0x01 into register r18
		ldi		r19,0				;load immediate value 0 into register r19
BEGIN:	;lds		r16,OCR1AL			;load OCR1AL (Output Compare Register 1 A Low byte) register value into register r16
		;add		r17,r16				;add r16 to r17 (r17 = r17 + r16)
		lds		r16,OCR1AH			;load OCR1AH (Output Compare Register 1 A High byte) register value into register r16
		adc		r18,r16				;add r16 to r18 (r18 = r18 + r16) with carry
		sts		OCR1AH,r18			;store r18 into OCR1AH register (output compare register high byte)								;OCR1AH needs to be updated to change the signal to 120hz, it specifically needs to be moved up to the max and down to the minimum over and over to "breathe"
		sts		OCR1AL,r17			;store r17 into OCR1AL register (output compare register low byte)
		reti						;return from interrupt
END:	;lds		r16,OCR1AL			;load OCR1AL (Output Compare Register 1 A Low byte) register value into register r16 ;ADDED
		;sub		r17,r16				;subtract r16 from r17 (r17 = r17 - r16) ;ADDED
		lds		r16,OCR1AH			;load OCR1AH (Output Compare Register 1 A High byte) register value into register r16 ;ADDED
		sbc		r18,r16				;subtract r16 from r18 (r18 = r18 - r16) with carry ;ADDED
		sts		OCR1AH,r18			;store r18 into OCR1AH register (output compare register high byte)	;ADDED
		sts		OCR1AL,r17			;store r17 into OCR1AL register (output compare register low byte) ;ADDED
		reti						;return from interrupt


;TIM1_COMPA:
;		sbrc	r19,0
;		rjmp	ONE
;		ldi		r17,0x04
;		ldi		r18,0x01
;		ldi		r19,1
;		sbrc	r20,1
;		rjmp	BEGIN
;		rjmp	END
;ONE:	ldi		r17,0x04
;		ldi		r18,0x01
;		ldi		r19,0
;		sbrc	r20,0
;		rjmp	RETURN
;BEGIN:	lds		r16,OCR1AL
;		add		r17,r16
;		lds		r16,OCR1AH
;		adc		r18,r16
;		sts		OCR1AH,r18
;		sts		OCR1AL,r17
;		cpi		r18,8
;		brsh	RETURN
;		ldi		r20,1
;		reti
;END:	lds		r16,OCR1AL
;		sub		r17,r16
;		lds		r16,OCR1AH
;		sbc		r18,r16
;		sts		OCR1AH,r18
;		sts		OCR1AL,r17
;		cpi		r18,8
;		brlo	RETURN
;		ldi		r20,0
;		reti
;RETURN:	reti


;TIM1_COMPA:			;TC 1 compare match A handler
;		sbrc	r19,0				;skip if bit 0 of r19 is clear
;		rjmp	ONE					;unconditional relative jump to label ONE
;		ldi		r17,0x04			;load immediate value 0x04 into register r17
;		ldi		r18,0x01			;load immediate value 0x01 into register r18
;		ldi		r19,1				;load immediate value 1 into register r19
;		sbrc	r20,1
;		rjmp	BEGIN				;unconditional relative jump to label BEGIN
;		rjmp	REDUCE				
;ONE:	ldi		r17,0x04			;load immediate value 0x04 into register r17
;		ldi		r18,0x01			;load immediate value 0x01 into register r18
;		ldi		r19,0				;load immediate value 0 into register r19
;		sbrc	r20,0
;		rjmp	REDUCE
;BEGIN:	lds		r16,OCR1AL			;load OCR1AL (Output Compare Register 1 A Low byte) register value into register r16
;		add		r17,r16				;add r16 to r17 (r17 = r17 + r16)
;		lds		r16,OCR1AH			;load OCR1AH (Output Compare Register 1 A High byte) register value into register r16
;		adc		r18,r16				;add r16 to r18 (r18 = r18 + r16) with carry
;		sts		OCR1AH,r18			;store r18 into OCR1AH register (output compare register high byte)								;OCR1AH needs to be updated to change the signal to 120hz, it specifically needs to be moved up to the max and down to the minimum over and over to "breathe"
;		sts		OCR1AL,r17			;store r17 into OCR1AL register (output compare register low byte)
;		cpi		r18,250
;		brsh	RETURN
;		ldi		r20,1
;		reti
;REDUCE:	ldi		r17,0x01
;		ldi		r18,0x01
;		lds		r16,OCR1AL
;		sub		r17,r16
;		lds		r16,OCR1AH
;		sbc		r18,r16
;		sts		OCR1AH,r18
;		sts		OCR1AL,r17
;		cpi		r18,8
;		brlo	RETURN
;		ldi		r20,0
;		reti
;RETURN:	reti

TIM1_COMPB:
		nop			;TC 1 compare match B handler
		reti
TIM1_OVF:
		nop			;TC 1 overflow handler
		reti
TIM0_COMPA:
		nop			;TC 0 compare match A handler
		reti
TIM0_COMPB:			
		nop			;TC 1 compare match B handler
		reti
TIM0_OVF:
		nop			;TC 0 overflow handler
		reti
SPI_TC:
		nop			;SPI Transfer Complete
		reti
USART_RXC:
		nop			;USART receive complete
		reti
USART_UDRE:
		nop			;USART data register empty
		reti
USART_TXC:
		nop			;USART transmit complete
		reti
ADCC:
		nop			;ADC conversion complete
		reti
EE_READY:
		nop			;EEPROM ready
		reti
ANA_COMP:
		nop			;Analog Comparison complete 
		reti
TWI:
		nop			;I2C interrupt handler
		reti
SPM_READY:
		nop			;store program memory ready handler
		reti		

