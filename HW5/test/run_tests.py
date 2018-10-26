import sys, os


os.chdir('../input')
for file_in_input in os.listdir():
        print('------------- %s ---------------------'%(file_in_input))
        os.system('../bison/a.out < %s > ../results/%s.out' % (file_in_input, file_in_input));
        os.system('diff ../results/%s.out ../out/%s.out --ignore-space-change --side-by-side --ignore-case --ignore-blank-lines' % (file_in_input,file_in_input))
