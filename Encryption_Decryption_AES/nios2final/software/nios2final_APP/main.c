/*
 * main.c
 *
 *  Created on: Jan 9, 2019
 *      Author: Miroslav & Steff
 */
#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "system.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>   	// for clock_t, clock(), CLOCKS_PER_SEC
#include <unistd.h> 	// for sleep()
#include <string.h>
#include <stdint.h>
#include "aes.h"
#include "altera_avalon_lcd_16207_regs.h"
#define LCD_WR_COMMAND_REG 0
#define LCD_RD_STATUS_REG 1
#define LCD_WR_DATA_REG 2
#define LCD_RD_DATA_REG 3
// Enable ECB, CTR and CBC mode. Note this can be done before including aes.h or at compile-time.
// E.g. with GCC by using the -D flag: gcc -c aes.c -DCBC=0 -DCTR=1 -DECB=1
#define ECB 1
static void phex(uint8_t* str);
static int test_encrypt_ecb(void);
static int test_decrypt_ecb(void);
static void test_encrypt_ecb_verbose();
static void test_decrypt_ecb_verbose();

static uint32_t count;
uint32_t plain_text[64];



/**
 * hex2int
 * take a hex string and convert it to a 32bit number (max 8 hex digits)
 */
int hex2str() {
	 long long the_val = *plain_text;
	 char s[16];
	 sprintf(s, "%lld", the_val);
	 printf("\n");
	 int return_val = atoi(s);
	 return return_val;

}
/**
*lcd_init
*initialize the lcd
*/
void lcd_init( void) {

 usleep(15000); /* Wait for more than 15 ms before init */
 /* Set function code four times -- 8-bit, 2 line, 5x7 mode */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x38);
 usleep(4100); /* Wait for more than 4.1 ms */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x38);
 usleep(100); /* Wait for more than 100 us */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x38);
 usleep(5000); /* Wait for more than 100 us */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x38);
 usleep(100); /* Wait for more than 100 us */

 /* Set Display to OFF*/
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x08);
 usleep(100);

 /* Set Display to ON */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x0C);
 usleep(100);

 /* Set Entry Mode -- Cursor increment, display doesn't shift */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x06);
 usleep(100);

 /* Set the Cursor to the home position */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x02);
 usleep(2000);

 /* Display clear */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x01);
 usleep(2000);
}
/*
*write_lcd
*take a string of the action that is executed
*print int value on 2nd line
*/
alt_u32 write_lcd(char type[], uint32_t val) {

 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x02);
 usleep(2000);
 /* Display clear */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x01);
 usleep(2000);
 int i;
 /* Write a simple message on the first line. */
 for(i = 0; i < 10; i++) {
	 IOWR(LCD_BASE, LCD_WR_DATA_REG,type[i]);
	 usleep(100);
 }
 /* Count along the bottom row */
  /* Set Address */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG,0xC0);
 usleep(1000);
 long long the_val = val;
 int n = 0;
 while ( the_val != 0){
	 the_val /=10;
	++n;
}

 char s[n];
 sprintf(s, "%lu", val);
 printf("\n");
 for(i = 0; i < n; i++) {
	 IOWR(LCD_BASE, LCD_WR_DATA_REG, s[i] );
 	 usleep(100);
  }
 usleep(5000000); /* Wait 0.5 sec */
 /* Display clear */
 IOWR(LCD_BASE, LCD_WR_COMMAND_REG, 0x01);
 usleep(2000);
 return(0);
}

int main(void)
{
	lcd_init();
	int exit;
    count = 1;
    clock_t t;

    int encrypt;
    int decrypt;

#if defined(AES256)
    printf("\nTesting AES256\n\n");
#elif defined(AES192)
    printf("\nTesting AES192\n\n");
#elif defined(AES128)
    printf("\nTesting AES128\n\n");
#else
    printf("You need to specify a symbol between AES128, AES192 or AES256. Exiting");
    return 0;
#endif

    exit = test_decrypt_ecb() + test_encrypt_ecb();

    while (1){

       printf("Reading input \n");
       usleep(1000000);
       count = IORD_ALTERA_AVALON_PIO_DATA (SWITCH_BASE);

       printf("the input in dec is : %lu \n\n", count);

       plain_text[0] =  count ;

       printf("Starting encryption \n\n");
       write_lcd("encrypting", count);
       t = clock();
       test_encrypt_ecb_verbose();
       t = clock() - t;
       encrypt = t;
       printf("Ended encryption \n Clicks spent: %d \n\n", encrypt);
       write_lcd("encrypted", plain_text[0]);
       usleep(30000);

       printf("Beginning decryption \n");
       t = clock();
       test_decrypt_ecb_verbose();
       t = clock() - t;
       decrypt = t;
       printf("Ended decryption \n Clicks spent: %d \n\n", decrypt);

       write_lcd("decrypted", hex2str());
       printf ("It took me %d clicks (%f seconds) to encrypt.\n\n",encrypt,((float)encrypt)/CLOCKS_PER_SEC);
       printf ("It took me %d clicks  to decrypt(%f seconds).\n\n",decrypt,((float)decrypt)/CLOCKS_PER_SEC);

       usleep(30000);


       int i;
       for (i = 0; i <64; i++){
    	   plain_text[i]=0;
       }
       usleep(1000000);
    }

    return exit;
}


// prints string as hex
static void phex(uint8_t* str)
{

#if defined(AES256)
    uint8_t len = 32;
#elif defined(AES192)
    uint8_t len = 24;
#elif defined(AES128)
    uint8_t len = 16;
#endif

    unsigned char i;
    for (i = 0; i < len; ++i)
        printf("%.2x", str[i]);
    printf("\n");
}

