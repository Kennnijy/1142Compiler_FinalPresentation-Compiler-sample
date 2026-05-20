#!/bin/bash
# 修正：#!/bin/bash 必須放在檔案的最頂端第一行

# 切換到專案資料夾
cd ~/final/1142Compiler_FinalPresentation-Compiler-sample/

# 只限定測試固定檔名 sample5
FILE_NAME="sample5"

echo "=========================================="
echo "🚀 開始執行編譯鏈流水線，目前目標檔案: ${FILE_NAME}.c"
echo "=========================================="

# 1. 先用自製編譯器測試讀取
echo "[步驟 1/8] 使用自製編譯器讀取 sample5.c..."
if [ -f "sample5.c" ]; then
    ./Compile < "sample5.c"
else
    echo "❌ 錯誤：找不到 sample5.c 檔案，請確認檔案是否存在！"
    exit 1
fi

# 2. 安裝 LLVM 與 Clang 後端工具
echo "[步驟 2/8] 檢查並安裝 Clang 與 LLVM..."
sudo apt-get install clang llvm -y

# 3. 顯示版本資訊
echo "[步驟 3/8] 檢查編譯器版本..."
clang --version
llc --version

# 4. 產生 LLVM IR 中間碼 (.ll)
echo "[步驟 4/8] 正在將 C 碼轉為 LLVM IR 中間碼..."
clang -S -emit-llvm "${FILE_NAME}.c"

# 5. 進行 LLVM 最佳化 (修正：配合 Ubuntu 18.04 的 LLVM 6.0 舊版 opt 語法)
echo "[步驟 5/8] 正在使用 opt 進行 mem2reg 最佳化..."
opt -S -passes='globalopt,loop-simplify,mem2reg' "${FILE_NAME}.ll"

# 6. 將最佳化後的中間碼轉為組合語言 (.s)
echo "[步驟 6/8] 正在使用 llc 將中間碼轉為 x86 組合語言..."
llc "${FILE_NAME}.ll" -o "${FILE_NAME}.s"

# 7. 將組合語言組譯成目的檔 (.o)
echo "[步驟 7/8] 正在使用 GNU As組譯器生成 ${FILE_NAME}.o..."
as "${FILE_NAME}.s" -o "${FILE_NAME}.o"

# 8. 使用手動 ld 核心連結（方法二），並直接執行最終產出的執行檔
echo "[步驟 8/8] 正在手動使用 ld 連結 C 語言標準庫..."
ld -o "${FILE_NAME}_ex" \
   -dynamic-linker /lib64/ld-linux-x86-64.so.2 \
   /usr/lib/x86_64-linux-gnu/crt1.o \
   /usr/lib/x86_64-linux-gnu/crti.o \
   "${FILE_NAME}.o" \
   -lc \
   /usr/lib/x86_64-linux-gnu/crtn.o

echo "=========================================="
echo "🎉 連結成功！正在直接執行產出的程式 ${FILE_NAME}_ex："
echo "------------------------------------------"
./"${FILE_NAME}_ex"
echo "------------------------------------------"
echo "=========================================="
