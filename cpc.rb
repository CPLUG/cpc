#!/usr/bin/env ruby
#change to #!/home/pfaiman/ruby/bin/ruby to prevent tampering with runtime

require 'rubygems'
require 'bundler/setup'

require 'pathname'

require 'sqlite3'


if __FILE__ != $0
    puts 'Do not include or require this file.'
    exit!
end

#This really should be defined elsewhere...
$problem_loc = '/home/michael/cpc/Problems'
$active_contest = 'W12'
$cpc_loc = '/home/michael/cpc'

$commands_summary = 'The following commands are available:
help           View help text on a command
submit         Add a new submission
submissions    View your graded submissions
scoreboard     View the scoreboard
contests       List running contests
problems       List problems
grade          Grade submissions (internal only)'

$commands = {
    :submissions => 'Usage: cpc submissions [-c contest] [-u user]

Lists all submissions made by the specified user, or the current user if none is specified.

The -c flag filters submissions to include only those made in the specified contest.
',  :scoreboard  => 'Usage: cpc scoreboard [-c contest] [-a]

Gives the scoreboard for the specified contest, or the default contest if none is specified.

The -a flag will cause this command to factor in results from submissions made after the contest has ended.
',  :grade       => 'Usage: cpc grade

Runs the grader on all submissions in the queue.

For internal use only.
',  :submit       => 'Usage: cpc submit <problem> <file...>

Submits files to the specified problem.
',  :contests    => 'Usage: cpc contests [-a]

By default, lists all active contests. The default contest will be followed by an asterisk (*).

The default contest is the contest that has last started, and has not yet finished.

The -a flag will cause this command to display all contests, including those that have already ended and those that haven\' started yet.
',  :problems    => 'Usage: cpc problems [-c contest]

Lists all problems for the specified contest, or the default contest if none is specified.

Unsolved problems will be followed by an asterisk (*).
',  :help        => "Usage: cpc help [command]

#{$commands_summary}
"}

def submit(user, args)
    problem = File.basename(args.shift)
    problem_dir = "#{$problem_loc}/#{$active_contest}/#{problem}"
    
    if !problem
        puts 'Must specify problem.'
        false
    elsif !File.directory?(problem_dir)
        puts "Invalid problem: #{problem}"
        false
    elsif args.length == 0
        puts 'No files specified'
        false
    else
        args.each do |file|
            # How paranoid do we want to be for now...
            puts "Submitting #{file}... "
            system("cat #{file} | #{$cpc_loc}/fancyCat #{$active_contest} #{problem} #{file}")
        end
        true
    end
end

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
    in_name = args[0]
    prob_names = {}

    Dir['Problems/W12/*'].each do |path|
        name = Pathname.new(path).basename.to_s.split('.').first
        prob_names[name] = path
    end

    if prob_names.keys.include? in_name
        File.open(prob_names[in_name]) do |prob_file|
            while line = prob_file.gets do
                puts line
            end
        end
    else
        puts 'Available problems: ' + prob_names.keys.join(', ')
    end

    true
end

def help(user, args)
    if args.length == 1
        cmd = args[0].strip.downcase.to_sym
        puts $commands[cmd]
        true
    else
        puts $commands[:help]
        false
    end
end

if ARGV[0] == nil
    puts "Usage: cpc <command>\n\n#{$commands_summary}"
else
    cmd = ARGV[0].strip.downcase.to_sym
    user = `/usr/bin/whoami`.strip
    if $commands.include? cmd
        cmd_f = method cmd
        exit(cmd_f.call(user, ARGV[1..-1]))
    else
        puts "No such command.\n\n#{$commands_summary}"
        exit(false)
    end
end
