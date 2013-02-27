require 'sqlite3'

module DB
    class Connector
        def initialize
            @db = SQLite3::Database.new 'cpc.db'
        end

        def create_tables
            @db.execute '
                CREATE TABLE user (
                    id INTEGER PRIMARY KEY,
                    alias TEXT,
                    UNIQUE (alias)
                );'

            @db.execute '
                CREATE TABLE contest (
                    id INTEGER PRIMARY KEY,
                    name TEXT,
                    alias TEXT,
                    start INTEGER,
                    end INTEGER,
                    UNIQUE(name)
                );'

            @db.execute '
                CREATE TABLE problem (
                    id INTEGER PRIMARY KEY,
                    contest INTEGER,
                    name TEXT,
                    points INTEGER,
                    FOREIGN KEY(contest) REFERENCES contest(id),
                    UNIQUE(name)
                );'

            @db.execute '
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

        def close
            @db.close
        end
    end

    def self.connect(&block)
        db = DB::Connector.new
        block.call db
        db.close
    end
end
