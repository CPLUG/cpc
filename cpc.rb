#!/usr/bin/env ruby
#change to #!/home/pfaiman/ruby/bin/ruby to prevent tampering with runtime

if __FILE__ != $0
    puts 'Do not include or require this file.'
    exit!
end

$commands_summary = 'The following commands are available:
help           View help text on a command
submissions    View your submissions
scoreboard     View the scoreboard
grade          Check your grade
contests       List running contests
register       Register for the contest
problems       List problems'

$commands = {
    :submissions => 'Usage: cpc submissions

Description
',  :scoreboard  => 'Usage: cpc scoreboard

Description
',  :grade       => 'Usage: cpc grade

Description
',  :contests    => 'Usage: cpc contests

Description
',  :register    => 'Usage: cpc register

Description
',  :problems    => 'Usage: cpc problems

Description
',  :help        => "Usage: cpc help <command>

#{$commands_summary}
"}

def submissions(user, args)
    false
end

def scoreboard(user, args)
    false
end

def grade(user, args)
    false
end

def contests(user, args)
    false
end

def register(user, args)
    false
end

def problems(user, args)
    false
end

def help(user, cmd)
    cmd = cmd.strip.downcase.to_sym unless cmd.kind_of?(Symbol)
    if $commands.include? cmd
        puts $commands[cmd]
        true
    else
        puts "No such command.\n\n#{$commands_summary}"
        false
    end
end

if ARGV[0] == nil
    puts "Usage: cpc <command>\n\n#{$commands_summary}"
else
    cmd = ARGV[0].strip.downcase.to_sym
    ARGV[0] = `/usr/bin/whoami`.strip
    if $commands.include? cmd
        cmd_f = method cmd
        if ARGV.length == cmd_f.arity || cmd_f.arity == -1
            exit(cmd_f.call *ARGV)
        end
    end
    exit(help *[ARGV[0], cmd])
end
