# app.rb

require 'sinatra'
require 'sinatra/reloader'
require 'yaml'

before do
  @users = Psych.load_file("./data/users.yaml")
  @user_count = @users.size
  @interest_count = @users.values.map { |user| user[:interests] }.flatten.uniq.size
end

not_found do
  redirect '/'
end

get '/' do
  erb :home
end

get '/users/:name' do
  @name = params[:name]
  names = @users.keys.map(&:to_s)
  redirect '/' unless names.include?(@name)
  
  @title = "#{@name}'s page"
  
  user_data = @users[@name.to_sym]
  @email = user_data[:email]
  @interests = user_data[:interests].join(', ')

  @other_users = @users.select { |name, data| name != @name.to_sym }
  
  erb :profile
end
