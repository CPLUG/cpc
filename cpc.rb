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


command = ARGV[0].to_s.strip.to_sym

if command.length == 0
   puts "usage: cpc <command>"
else
   CPC.instance.method(command).call
end


