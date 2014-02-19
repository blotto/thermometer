class User < ActiveRecord::Base

  acts_as_thermometer



  has_many :messages

  has_many :oldest_messages, -> {where('created_at < ?', 4.months.ago)} , class_name: "Message"
  has_many :recent_messages, -> {where('created_at > ? AND created_at < ?', 4.months.ago , 1.month.ago)} , class_name: "Message"
  has_many :newest_messages, -> {where('created_at > ?', 1.month.ago)} , class_name: "Message"

  measures_temperature_for :messages, {:explicit=>true, :date => :updated_at}

  measures_temperature_for :oldest_messages, :recent_messages, {:date => 'updated_at'} #only use options defined here
  measures_temperature_for :newest_messages, {:date => 'messages.created_at', :sample => 3} #clearly defined date field

  class << self
    def name_like(substring)
      where("name LIKE '%#{substring}%'")
    end
  end

  def last_five_messages
    messages.limit(5)
  end

end
