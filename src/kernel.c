#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

// Kernel constants
#define ROWS 25
#define COLS 80
#define MEM_PTR 0xB8000

size_t row;
size_t col;
char* mem;

void init_terminal() {
    row = 0;
    col = 0;
    mem = (char*) MEM_PTR;
}

void put_char(char c, size_t y, size_t x, uint8_t bg, uint8_t fg) {
    size_t idx = (y * COLS + x) * 2;
    mem[idx] = c;
    mem[idx + 1] = bg | fg;
}

size_t len(char* str) {
    size_t index = 0;
    while (str[index]) {
        index++;
    }
    return index;
}

void print_at(char* str, size_t y, size_t x, uint8_t bg, uint8_t fg) {
    for (size_t i = 0; i < len(str); i++) {
        put_char(str[i], y, x + i, bg, fg);
    }
}

int main() {
    // Initialize terminal
    init_terminal();

    for (int r = 0; r < COLS; r++) {
        for (int c = 0; c < ROWS; c++) {
            mem[(r + COLS * c) * 2] = '~';
        }
    }
    char* str = "ZONAL";
    print_at(str, ROWS/2, COLS/2 - len(str)/2, 0x00, 0x0F);
    
    return 0;
}