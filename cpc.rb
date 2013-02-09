require 'singleton'


class CPC
   include Singleton

   @user = ENV['USERNAME']
   @args = ARGV[1..-1]

   def submissions
      raise NotImplementedError
   end
   
   def scoreboard
      raise NotImplementedError
   end

   def grade
      raise NotImplementedError
   end

   def contests
      raise NotImplementedError
   end

   def register
      raise NotImplementedError
   end

   def problems
      raise NotImplementedError
   end

   def help
      raise NotImplementedError
   end
end


cmd = ARGV[0].to_s.strip.downcase.to_sym

if cmd.length == 0
   puts "usage: cpc <command>"
end

if not CPC.instance.methods.include? cmd
   puts "'#{cmd}' is not a valid command"
end

CPC.instance.method(cmd).call
