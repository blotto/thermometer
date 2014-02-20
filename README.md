Thermometer
=======

[<img src="https://secure.travis-ci.org/blotto/thermometer.png" />](http://travis-ci.org/blotto/thermometer)
[![Code Climate](https://codeclimate.com/github/blotto/thermometer.png)](https://codeclimate.com/github/blotto/thermometer)
[![Dependency Status](https://gemnasium.com/blotto/thermometer.png)](https://gemnasium.com/blotto/thermometer)
[![Coverage Status](https://coveralls.io/repos/blotto/thermometer/badge.png)](https://coveralls.io/r/blotto/thermometer)

### Mixins
This plugin introduces two mixins to your recipe book:

1. **acts\_as\_thermometer** : Extends Instance with temperature methods
2. **measure\_temperature\_for** : Allows customization on an association


### Motivation

This plugin was started as a way for Bots to quickly assess the state of a User across many dimensions of Game play to
determine automated actions for retention. For example, if a User went *cold* with regards to reading messages,
a reminder could be sent. Rather than dealing with dates and duration, coding uses a simplified syntax,
for example :

    user = User.first
    user.*call_to_some_action* if user.unread_messages.has_temperature?(:cold)  # false|true
    user.*call_to_some_action* if user.unread_messages.is_colder_than?(:warm)   # false|true


Installation
------------

In your gemfile

```ruby
gem "temperature"  , github: 'blotto/temperature', :branch => "first_release"
```

Then at the command line

	bundle update --source temperature
	rails generate temperature:install

Configuration
-------------

After install a YAML file is placed in the config directory, *config/thermometer.yml*. For a detailed description of the
available options, read the comments within the YAML file.

### ActiveRecord Dependency

Models must have the managed columns *created_at* and *updated_at* in order to evaluate the temperature.

Typical Usage for `acts_as_thermometer`
-----

Measure the temperature on the Class , and on an Instance

```ruby
class User < ActiveRecord::Base

  acts_as_thermometer

end
```

```ruby
User.has_temperature        # lukewarm
User.is_colder_than? :warm  # false
User.is_warmer_than? :cold  # true

User.first.has_temperature        # lukewarm
User.first.is_colder_than? :warm  # false
User.first.is_warmer_than? :cold  # true
```

Measure the temperature on any association. NOTE: declare `measures_temperature_for` after your associations!

```ruby
class User < ActiveRecord::Base

  acts_as_thermometer

  has_many :messages

  has_many :oldest_messages, -> {where('created_at < ?', 4.months.ago)} , class_name: "Message"
  has_many :recent_messages, -> {where('created_at > ? AND created_at < ?', 4.months.ago , 1.month.ago)} , class_name: "Message"
  has_many :newest_messages, -> {where('created_at > ?', 1.month.ago)} , class_name: "Message"

  measures_temperature_for :messages, :oldest_messages , :recent_messages , :newest_messages

 end
```

```ruby
User.first.messages.has_temperature               # temperate
User.first.oldest_messages.has_temperature        # frigid
User.first.recent_messages.is_colder_than? :warm  # false
User.first.newest_messages.is_warmer_than? :cold  # true
```

Method Chaining
-----

You can check the temperature on scopes...

```ruby
class User < ActiveRecord::Base

  acts_as_thermometer

  class << self
      def name_like(substring)
        where("name LIKE '%#{substring}%'")
      end
   end

   def last_five_messages
     messages.limit(5)
   end

 end
```

```ruby
User.name_like("Ms.").has_temperature               # temperate
User.name_like("Ms.").first.last_five_messages.has_temperature # warm
```


Customizing Usage
-----

In most cases, how you measure the temperature is consistent across Models, and Associations, therefore keep your customizations
global by changing options in the YAML file.  However, you could pass through customizations specific to a particular use
case.

Configs can be passed through in a number of scenarios.

### Overriding options via measures_temperature_for

```ruby
class User < ActiveRecord::Base

  acts_as_thermometer

  has_many :messages

  has_many :oldest_messages, -> {where('created_at < ?', 4.months.ago)} , class_name: "Message"
  has_many :recent_messages, -> {where('created_at > ? AND created_at < ?', 4.months.ago , 1.month.ago)} , class_name: "Message"
  has_many :newest_messages, -> {where('created_at > ?', 1.month.ago)} , class_name: "Message"

  measures_temperature_for :messages, {:explicit=>true, :date => :updated_at}  #only use options defined here
  measures_temperature_for :recent_messages, {:date => 'updated_at'} #use this date, and default options
  measures_temperature_for :newest_messages,
                    {:date => 'messages.updated_at', :sample => 3} #clearly defined date field, sampling 3 records

 end

```

```ruby
> User.first.messages.has_temperature
  User Load (0.1ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
   (1.4ms)  SELECT "messages"."updated_at" FROM "messages" WHERE "messages"."user_id" = ?  [["user_id", 14035331]]
 => "frosty"

> User.first.newest_messages.has_temperature
  User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
    (0.6ms)  SELECT messages.created_at FROM "messages" WHERE "messages"."user_id" = ? AND (created_at >
    '2014-01-19 23:44:59.413221') ORDER BY messages.created_at DESC LIMIT 3  [["user_id", 14035331]]
 => :none
 ```

### Overriding options via method calls

```ruby
> User.first.newest_messages.has_temperature :sample => 5
  User Load (0.3ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
   (0.4ms)  SELECT messages.created_at FROM "messages" WHERE "messages"."user_id" = ? AND (created_at > '2014-01-20 00:04:54.558920') ORDER BY messages.created_at DESC LIMIT 5  [["user_id", 14035331]]
 => :none

> User.first.messages.has_temperature :date => 'created_at'
  User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
   (0.4ms)  SELECT created_at FROM "messages" WHERE "messages"."user_id" = ?  [["user_id", 14035331]]
 => "freezing"

> User.is_colder_than? :warm, :sample => 5
   (0.4ms)  SELECT updated_at FROM "users" ORDER BY updated_at DESC LIMIT 5
 => false

> User.first.is_colder_than? :warm, :sample => 5
  User Load (0.2ms)  SELECT "users".* FROM "users" ORDER BY "users"."id" ASC LIMIT 1
 => true
```

### Using AREL Relations directly

You can chain methods on relations. Note, that without explicitly excluding them, defaults will be applied. This example,
only samples the last record in the ActiveRecord collection.

```ruby
> User.where('created_at > ?', (Time.now - 3.weeks)).has_temperature
   (0.5ms)  SELECT updated_at FROM "users" WHERE (created_at > '2014-01-30 00:18:13.260406') ORDER BY updated_at DESC LIMIT 1
 => "lukewarm"
```

However, you can disable this by passing the option `:explicit=>true` and sample the entire set :

```ruby
> User.where('created_at > ?', (Time.now - 3.weeks)).has_temperature :explicit=>true
   (0.4ms)  SELECT updated_at FROM "users" WHERE (created_at > '2014-01-30 00:18:33.207988')
 => "temperate"
```

You can still apply other options :

```ruby
> User.where('created_at > ?', (Time.now - 3.weeks)).has_temperature :explicit=>true , :date => :updated_at
   (28.7ms)  SELECT "users"."updated_at" FROM "users" WHERE (created_at > '2014-01-30 00:25:23.563479')
 => "temperate"
```

Copyright
---------

Copyright (c) 2014 Nick Newell. See LICENSE.txt for further details.






