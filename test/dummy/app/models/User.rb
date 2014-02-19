class User < ActiveRecord::Base

  acts_as_thermometer



  has_many :messages

  has_many :oldest_messages, -> {where('created_at < ?', 4.months.ago)} , class_name: "Message"
  has_many :recent_messages, -> {where('created_at > ? AND created_at < ?', 4.months.ago , 1.month.ago)} , class_name: "Message"
  has_many :newest_messages, -> {where('created_at > ?', 1.month.ago)} , class_name: "Message"

  measures_temperature_for :messages, {:explicit=>true, :date => :updated_at}

end
