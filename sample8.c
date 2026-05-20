int printf(const char *format, ...);

int main() {
    int n;
    int steps;
    
    n = 26;
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




bison                              (yyparse)
  bas.y ─────────────────► [ yacc ] ─────────────────────► y.tab.c ──────┐
                             │                                           │
                             ▼ (產生標頭檔)                               │
                          y.tab.h                                        │
                             │                                           │
                             ▼ (引入定義)                                 ▼
  bas.l ─────────────────► [ lex ] ──────────────────────► lex.yy.c ────► [ cc ] ──► Compile
               flex                               (yylex)                │
                                                                         │
 ┌───────────────────────────────────────────────────────────────────────┘
 │ (測試原始碼)
 ▼
source.c ──► [ ./Compile ] ──► (語法檢查) ──► [ Clang/LLVM ] ──► [ ld ] ──► 可執行檔 (Output)
