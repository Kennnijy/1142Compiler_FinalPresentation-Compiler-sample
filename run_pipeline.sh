#!/bin/bash

# 切換到專案資料夾
cd ~/final/1142Compiler_FinalPresentation-Compiler-sample/

echo "=========================================="
echo " 歡迎使用第 13 組編譯器專題流水線"
echo "=========================================="

# 1. 讓使用者選擇 sample 1 ~ sample 8
while true; do
    read -p "請輸入想要測試的編譯號碼 (1 ~ 8): " NUM
    # 檢查輸入是否為 1 到 8 的單一數字
    if [[ "$NUM" =~ ^[1-8]$ ]]; then
        FILE_NAME="sample${NUM}"
        break
    else
        echo "❌ 輸入錯誤！請輸入 1 到 8 之間的有效數字。"
    fi
done

echo "=========================================="
echo "🚀 開始執行編譯鏈流水線，目前目標檔案: ${FILE_NAME}.c"
echo "=========================================="

# 2. 檢查檔案是否存在，並使用自製編譯器進行「語法錯誤檢查」
echo "[步驟 1/8] 使用自製編譯器讀取 ${FILE_NAME}.c..."
if [ ! -f "${FILE_NAME}.c" ]; then
    echo "❌ 錯誤：找不到 ${FILE_NAME}.c 檔案，請確認檔案是否存在！"
    exit 1
fi

# 執行自製編譯器，並同時檢查輸出內容是否包含 "syntax error"
COMPILE_OUTPUT=$(./Compile < "${FILE_NAME}.c" | tee /dev/stderr)

if echo "$COMPILE_OUTPUT" | grep -iq "syntax error"; then
    echo ""
    echo "**************************************************"
    echo "🛑 警示：偵測到 ${FILE_NAME}.c 檔案有【語法錯誤】！"
    echo "❌ 程式有問題，流水線已安全攔截並中斷！"
    echo "**************************************************"
    exit 1 
fi

echo "✅ 語法檢查通過！繼續執行後端優化與編譯流程..."
echo "------------------------------------------"


# 3. 安裝 LLVM 與 Clang 後端工具
echo "[步驟 2/8] 檢查並安裝 Clang 與 LLVM..."
sudo apt-get install clang llvm -y

# 4. 顯示版本資訊
echo "[步驟 3/8] 檢查編譯器版本..."
clang --version
llc --version

# 5. 產生 LLVM IR 中間碼 (.ll)
echo "[步驟 4/8] 正在將 C 碼轉為 LLVM IR 中間碼..."
clang -S -emit-llvm "${FILE_NAME}.c"

# 6. 進行 LLVM 最佳化 (乾淨舊版語法，不含任何 [cite] 雜訊)
echo "[步驟 5/8] 正在使用 opt 進行 mem2reg 最佳化..."
opt -S -passes='globalopt,loop-simplify,mem2reg' "${FILE_NAME}.ll"

# 7. 將最佳化後的中間碼轉為組合語言 (.s)
echo "[步驟 6/8] 正在使用 llc 將中間碼轉為 x86 組合語言..."
llc "${FILE_NAME}.ll" -o "${FILE_NAME}.s"

# 8. 將組合語言組譯成目的檔 (.o)
echo "[步驟 7/8] 正在使用 GNU As組譯器生成 ${FILE_NAME}.o..."
as "${FILE_NAME}.s" -o "${FILE_NAME}.o"

# 9. 使用手動 ld 核心連結
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
