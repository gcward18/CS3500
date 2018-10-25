
program:
	flex wardg.l
	bison wardg.y
	g++ wardg.tab.c 

test:
	python3 run_tests.py
test2:
	python3 test2.py	
clean:
	rm ./results/*