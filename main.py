#!/usr/bin/python
#TODO: Prober shebang

import sys

def submit(args):
    print("Submit: "+','.join(args))

def submissions(args):
    print("Submissions: "+','.join(args))

def scoreboard(args):
    print("Scoreboard: "+','.join(args))

def grade(args):
    print("Grade: "+','.join(args))


class Command:
    def __init__(self, names, usage, handler):
        self.names = names
        self.usage = usage
        self.handler = handler

commands = (
    Command(["submit", "turnin", "handin"], "[contest] file...", submit),
    Command(["submissions"], "[user]", submissions),
    Command(["scoreboard", "scores", "leaderboard", "leaders"], "[contest]", scoreboard),
    Command(["grade"], "", grade),
)

def printUsage():
    print("Usage: cpc <command>")
    print("Available commands are:")
    for command in commands:
        print("\t"+command.names[0]+" "+command.usage)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        printUsage()
        exit(-1)
    for command in commands:
        if sys.argv[1] in command.names:
            command.handler(sys.argv[2:])
            break
    
