void delay(int seconds) {
    // Assuming 100 million cycles per second for a 100 MHz clock
    volatile unsigned long int count;
    unsigned long int delay_count = 100000000 * seconds;

    for (count = 0; count < delay_count; count++) {
        // Busy-wait loop
    }
}

int main() {
    // Define a boolean type
    typedef enum { false, true } bool;

    // Assume the LEDS address is at 0x03000000
    volatile bool *LEDS = (volatile bool*) 0x03000000;

    // Loop to set each LED with a delay
    for (int i = 0; i < 10; i++) {
        LEDS[i] = true; // Turn on LED
        delay(1); // 1 second delay
    }

    return 0;
}