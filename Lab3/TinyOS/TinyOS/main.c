/*
 * main.c
 *
 * Created: 3/21/2024 3:07:00 PM
 *  Author: coles
 */ 


 // Lab3P1.c
 //
 // 
 // Author : Eugene Rockey
 // 
 
 //no includes, no ASF, no libraries
 
 #include <math.h>
 #include "ftoa.h"
 #define F_CPU 8000000UL
 #include <util/delay.h>
 
 const char MS1[] = "\r\nECE-412 ATMega328PB Tiny OS";
 const char MS2[] = "\r\nby Eugene Rockey Copyright 2022, All Rights Reserved";
 const char MS3[] = "\r\nMenu: (L)CD, (A)DC, (E)EPROM, (U)USART\r\n";
 const char MS4[] = "\r\nReady: ";
 const char MS5[] = "\r\nInvalid Command Try Again...";
 const char MS6[] = "Volts\r";
 const char MS7[] = "Celsius\r";

void LCD_Init(void);			//external Assembly functions
void UART_Init(void);
void UART_Clear(void);
void UART_Get(void);
void UART_Put(void);
void LCD_Write_Data(void);
void LCD_Write_Command(void);
void LCD_Read_Data(void);
void Mega328P_Init(void);
void ADC_Get(void);
void EEPROM_Read(void);
void EEPROM_Write(void);
void EEPROM_WriteAddress(char);
void EEPROM_WriteData(char);

unsigned char ASCII;			//shared I/O variable with Assembly
unsigned char DATA;				//shared internal variable with Assembly
char HADC;						//shared ADC variable with Assembly
char LADC;						//shared ADC variable with Assembly
char EEPROM_Address;
char EEPROM_Data;
float r;
float b;
float r0;
float t0;
float t;
char temp[10];

char volts[5];					//string buffer for ADC output
int Acc;						//Accumulator for ADC use

void UART_Puts(const char *str)	//Display a string in the PC Terminal Program
{
	while (*str)
	{
		ASCII = *str++;
		UART_Put();
	}
}

void LCD_Puts(const char *str)	//Display a string on the LCD Module
{
	while (*str)
	{
		DATA = *str++;
		LCD_Write_Data();
	}
}

void Banner(void)				//Display Tiny OS Banner on Terminal
{
	UART_Puts(MS1);
	UART_Puts(MS2);
	UART_Puts(MS4);
}

void HELP(void)						//Display available Tiny OS Commands on Terminal
{
	UART_Puts(MS3);
}

/*
void LCD(void)						//Lite LCD demo
{
	DATA = 0x01;
	LCD_Write_Command();
	DATA = 0x34;					//Student Comment Here
	LCD_Write_Command();
	DATA = 0x08;					//Student Comment Here
	LCD_Write_Command();
	DATA = 0x02;					//Student Comment Here
	LCD_Write_Command();
	DATA = 0x06;					//Student Comment Here
	LCD_Write_Command();
	DATA = 0x0f;					//Student Comment Here
	LCD_Write_Command();
	LCD_Puts("Hello ECE412!");
}
*/

volatile uint8_t flag = 0; // Volatile to ensure proper access across interrupt handler
// Interrupt Service Routine (ISR) for INT0
ISR(INT0_vect) {
	flag = 1; // Set the flag when the interrupt is triggered
}
sei();
EICRA = 0b00000010; // Interrupt on falling edge
EIMSK = 0b00000001; // Enable INT0

void LCD(void)                        //Lite LCD demo
{
    
    DATA = 0x01;                    // 0b00000001, Clears display
    LCD_Write_Command();
    DATA = 0x34;                    // 0b00110100, Set data bus to 8 bit, 1 line, and font to 5x10
    LCD_Write_Command();
    DATA = 0x08;                    // 0b00001000, Set display cursor and brink off?
    LCD_Write_Command();
    DATA = 0x02;                    // 0b00000010, Return cursor to 0
    LCD_Write_Command();
    DATA = 0x06;                    // 0b00000110, Set cursor shift to increment, and display to not shifted
    LCD_Write_Command();
    DATA = 0x0d;                    // 0b00001111, Set display on, cursor on, brink on.
    LCD_Write_Command();
    LCD_Puts("Hello ECE412!    Hello ECE412!    Hello ECE412!    Hello ECE412!");
	
	while (flag == 0) {
		_delay_ms(1000);
		//Fib(25);                    // Delay shifting
			
		DATA = 0x18;                // 0b00001100, Shift right 1
		LCD_Write_Command();
			
		// Figure out how to stop
	}
    /*
    Re-engineer this subroutine to have the LCD endlessly scroll a marquee sign of 
    your Team's name either vertically or horizontally. Any key press should stop
    the scrolling and return execution to the command line in Terminal. User must
    always be able to return to command line.
    */
}

	/*
	while (1)
	{
		if(ASCII != '\0')        //if it is Q or q,
		{
			_delay_ms(1000.00);
			//Fib(24);                    // Delay shifting
			DATA = 0x01;		//clear board
			LCD_Write_Command();
			_delay_ms(1000.00);
			//Fib(24);                    // Delay shifting
			break;                                //BREAKS
		}
		_delay_ms(1000.00);                //delays
		//Fib(24);                    // Delay shifting
		DATA = 0x18;                //command for shifting display to the right 0x1C
		LCD_Write_Command();        //writes command to the LCD
		_delay_ms(1000.00);
		//Fib(24);                    // Delay shifting
		//UART_Get();
		_delay_ms(1000.00);
		//Fib(24);                    // Delay shifting
	}
	return;
	*/
	
	/*
	while (1) {
		_delay_ms(1000);
		//Fib(25);                    // Delay shifting
		
		DATA = 0x18;                // 0b00001100, Shift right 1
		LCD_Write_Command();
		
		// Figure out how to stop
	}
	*/
