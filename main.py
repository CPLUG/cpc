#!/usr/bin/python
#TODO: Prober shebang

import sys

def activeContest():
    pass

def submit(args):
    print('Submit: '+','.join(args))
#TODO: How to handle permissions/setuid?

def submissions(args):
    print('Submissions: '+','.join(args))

def scoreboard(args):
    
    print('Scoreboard: '+','.join(args))

def grade(args):
    print('Grade: '+','.join(args))

def contests(args):
    print('Contests: '+','.join(args))

def register(args):
    print('Register: '+','.join(args))

def problems(args):
    print('Problems: '+','.join(args))

def info(args):
    print('Info: '+','.join(args))


class Command:
    def __init__(self, names, usage, handler):
        self.names = names
        self.usage = usage
        self.handler = handler

commands = (
    Command(['submit', 'turnin', 'handin'], '[contest] file...', submit),
    Command(['submissions'], '[user]', submissions),
    Command(['scoreboard', 'scores', 'leaderboard', 'leaders'], '[contest]', scoreboard),
    Command(['grade'], '', grade),
    Command(['contests', 'competitions'], '[-a]', contests),
    Command(['register'], '', register),
    Command(['problems'], '[contest]', problems),
    Command(['help', 'info', '?'], '', info),
)

def printUsage():
    print('Usage: cpc <command>')
    print('Available commands are:')
    for command in commands:
        print('\t'+command.names[0]+' '+command.usage)
    print('Errors, bug reports, feature requests, etc may be reported to OMGTallMonster in #cplug on irc.freenode.net')

if __name__ == '__main__':
    if len(sys.argv) < 2:
        printUsage()
        exit(-1)
    
    for command in commands:
        if sys.argv[1] in command.names:
            command.handler(sys.argv[2:])
            exit(0)
    
    printUsage()
    exit(-1)
