import subprocess
import time
import difflib
import sys
import os

from string import rstrip


def run(command, infile_path, timeout=10):
    '''
    Runs a command and redirects in the contents of the file from the given
    path. If the command is done executing by the end of the timeout (seconds),
    the output will be returned, otherwise the command will be terminated and 
    return False.
    '''
    infile = open(infile_path, 'r')
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stdin=infile,
            stderr=subprocess.PIPE)
    infile.close()
    fintime = time.time() + timeout
    while p.poll() == None and fintime > time.time():
        time.sleep(1)
    if fintime < time.time():
        p.kill()
        return False
    stdout = p.communicate()[0]
    return stdout


def split_clean(string):
    '''
    Splits a string by \n and removes any trailing whitespace from each line 
    '''
    return [i + '\n' for i in map(rstrip, string.split('\n'))[:-1]]


def save(to_save, dest, flag='a+'):
    '''
    Save the list of lines at the given destination
    '''
    new_file = open(dest, flag)
    new_file.writelines(to_save)
    new_file.close()


def diff(a, b):
    '''
    Returns a comparison of the two list of lines 
    '''
    differ = difflib.Differ()
    return differ.compare(a,b)


def get_tests():
    '''
    Get a list of all the test input data from the .in directory
    '''
    return os.listdir('.in')


if __name__ == '__main__':
    for test in get_tests():
        out = run(['sh', 'run.sh'], '.in/'+test)
        if not out:
            sys.exit(1)
        out_lines = split_clean(out)
        save(out_lines, '/tmp/mlekande/'+sys.argv[1]+'-'+test)
        expected = open('.out/'+test, 'r')
        expected_lines = expected.readlines()
        expected.close()
        if expected_lines != out_lines:
            diff_output = diff(expected_lines, out_lines)
            save(diff_output, '/tmp/mlekande/'+sys.argv[1]+'-'+test+'-diff')
            sys.exit(1)
