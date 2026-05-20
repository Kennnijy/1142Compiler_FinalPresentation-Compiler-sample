# Compiler-sample
Compiler sample

請先git以下這兩個自動安裝與執行腳本擋(*.sh)：  
wget https://github.com/Kennnijy/1142Compiler_FinalPresentation-Compiler-sample/blob/main/setup_compiler.sh   
wget https://github.com/Kennnijy/1142Compiler_FinalPresentation-Compiler-sample/blob/main/run_pipeline.sh


使用 sed 指令直接把 Windows 的 \r 拔掉 
(在終端機分別輸入這兩行指令，直接用 Linux 的流編輯器把檔案裡的 Windows 換行符號清洗乾淨)：
sed -i 's/\r$//' setup_compiler.sh    
sed -i 's/\r$//' run_pipeline.sh
