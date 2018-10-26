BASE_NAME="wardg"
INPUT_FILE="$BASE_NAME.tab.c"
OUT_FILE="parser.out"
# FILE="let_good4.txt"
FILE="*.txt"


flex ../bison/$BASE_NAME.l && bison ../bison/$BASE_NAME.y 
g++ ../bison/$INPUT_FILE -o ../$OUT_FILE

find ../input -name "*.txt" | while read filename; do 
    echo `basename $filename`
    ../$OUT_FILE  $filename > out.txt
    diff out.txt ../out/`basename $filename`.out --ignore-space-change --ignore-case --ignore-blank-lines
done;


# ./$OUT_FILE < input/$FILE > out.txt
# # diff --side-by-side out.txt output/$FILE.out
# diff out.txt output/$FILE.out --ignore-space-change --ignore-case --ignore-blank-lines
