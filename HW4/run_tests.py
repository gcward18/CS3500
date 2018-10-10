import sys, os

os.chdir('./HW4_sample_input')
for file_in_input in os.listdir():
    if("if" in file_in_input):
        os.system('../a.out < %s > ../out/%s.out' % (file_in_input, file_in_input)); 
    

os.chdir('../HW4_expected_output')
for file_in_out in os.listdir():
    #os.system('diff -C ../out/%s %s' %(file_in_out,file_in_out))

    if("if" in file_in_out):
        print(file_in_out)
        os.system('diff ../out/%s %s --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines' % (file_in_out,file_in_out)) 
