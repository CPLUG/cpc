def submissions(user, args)
   raise NotImplementedError
end

def scoreboard(user, args)
   raise NotImplementedError
end

def grade(user, args)
   raise NotImplementedError
end

def contests(user, args)
   raise NotImplementedError
end

def register(user, args)
   raise NotImplementedError
end

def problems(user, args)
   raise NotImplementedError
end

def help(user, args)
   raise NotImplementedError
end

command = ARGV[0].to_s.strip.downcase
commands = {
   "submissions" => Object.method(:submissions),
   "scoreboard" => Object.method(:scoreboard),
   "grade" => Object.method(:grade),
   "contests" => Object.method(:contests),
   "register" => Object.method(:register),
   "problems" => Object.method(:problems),
   "help" => Object.method(:help)
}

if command.length == 0
   puts 'usage: cpc <command>'
elsif not commands.include? command
   puts "'#{command}' is not a valid command"
else
   Object.method(command).call(ENV['USERNAME'], ARGV[1..-1])
end
