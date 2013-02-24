#!/usr/bin/env ruby

require 'pathname'

#This really should be defined elsewhere...
$problem_loc = '/home/michael/cpc/Problems'
$active_competition = 'W12'
$cpc_loc = '/home/michael/cpc'
$max_filesize = 2560

puts Process::Sys.geteuid
puts Process::Sys.getuid

if ARGV.length != 2
    puts 'wtf are you doing?'
    exit false
end

user = `/usr/bin/whoami`.strip
problem = File.basename(ARGV[0])
fileName = File.basename(ARGV[1])
problem_dir = "#{$problem_loc}/#{$active_competition}/#{problem}"

if !File.directory?(problem_dir)
    puts 'wtf are you doing?'
    exit false
end


user_dir = "#{$problem_loc}/#{$active_competition}/#{problem}/submissions/queued/#{user}"
if !File.directory?(user_dir)
    Dir.mkdir(user_dir)
end

file_path = "#{$problem_loc}/#{$active_competition}/#{problem}/submissions/queued/#{user}/#{fileName}"

#TODO: File size check?
File.open(file_path, 'w') {|f| f.write(STDIN.read($max_filesize))}
