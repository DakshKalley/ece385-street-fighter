// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x70; //make a pointer to access the LED PIO block
	//volatile unsigned int *SW = (unsigned int*)0x60; //make a pointer to access the Switches PIO block
	//volatile unsigned int *KEY = (unsigned int*)0x50; //make a pointer to access the Reset PIO block
	//unsigned int sum = 0;
	*LED_PIO = 0; //clear all LEDs

	while ( (1+1) != 3) //infinite loop
		{
			for (i = 0; i < 100000; i++); //software delay
			*LED_PIO |= 0x1; //set LSB
			for (i = 0; i < 100000; i++); //software delay
			*LED_PIO &= ~0x1; //clear LSB
		}

	/*
	unsigned int flag = 0;
	while ( (1+1) != 3){
		if (flag == 0 && *KEY == 0){
			sum += *SW;
			if (sum > 255){
				sum = (sum - 256);
				*LED_PIO = sum;
			}
			flag = 1;
			*LED_PIO = sum;
		}
		if (flag == 1 && *KEY == 1){
			flag = 0;
		}
	}
	*/

	return 1; //never gets here
}
