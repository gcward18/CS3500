
program:
	flex wardg.l
	bison wardg.y
	g++ wardg.tab.c 

test:
	./a.out < ./input/exprList_noErrors.txt > ./results/exprList_noErrors_results.txt
	diff ./results/exprList_noErrors_results.txt ./output/exprList_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines
	
	./a.out < ./input/lambda_noErrors.txt > ./results/lambda_noErrors_results.txt
	diff ./results/lambda_noErrors_results.txt ./output/lambda_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines
	
	./a.out < ./input/multipleDef.txt > ./results/multipleDef_results.txt
	diff ./results/multipleDef_results.txt ./output/multipleDef.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines
	
	./a.out < ./input/nestedLet_noErrors.txt > ./results/nestedLet_noErrors_results.txt
	diff ./results/nestedLet_noErrors_results.txt ./output/nestedLet_noErrors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines
	
	./a.out < ./input/undef.txt > ./results/undef_results.txt
	diff ./results/undef_results.txt ./output/undef.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines

	./a.out < ./input/nestedLetLambda_Errors.txt > ./results/nestedLetLambda_Errors.txt
	diff ./results/nestedLetLambda_Errors.txt ./output/nestedLetLambda_Errors.txt.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines
		
clean:
	rm ./results/*