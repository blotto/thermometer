Thermometer
=======

[<img src="https://secure.travis-ci.org/blotto/thermometer.png" />](http://travis-ci.org/blotto/thermometer)
[![Code Climate](https://codeclimate.com/github/blotto/thermometer.png)](https://codeclimate.com/github/blotto/thermometer)
[![Dependency Status](https://gemnasium.com/blotto/thermometer.png)](https://gemnasium.com/blotto/thermometer)
[![Coverage Status](https://coveralls.io/repos/blotto/thermometer/badge.png)](https://coveralls.io/r/blotto/thermometer)

### Mixins
This plugin introduces two mixins to your recipe book:

1. **acts\_as\_thermometer** : Extends Instance with temperature methods
2. **measure\_the\_heat\_on** : Allows customization on an association, or method that returns an ActiveRecord Collection


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

Models must have the automatically managed columns *created_at* and *updated_at* in order to evaluate the temperature.



Typical Usage
-----

```ruby
class User < ActiveRecord::Base

  acts_as_thermometer

  has_many :messages

  has_many :oldest_messages, -> {where('created_at < ?', 4.months.ago)} , class_name: "Message"
  has_many :recent_messages, -> {where('created_at > ? AND created_at < ?', 4.months.ago , 1.month.ago)} , class_name: "Message"
  has_many :newest_messages, -> {where('created_at > ?', 1.month.ago)} , class_name: "Message"

 end
```

Measure the heat on an instance of User through various methods when *acts_as_thermometer* is added to the Model

```ruby
User.first.has_temperature        # lukewarm
User.first.is_colder_than? :warm  # false
User.first.is_warmer_than? :cold  # true
```

Measure the heat on any association, or scope

```ruby
User.first.messages.has_temperature               # temperate
User.first.oldest_messages.has_temperature        # frigid
User.first.recent_messages.is_colder_than? :warm  # false
User.first.newest_messages.is_warmer_than? :cold  # true
```

Customizing Usage
-----

in most cases, how you measure the heat is consistent across Models, and Associations, therefore keep your customizations
global by changing options in the YAML file.  However, you could pass through customizations specific to a particular use
case.

Configs can be passed through in a number of scenarios.



```ruby
class User < ActiveRecord::Base

  acts_as_thermometer

  has_many :messages

  has_many :oldest_messages, -> {where('created_at < ?', 4.months.ago)} , class_name: "Message"
  has_many :recent_messages, -> {where('created_at > ? AND created_at < ?', 4.months.ago , 1.month.ago)} , class_name: "Message"
  has_many :newest_messages, -> {where('created_at > ?', 1.month.ago)} , class_name: "Message"

 end

```

Copyright
---------

Copyright (c) 2014 Nick Newell. See LICENSE.txt for further details.






