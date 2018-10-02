import os,sys

os.system("	./a.out < ./input/exprList_noErrors.txt > ./results/exprList_noErrors_results.txt")
os.system("	diff ./results/exprList_noErrors_results.txt ./output/exprList_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines")

os.system("	./a.out < ./input/lambda_noErrors.txt > ./results/lambda_noErrors_results.txt")
os.system("	diff ./results/lambda_noErrors_results.txt ./output/lambda_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines")

os.system("	./a.out < ./input/multipleDef.txt > ./results/multipleDef_results.txt")
os.system("	diff ./results/multipleDef_results.txt ./output/multipleDef.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines")

os.system("	./a.out < ./input/nestedLet_noErrors.txt > ./results/nestedLet_noErrors_results.txt")
os.system("diff ./results/nestedLet_noErrors_results.txt ./output/nestedLet_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines")

os.system("	./a.out < ./input/undef.txt > ./results/undef_results.txt")
os.system("	diff ./results/undef_results.txt ./output/undef.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines")

os.system("	./a.out < ./input/nestedLetLambda_noErrors.txt > ./results/nestedLetLambda_noErrors.txt")
os.system("	diff ./results/nestedLetLambda_noErrors.txt ./output/nestedLetLambda_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines")