#!/usr/bin/env ruby
#change to #!/home/pfaiman/ruby/bin/ruby to prevent tampering with runtime

require 'getoptlong'
require 'sqlite3'
require 'date'

require './src/db.rb'
require './config.rb'

if __FILE__ != $0
    puts 'Do not include or require this file.'
    exit!
end

$commands_summary =
    "The following commands are available:\n"\
    "help           View help text on a command\n"\
    "submit         Add a new submission\n"\
    "submissions    View your graded submissions\n"\
    "scoreboard     View the scoreboard\n"\
    "contests       List running contests\n"\
    "problems       List problems\n"\
    "grade          Grade submissions (internal only)"

$commands = {
    :submissions =>
        "Usage: cpc submissions [-c contest] [-u user]\n"\
        "Lists all graded submissions made by the specified user, or the current user if none is specified.\n"\
        "The -c flag filters submissions to include only those made in the specified contest.",
    :scoreboard =>
        "Usage: cpc scoreboard [-c contest] [-a]\n"\
        "Gives the scoreboard for the specified contest, or the default contest if none is specified.\n"\
        "The -a flag will cause this command to factor in results from submissions made after the contest has ended.\n",
    :grade =>
        "Usage: cpc grade\n"\
        "Runs the grader on all submissions in the queue.\n"\
        "For internal use only.",
    :submit =>
        "Usage: cpc submit <problem> <file...>\n"\
        "Submits files to the specified problem.\n",
    :contests =>
        "Usage: cpc contests [-a]\n"\
        "By default, lists all active contests. The default contest will be followed by an asterisk (*).\n"\
        "The default contest is the contest that has last started, and has not yet finished.\n"\
        "The -a flag will cause this command to display all contests, including those that have already ended and those that haven't started yet.\n",
    :problems =>
        "Usage: cpc problems [-c contest]\n"\
        "Lists all problems for the specified contest, or the default contest if none is specified.\n"\
        "Unsolved problems will be followed by an asterisk (*).\n",
    :help =>
        "Usage: cpc help [command]\n" + $commands_summary
}

def contest_dir(contest=default_contest)
    File.join($problem_loc, contest)
end

def problem_dir(problem)
    File.join($problem_loc, $default_contest, problem)
end

def problem_list(contest=$default_contest)
    contests_paths = File.join(contest_dir(contest), "*")
    Dir[contests_paths].map do |contest_abs_path|
        File.basename(contest_abs_path)
    end
end

def submission_dir(problem, user="")
    File.join(problem_dir(problem), "submissions", "queued", user)
end

def submit(user, args)
    problem = args.shift
    if problem
        problem = File.basename(problem)
    end

    problem_dir = problem_dir(problem)

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
            system("cat #{file} | #{$fancycat_loc} #{$default_contest} #{problem} #{file}")
        end
        true
    end
end

def error_string(error_id)
    return 'ID10T_ERROR'
end

def submissions(user, args)
    contest = $default_contest
    sql = 'SELECT problem.name, time, status, errorId, score
        FROM submission
        JOIN problem ON problem.id = submission.problem
        JOIN contest ON contest.id = problem.contest
    WHERE user = ? AND contest.alias = ?'

    opts = GetoptLong.new(
        ['--user', '-u', GetoptLong::REQUIRED_ARGUMENT],
        ['--contest', '-c', GetoptLong::REQUIRED_ARGUMENT]
    )

    opts.each do |opt, arg|
        case opt
            when '--user'
                user = arg
            when '--contest'
                contest = arg
        end
    end

    db = SQLite3::Database.new 'cpc.db'
    db.execute(sql, user, contest) do |row|
        printf("%-15s %-50s %s %s", row[0], DateTime.strptime(row[1],"%s").strftime("%H:%M %Y/%m/%d"), status, status == "SUCCESS" ? row[2] : error_string(row[3]));
    end
    true
end

def scoreboard(user, args)
    false
end

def compile(file_path) 
    dirname = File.dirname(file_path)
    filename = File.basename(file_path)
    fileext = File.extname(file_path)

    command = {
        ".c" => "gcc #{filename}",
        ".cpp" => "g++ #{filename}",
        ".java" => "javac #{filename}",
        ".sh" => "chmod +x #{filename}",
    }[fileext]

    if command
        system("cd #{dirname} && #{command}")
    end

    true
end

def run(file_path, in_file_path)
    dirname = File.dirname(file_path)
    fileext = File.extname(file_path)
    basename = File.basename(file_path, fileext)

    in_file_dirname = File.dirname(in_file_path)
    in_file_basename = File.basename(in_file_path, ".in")
    out_file_path = File.join(dirname, in_file_basename + ".out")
    expected_out_path = File.join(in_file_dirname, in_file_basename + ".out")

    command = {
        ".c" => "./a.out",
        ".cpp" => "./a.out",
        ".java" => "java #{basename}",
        ".pl" => "perl #{file_path}",
        ".py" => "python #{file_path}",
        ".rb" => "ruby #{file_path}",
        ".sh" => "./#{file_path}",
    }[fileext]

    if !command
        puts "Your language is not supported, or unknown file extension"
        return false
    end

    system("cd #{dirname} && #{command} < #{in_file_path} > #{out_file_path}")
    system("diff -b #{expected_out_path} #{out_file_path} > /dev/null")
end

def move_submission(old_file, graded_dir)
    user = File.basename(submission)
    index = (1..1.0/0).find{|e| !File.exist?("#{graded_dir}/#{user}.#{e}")}
    File.rename(old_file,"#{graded_dir}/#{user}.#{index}")
end

def grade(user, args)
    if !$admin_users.include?(user)
        return false
    end

    problems = args.any? ? [args.shift] : problem_list
    submitter = args.any? ? args.shift : nil

    problems.each do |problem|
        in_files_path = File.join(problem_dir(problem), "tests", "*.in")
        in_files = Dir[in_files_path]

        submissions_paths = File.join(submission_dir(problem), "*")
        submissions = Dir[submissions_paths]

        submissions.each do |submission|
            user = File.basename(submission)
            next if !submitter.nil? and user != submitter

            puts "\nGrading #{user} - #{problem}"

            files_paths = File.join(submission_dir(problem, user), "*")
            files = Dir[files_paths]
            if files.size != 1
                puts "#{files.size} files submitted, expected 1"
                next
            end
            file = files.first

            compile(file)
            success = true
            in_files.each do |in_file_path|
                success &= run(file, in_file_path)
                puts "\t#{File.basename in_file_path}: #{success ? "Passed" : "Failed"}"
            end
            puts "Result: #{success ? "Passed" : "Failed"}"
            move_submission(submission, "#{problem_dir(problem)}/graded/")
        end
    end
    true
end

def contests(user, args)
    cons = nil

    DB::connect do |db|
        if args.length != 1 || args[0] != '-a'
            cons = db.active_contests
        else
            cons = db.all_contests
        end
    end

    cons.each do |contest|
        if contest == $default_contest
            puts contest + ' *'
        else
            puts contest
        end
    end

    true
end

def problems(user, args)
    in_name = args[0]
    prob_names = {}

    problem_list.each do |problem_name|
        prob_names[problem_name] = File.join(problem_dir(problem_name), "problem.txt")
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
