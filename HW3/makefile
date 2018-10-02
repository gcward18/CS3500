
program:
	flex wardg.l
	bison wardg.y
	g++ wardg.tab.c 

test:
	python3 run_tests.py	
clean:
	rm ./results/*