/*
* test function for AES 128 encryption
* More verbose example
*/
static void test_encrypt_ecb_verbose()
{
	// 128bit key
    uint8_t key[16] =        { (uint8_t) 0x2b, (uint8_t) 0x7e, (uint8_t) 0x15, (uint8_t) 0x16, (uint8_t) 0x28, (uint8_t) 0xae, (uint8_t) 0xd2, (uint8_t) 0xa6, (uint8_t) 0xab, (uint8_t) 0xf7, (uint8_t) 0x15, (uint8_t) 0x88, (uint8_t) 0x09, (uint8_t) 0xcf, (uint8_t) 0x4f, (uint8_t) 0x3c };

    // print text to encrypt, key and IV
    printf("ECB encrypt verbose:\n\n");
    printf("plain text:\n");

    phex(plain_text);

    printf("\n");

    printf("key:\n");
    phex(key);
    printf("\n");

    // print the resulting cipher as 4 x 16 byte strings
    printf("ciphertext:\n");

    struct AES_ctx ctx;
    AES_init_ctx(&ctx, key);

    AES_ECB_encrypt(&ctx, plain_text);
    phex(plain_text);

    printf("\n");
}
/*
* test function for AES 128 decryption
* More verbose example
*/
static void test_decrypt_ecb_verbose()
{
    // 128bit key
    uint8_t key[16] = { (uint8_t) 0x2b, (uint8_t) 0x7e, (uint8_t) 0x15, (uint8_t) 0x16, (uint8_t) 0x28, (uint8_t) 0xae, (uint8_t) 0xd2, (uint8_t) 0xa6, (uint8_t) 0xab, (uint8_t) 0xf7, (uint8_t) 0x15, (uint8_t) 0x88, (uint8_t) 0x09, (uint8_t) 0xcf, (uint8_t) 0x4f, (uint8_t) 0x3c };

    // print text to decrypt, key and IV
    printf("ECB decrypt verbose:\n\n");
    printf("plain text:\n");

    phex(plain_text);

    printf("\n");

    printf("key:\n");
    phex(key);
    printf("\n");

    // print the resulting cipher as 4 x 16 byte strings
    printf("deciphered text:\n");

    struct AES_ctx ctx;

    AES_init_ctx(&ctx, key);
    AES_ECB_decrypt(&ctx, plain_text);
    printf("%lld \n", (long long)plain_text);
    phex(plain_text);

    printf("\n");
    printf("%lld \n", (long long)plain_text);
}
/*
*testing ecb encryption
*/
static int test_encrypt_ecb(void)
{
#if defined(AES256)
    uint8_t key[] = { 0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
                      0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4 };
    uint8_t out[] = { 0xf3, 0xee, 0xd1, 0xbd, 0xb5, 0xd2, 0xa0, 0x3c, 0x06, 0x4b, 0x5a, 0x7e, 0x3d, 0xb1, 0x81, 0xf8 };
#elif defined(AES192)
    uint8_t key[] = { 0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52, 0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5,
                      0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b };
    uint8_t out[] = { 0xbd, 0x33, 0x4f, 0x1d, 0x6e, 0x45, 0xf2, 0x5f, 0xf7, 0x12, 0xa2, 0x14, 0x57, 0x1f, 0xa5, 0xcc };
#elif defined(AES128)
    uint8_t key[] = { 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c };
    uint8_t out[] = { 0x3a, 0xd7, 0x7b, 0xb4, 0x0d, 0x7a, 0x36, 0x60, 0xa8, 0x9e, 0xca, 0xf3, 0x24, 0x66, 0xef, 0x97 };
#endif

    uint8_t in[]  = { 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a };
    struct AES_ctx ctx;

    AES_init_ctx(&ctx, key);
    AES_ECB_encrypt(&ctx, in);

    printf("ECB encrypt: ");

    if (0 == memcmp((char*) out, (char*) in, 16)) {
        printf("SUCCESS!\n");
	return(0);
    } else {
        printf("FAILURE!\n");
	return(1);
    }
}

/*
*testing ecb decryption
*/
static int test_decrypt_ecb(void)
{
#if defined(AES256)
    uint8_t key[] = { 0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
                      0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4 };
    uint8_t in[]  = { 0xf3, 0xee, 0xd1, 0xbd, 0xb5, 0xd2, 0xa0, 0x3c, 0x06, 0x4b, 0x5a, 0x7e, 0x3d, 0xb1, 0x81, 0xf8 };
#elif defined(AES192)
    uint8_t key[] = { 0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52, 0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5,
                      0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b };
    uint8_t in[]  = { 0xbd, 0x33, 0x4f, 0x1d, 0x6e, 0x45, 0xf2, 0x5f, 0xf7, 0x12, 0xa2, 0x14, 0x57, 0x1f, 0xa5, 0xcc };
#elif defined(AES128)
    uint8_t key[] = { 0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6, 0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c };
    uint8_t in[]  = { 0x3a, 0xd7, 0x7b, 0xb4, 0x0d, 0x7a, 0x36, 0x60, 0xa8, 0x9e, 0xca, 0xf3, 0x24, 0x66, 0xef, 0x97 };
#endif

    uint8_t out[]   = { 0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96, 0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a };
    struct AES_ctx ctx;

    AES_init_ctx(&ctx, key);
    AES_ECB_decrypt(&ctx, in);

    printf("ECB decrypt: ");

    if (0 == memcmp((char*) out, (char*) in, 16)) {
        printf("SUCCESS!\n");
	return(0);
    } else {
        printf("FAILURE!\n");
	return(1);
    }
}
