import os
import sys

def printHelp(exitcode=127):
    '''
    Print the help prompt.
    '''
    print("Syntax: splitfile_length.py <in.txt> <out_length_dir>")
    exit(exitcode)

def main(in_txt, out_length_dir):
    '''
    Split the incoming text into a directory full of files by first letter.
    '''
    # Scan incoming file for max length
    max_length = 0
    with open(in_txt, 'r') as in_fh:
        for word in in_fh:
            if len(word) > max_length:
                max_length = len(word)
    
    # Create output files by length (1...max)
    length_fhs = [None] + [open(os.path.join(out_length_dir, str(i) + '.txt'), 'w') for i in range(1, max_length+1)]
    
    # Deposit words from input into correct output file
    with open(in_txt, 'r') as in_fh:
        for word in in_fh:
            length_fhs[len(word.strip())].write(word)
    
    # Close output files
    for fh in length_fhs[1:]:
        fh.close()


if __name__ == '__main__':
    if len(sys.argv) <= 2:
        printHelp()
    else:
        main(*sys.argv[1:3])
