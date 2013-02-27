require 'sqlite3'

task :make_fancyCat do
    sh 'gcc -o fancyCat fancyCat.c'
    #I couldn't figure out how to chmod with setuid
    sh 'chmod +s fancyCat'
end

task :init_db do
    db = SQLite3::Database.new 'cpc.db'

    db.execute '
        CREATE TABLE user (
            id INTEGER PRIMARY KEY,
            alias TEXT,
            UNIQUE (alias)
        );'

    db.execute '
        CREATE TABLE contest (
            id INTEGER PRIMARY KEY,
            name TEXT,
            alias TEXT,
            start INTEGER,
            end INTEGER,
            UNIQUE(name)
        );'

    db.execute '
        CREATE TABLE problem (
            id INTEGER PRIMARY KEY,
            contest INTEGER,
            name TEXT,
            points INTEGER,
            FOREIGN KEY(contest) REFERENCES contest(id),
            UNIQUE(name)
        );'

    db.execute '
        CREATE TABLE submission (
            id INTEGER PRIMARY KEY,
            user INTEGER,
            problem INTEGER,
            time INTEGER,
            status STRING,
            executionTime INTEGER,
            errorId INTEGER,
            FOREIGN KEY(user) REFERENCES user(id),
            FOREIGN KEY(problem) REFERENCES problem(id)
        );'
end
