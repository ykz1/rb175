require "sinatra"
require "sinatra/reloader"
# require "tilt/erubi"

get "/" do
  @title = "The Adventures of Sherlock Hoooolmes"
  @contents = File.readlines("./data/toc.txt")
  erb :home
end

get "/chapters/:chapter_number" do
  number = params[:chapter_number]
  @contents = File.readlines("./data/toc.txt")
  @title = "Chapter #{number} - #{@contents[number.to_i - 1]}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end