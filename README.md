Temperature
=======


### Mixins
This plugin introduces two mixins to your recipe book:

1. **acts\_as\_thermometer** : Extends Instance with temperature methods
2. **measure\_the\_heat\_on** : Allows customization on an association, or method that returns an ActiveRecord Collection


### Motivation

This plugin was started as a way for Bots to quickly assess the state of a User across many dimensions of Game play to
determine automated actions for retention. For example, if a User went *cold* with regards to reading messages,
a reminder could be sent. Rather than dealing with dates and duration, coding use a simplified syntax,
for example :

    user = User.first
    user.remind if user.unread_messages.temperature?(:cold)




