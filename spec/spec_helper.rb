require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'active_record'
require 'active_record_distinct_on'

ActiveRecordDistinctOn.install

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Base.connection.execute(<<-SQL)
  CREATE TABLE dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    toys_count INTEGER DEFAULT 0,
    ear_length INTEGER,
    nose_length INTEGER,
    paw_power INTEGER
  );
SQL

class Dog < ActiveRecord::Base
end
