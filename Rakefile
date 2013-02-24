require 'rubygems'
require 'bundler/setup'

require 'sqlite3'

task :make_fancyCat do
    system('gcc -o fancyCat fancyCat.c')
    system('chmod +s fancyCat')
end

task :init_db do
    db = SQLite3::Database.new 'cpc.db'

    db.execute '
        CREATE TABLE contests (
            id INTEGER,
            name TEXT,
            alias TEXT,
            start TEXT,
            end TEXT
        );'

    db.execute '
        CREATE TABLE problems (
            id INTEGER,
            contest INTEGER,
            name TEXT,
            alias TEXT,
            points INTEGER,
            FOREIGN KEY(contest) REFERENCES contests(id)
        );'
end
