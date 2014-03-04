class UsersController < ActionController::Base
  def index
    @users = Hash.new
    users = User.first.messages.heat_map User.first.messages.first.created_at
    users.each { |k, v| @users[datify(k)] = numerify(v) }
    render json: @users
  end

  def show
    @users = User.first.messages.heat_map User.first.messages.first.created_at
    render json: @users
  end

  private

  def numerify string
     (1..10).to_a.sample
  end

  def datify string
    DateTime.parse(string).to_time.to_i
  end

end