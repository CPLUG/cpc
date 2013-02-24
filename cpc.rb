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
$active_competition = 'W12'
$cpc_loc = '/home/michael/cpc'

$commands_summary = 'The following commands are available:
help           View help text on a command
submit         View your submissions
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
',  :submit       => 'Usage: cpc submit <problem>

Description
',  :contests    => 'Usage: cpc contests [-a]

Description
',  :register    => 'Usage: cpc register

Description
',  :problems    => 'Usage: cpc problems

Description
',  :help        => "Usage: cpc help <command>

#{$commands_summary}
"}

def submit(user, args)
    problem = File.basename(args.shift)
    problem_dir = "#{$problem_loc}/#{$active_competition}/#{problem}"
    
    if !problem
        puts 'Must specify problem.'
        false
    elsif !File.directory?(problem_dir)
        puts "Invalid problem: #{problem}"
        false
    else
        args.each do |fileName|
            # How paranoid do we want to be for now...
            system("cat #{fileName} | #{$cpc_loc}/fancyCat #{problem} #{fileName}")
        end
        
        submission = "#{$problem_dir}/submissions/queued/#{user}/*"
        puts "Submitted files quened to be graded for problem #{problem}:"
        puts Dir[submission].map{|path| File.basename(path)}.join(' ')
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
