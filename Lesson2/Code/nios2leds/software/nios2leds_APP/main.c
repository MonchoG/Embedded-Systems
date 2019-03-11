/*
 * PWM on Nios example.
 * (c) Altera & Saxion 2018
 */

#include <altera_avalon_pio_regs.h>
#include <io.h>
#include <stdio.h>
#include <sys/alt_irq.h>
#include <sys/alt_stdio.h>

#define PWM_DIV_REG 0x00
#define PWM_DUT_REG 0x01

int global_edge_capture;
volatile int edge_capture;
int time_sleep = 50e3;

static void handle_key_interrupts(void* context) {
	// Get the pin that has triggered the edge interrupt
	int edge_pin = IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE);

	// To prevent the interrupt from happening again without it being triggered, we need to reset it
	// To do that, we'll write the pin bit to the edge capture register. It will then be reset.
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE, edge_pin);

	// Now we can do whatever we want with the value.
	// We could use the context to set a variable in there, or change a global variable.
	// For this example, let's do both
	// The context we gave was a volatile int. To set the value we need to cast the void pointer to a volatile int pointer
	// And then we can set the value.
	*(volatile int*) context = edge_pin;

	// We can also set a global variable.
	// It is easier to do, but can lead to dirty and buggy code. If you have the chance to avoid it, you should.
	global_edge_capture = edge_pin;

	// To show in the console that an interrupt happened, let's just print the pin bit.
	printf("Interrupt %i\n", edge_pin);
	if (edge_pin == 1 && time_sleep != 0) {
		printf("Before decrement %i\n", time_sleep);
		time_sleep = time_sleep - 10000;
		printf("After decrement %i\n", time_sleep);

	} else if (edge_pin == 2) {
		printf("Before increment %i\n", time_sleep);
		time_sleep = time_sleep + 10000;
		printf("After increment %i\n", time_sleep);
	}
}

static void init() {
	// Init PWM Led
	IOWR(LED_PWM_BASE, PWM_DIV_REG, 0);
	IOWR(LED_PWM_BASE, PWM_DUT_REG, 0);

	alt_putstr("PWM example on Nios II !\n");

	// We first need to enable the interrupts. We have two buttons which are mapped to bit 0 and 1.
	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_PIO_BASE, 0x03);

	// To make sure that the interrupts don't trigger immediately due to randomness,
	// it's better to reset them just to be sure.
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE, 0x03);

	// We can also provide it with a variable, the context.
	// In this example we want it to point to a volatile int in which the triggered pin bit will be saved.	    // The function only takes a void pointer, so we first need to take the address and then cast it to a void pointer.
	void* edge_capture_ptr = (void*) &edge_capture;

	// Now we let the system know what to do when the interrupt happens.
	// It should call the function handle_key_interrupts.
	// Flags don't do anything, so let's just give NULL as value.
	alt_ic_isr_register(KEY_PIO_IRQ_INTERRUPT_CONTROLLER_ID, KEY_PIO_IRQ,
			handle_key_interrupts, edge_capture_ptr, NULL);
	alt_putstr("Button interrupts have been initialized.\n");

}

int main() {
	int j;

	char str[] =
			"Yo listen up, here's the story About a little guy that lives in a blue world And all day ";
	char str2[]= "and all night and everything he sees is just blue Like him, inside and outside";

	printf("\nString for encryption: %s \n %s\n", str, str2);
	for (j = 0; (j < 100 && str[j] != '\0'); j++)
		str[j] = str[j] + 10; //the key for encryption is 3 that is added to ASCII value

	for (j = 0; (j < 100 && str2[j] != '\0'); j++)
			str2[j] = str2[j] + 10; //the key for encryption is 3 that is added to ASCII value

	printf("\nEncrypted string: %s\n %s\n", str, str2);
	printf("===================================\n");

	printf("\nString for decryption: %s \n %s \n", str,str2);

	for (j = 0; (j < 100 && str[j] != '\0'); j++)
		str[j] = str[j] - 10; //the key for encryption is 3 that is subtracted to ASCII value
	for (j = 0; (j < 100 && str2[j] != '\0'); j++)
			str2[j] = str2[j] - 10; //the key for encryption is 3 that is subtracted to ASCII value

	printf("\nDecrypted string: %s\n %s \n", str, str2);

	return 0;
}
