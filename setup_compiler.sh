#!/bin/bash

echo "=========================================="
# 1. 更新 Ubuntu 系統
echo "[步驟 1/5] 正在更新 Ubuntu 系統..."
sudo apt update -y

# 2. 安裝 Lex (Flex) 與 Yacc (Bison)
echo "[步驟 2/5] 正在安裝 flex 與 bison..."
sudo apt-get install flex -y
sudo apt-get install bison -y

# 3. 建立並進入 final 資料夾
echo "[步驟 3/5] 正在建立並進入 final 資料夾..."
mkdir -p final && cd final

# 4. Clone 報告書專案
echo "[步驟 4/5] 正在從 GitHub 下載編譯器專案..."
git clone https://github.com/Kennnijy/1142Compiler_FinalPresentation-Compiler-sample.git
cd 1142Compiler_FinalPresentation-Compiler-sample

# 5. 編譯 Lex 與 Yacc 產生自製編譯器
echo "[步驟 5/5] 正在生成自製編譯器 (Compile)..."
lex lex.l
yacc -d yacc.y  # 修正：補上報告書中提到的 .y 檔名

cc lex.yy.c y.tab.c -o Compile

echo "=========================================="
echo "🎉 批次檔一執行完畢！自製編譯器 Compile 已成功建置！"
echo "=========================================="
