import os
import sys

def printHelp(exitcode=127):
    '''
    Print the help prompt.
    '''
    print("Syntax: splitfile_alpha.py <in.txt> <out_alpha_dir>")
    exit(exitcode)

def main(in_txt, out_alpha_dir):
    '''
    Split the incoming text into a directory full of files by first letter.
    '''
            
    # Create output files by first letter
    letter_fhs = {}
    for c in 'abcdefghijklmnopqrstuvwxyz':
        letter_fhs[c] = open(os.path.join(out_alpha_dir, c + '.txt'), 'w')
    
    # Deposit words from input into correct output file
    with open(in_txt, 'r') as in_fh:
        for word in in_fh:
            letter_fhs[word[0]].write(word)
    
    # Close output files
    for fh in letter_fhs.values():
        fh.close()


if __name__ == '__main__':
    if len(sys.argv) <= 2:
        printHelp()
    else:
        main(*sys.argv[1:3])
