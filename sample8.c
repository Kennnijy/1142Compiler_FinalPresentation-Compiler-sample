int printf(const char *format, ...);

int main() {
    int n;
    int steps;
    
    n = 27;
    steps = 0;

    while (n != 1) {
        if (n % 2 != 0) {
            n = 3 * n + 1;
        } else {
            n = n / 2;
        }
        steps = steps + 1;
    }
    printf("%d\n", steps);
    return 0;
}
