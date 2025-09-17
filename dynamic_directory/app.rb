require 'sinatra'
require 'sinatra/reloader'

get "/" do
  @page_title = "Home"
  @filenames = get_filenames("public/")
  case params['sort']
  when 'asc' then @filenames.sort!
  when 'des' then @filenames.sort! { |a, b| b <=> a }
  end
  erb :home
end

def get_filenames(path)
  filepaths = Dir.glob("#{path}*")
  filepaths.map { |filepath| File.basename(filepath) }
end