require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', File.dirname(__FILE__))
require 'active_record'
require 'active_record_distinct_on'

ActiveRecordDistinctOn.install

database_url = ENV.fetch('DATABASE_URL', 'sqlite3::memory:')
ActiveRecord::Base.establish_connection(database_url)

ActiveRecord::Base.connection.execute(<<-SQL)
  CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    toys_count INTEGER DEFAULT 0,
    ear_length INTEGER,
    nose_length INTEGER,
    paw_power INTEGER
  );
SQL

ActiveRecord::Base.connection.execute(<<-SQL)
  CREATE TABLE IF NOT EXISTS dog_to_toys (
    dog_id INTEGER,
    toy_id INTEGER
  );
SQL

ActiveRecord::Base.connection.execute(<<-SQL)
  CREATE TABLE IF NOT EXISTS toys (
    id INTEGER PRIMARY KEY,
    dog_to_toy_id INTEGER,
    name TEXT
  );
SQL

class Dog < ActiveRecord::Base
  has_many :dog_to_toys, class_name: 'DogToToys'
  has_many :toys, -> { distinct_on(:id) }, through: :dog_to_toys, class_name: 'Toy'
end

class DogToToys < ActiveRecord::Base
  belongs_to :dog
  belongs_to :toy
end

class Toy < ActiveRecord::Base
end

RSpec.configure do |config|
  config.before(:each) do
    conn = ActiveRecord::Base.connection
    conn.execute "delete from dogs;"
    conn.execute "delete from dog_to_toys;"
    conn.execute "delete from toys;"
  end
end
