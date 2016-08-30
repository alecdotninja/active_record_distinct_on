# ActiveRecordDistinctOn

[![Build Status](https://travis-ci.org/anarchocurious/active_record_distinct_on.svg?branch=master)](https://travis-ci.org/anarchocurious/active_record_distinct_on) [![Code Climate](https://codeclimate.com/github/anarchocurious/active_record_distinct_on/badges/gpa.svg)](https://codeclimate.com/github/anarchocurious/active_record_distinct_on) [![Test Coverage](https://codeclimate.com/github/anarchocurious/active_record_distinct_on/badges/coverage.svg)](https://codeclimate.com/github/anarchocurious/active_record_distinct_on/coverage)  [![Security](https://hakiri.io/github/anarchocurious/active_record_distinct_on/master.svg)](https://hakiri.io/github/anarchocurious/active_record_distinct_on/master)

ActiveRecordDistinctOn adds support for `DISTINCT ON` queries to ActiveRecord. At the time of this writing, PostgreSQL is the only database which supports this syntax; however, this gem has been written with database independence in mind so that if [another Arel visitor](https://github.com/rails/arel/tree/master/lib/arel/visitors) adds support for [`Arel::Nodes::DistinctOn`](https://github.com/rails/arel/blob/master/lib/arel/nodes/unary.rb) in the future, it should work seamlessly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_distinct_on'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record_distinct_on

## Usage

This gem defines `ActiveRecord::Base.distinct_on` and `ActiveRecord::Relation#distinct_on`. Both accept a variable number of column arguments.

For example:

```ruby
Dog.distinct_on(:name, :owner_id)
```

Generates SQL like:

```sql
SELECT DISTINCT ON ( "dogs"."name", "dogs.owner_id" ) "dogs".* FROM "dogs"
```

**Note:** For applications using ActiveRecord à la carte (without the `rails` gem), none of the methods above will be defined until `ActiveRecordDistinctOn.install` is manually called.

## Development

The development dependencies of this gem are managed using [bundler](https://rubygems.org/gems/bundler).

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bundle exec rake console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/anarchocurious/active_record_distinct_on.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