//}


void ftoa (float fp,char ch[]);
void ADC(void)						//Lite Demo of the Analog to Digital Converter
{
	ADC_Get();
	Acc = (((float)HADC) * 0x100 + (float)(LADC));
	float r0 = 10000.0;									//r0 constant
	float t0 = 298.15;									//t0 constant
	float b = 3950.0;									//b constant
	float r;
	float t;
	r = 10000.0 * Acc / (1024.0 - Acc);
	t = b * t0 / (t0 * log(r/r0) + b);
	t = t - 273.15;
	t = t * 9.0/5.0 + 32.0;
	ftoa(t, temp);
	UART_Puts(temp);
	
	/*
		Re-engineer this subroutine to display temperature in degrees Fahrenheit on the Terminal.
		The potentiometer simulates a thermistor, its varying resistance simulates the
		varying resistance of a thermistor as it is heated and cooled. See the thermistor
		equations in the lab 3 folder. User must always be able to return to command line.
	*/
}

void EEPROM_WriteAddress(char addy)
{
	EEPROM_Address = addy;
}

void EEPROM_WriteData(char dater)
{
	EEPROM_Data = dater;
}

void EEPROM(void)
{
	//UART_Puts("\r\nEEPROM Write and Read.");
	/*
	Re-engineer this subroutine so that a byte of data can be written to any address in EEPROM
	during run-time via the command line and the same byte of data can be read back and verified after the power to
	the Xplained Mini board has been cycled. Ask the user to enter a valid EEPROM address and an
	8-bit data value. Utilize the following two given Assembly based drivers to communicate with the EEPROM. You
	may modify the EEPROM drivers as needed. User must be able to always return to command line.
	*/
	/*
	UART_Puts("Enter valid EEPROM address to store 8-bit data (use . for enter)\r");
	ASCII = '\0';
	while (ASCII == '\0')
	{
		UART_Get();
	}
	UART_Puts("Enter valid 8-bit data\r");
	*/
	
	
	
	UART_Puts("(w) to write, (r) to read\r\n");
	UART_Get();
	char input = ASCII;

	if(input == 'w'){
		UART_Puts("Enter desired EEPROM address");
		UART_Puts("\r\n");
		UART_Get();
		EEPROM_WriteAddress(ASCII);
		UART_Puts("Enter data to be stored");
		UART_Puts("\r\n");
		UART_Get();
		EEPROM_WriteAddress(ASCII);
		EEPROM_Write();
	}
	if(input == 'r'){
		UART_Puts("\r\n");
		UART_Puts("What address do you want to read from?");
		UART_Puts("\r\n");
		UART_Get();
		EEPROM_WriteAddress(ASCII);
		EEPROM_Read();
		UART_Put();
		UART_Puts("\r\n");
	}
	
	
	
	
	/*
	UART_Puts("\r\n");
	EEPROM_Write();
	UART_Puts("\r\n");
	EEPROM_Read();
	UART_Put();
	UART_Puts("\r\n");
	*/
}

void USART_Init(void)
{
	/*
	//Set baud rate
	UBRR0H = (unsigned char)(ubrr>>8);
	UBRR0L = (unsigned char)ubrr;
	//Enable receiver and transmitter
	UCSR0B = (1<<RXEN0)|(1<<TXEN0);
	//Set frame format: 8data, 2stop bit
	UCSR0C = (1<<USBS0)|(3<<UCSZ00);
	UART_Puts("Baud rate changed to 9000");	
	*/
}

// Function to initialize USART0 with a specific baud rate
/*
void USART_Init(unsigned int baud_rate) {
	// Calculate the baud rate value from the given baud rate
	int F_CPU = 8000000;
	unsigned int baud_rate_value = F_CPU / (16 * baud_rate) - 1;

	// Set baud rate registers (UBRR0H and UBRR0L)
	UBRR0H = (unsigned char)(baud_rate_value >> 8);
	UBRR0L = (unsigned char)baud_rate_value;

	// Enable receiver and transmitter
	UCSR0B = (1 << RXEN0) | (1 << TXEN0);

	// Set frame format: 8 data bits, no parity, 1 stop bit
	UCSR0C = (1 << UCSZ01) | (1 << UCSZ00); // 8 data bits
}
*/

void Command(void)					//command interpreter
{
	UART_Puts(MS3);
	ASCII = '\0';						
	while (ASCII == '\0')
	{
		UART_Get();
	}
	switch (ASCII)
	{
		case 'L' | 'l': LCD();
		break;
		case 'A' | 'a': ADC();
		break;
		case 'E' | 'e': EEPROM();
		break;
		case 'U' | 'u': USART_Init();
		break;
		default:
		UART_Puts(MS5);
		HELP();
		break;  			
//Add a 'USART' command and subroutine to allow the user to reconfigure the 						
//serial port parameters during runtime. Modify baud rate, # of data bits, parity, 							
//# of stop bits.
	}
}

int main(void)
{
	Mega328P_Init();
	Banner();
	while (1)
	{
		Command();				//infinite command loop
	}
}	
