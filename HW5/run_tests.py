import sys, os

os.chdir('./in')
for file_in_input in os.listdir():
        os.system('../a.out < %s > ../out/%s.out' % (file_in_input, file_in_input));


os.chdir('../out')
for file_in_out in os.listdir():
        #os.system('diff -C ../out/%s %s' %(file_in_out,file_in_out))
        os.system('diff ../out/%s %s --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines' % (file_in_out,file_in_out))

        print('----- %s --------\n'%(file_in_out))