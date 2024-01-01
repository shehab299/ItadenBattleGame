:: =========================================================
:: Author: Amir Anwar
:: This is a batch file to compile and run x86 assembly code
:: =========================================================
echo off

:: Clean files
echo "=================================="

cd ../

DEL *.MAP
DEL *.OBJ
DEL *.EXE


:: Compile
echo "=================================="
echo "Compile"
TASM *.ASM

:: LINKING (IMPORTANT)
echo "=================================="
echo "Linking"
TLINK chooseCh.obj+UI.obj

:: YOU HAVE TO SPECIFY THE FILES MANULAAY TILL NOW
:: YOU CAN'T SAY TLINK *.OBJ 
:: IF YOU FOUND ANOTHER WAY LET US KNOW

:: Run
chooseCh.EXE

:: Clean files Silently you can remove this part
:: completely if you want it is not required
DEL *.MAP
DEL *.OBJ
DEL *.EXE