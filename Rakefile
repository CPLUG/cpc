require './src/db.rb'


task :make_fancyCat do
    sh 'gcc -o fancyCat src/fancyCat.c'
    #I couldn't figure out how to chmod with setuid
    sh 'chmod +s fancyCat'
end

task :init_db do
    DB::connect do |db|
        db.create_tables
    end
end
