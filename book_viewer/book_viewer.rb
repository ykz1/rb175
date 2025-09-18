require "sinatra"
require "sinatra/reloader"
# require "tilt/erubi"

# =================
# Before items

before do
  # Data stuctures:
  # @contents = [{number: 1, name: 'Chapter 1 name', paragraphs: [{number: 1, text: "she said he said..."}]}, etc...]

  @list_of_chapters = File.readlines("./data/toc.txt")
  # @contents = @list_of_chapters.each_with_index.with_object([]) do |(chapter_name, index), output|
  #   chapter_number = index + 1
  #   paragraphs = File.read("./data/chp#{chapter_number}.txt").split("\n\n")
  #   paragraphs.map!.with_index do |paragraph, index|
  #     {number: index + 1, text: paragraph}
  #   end
  #   output << {number: chapter_number, name: chapter_name, paragraphs: paragraphs}
  # end
end

# =================
# Unknown URL redirect
not_found do
  redirect "/"
end

# =================
# View helper methods
helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |paragraph,index|
      "<p id=\"#{index + 1}\">#{paragraph}</p>"
    end.join
  end
end

# =================
# Helper methods

# =================
# Routes

get "/" do
  @title = "The Adventures of Sherlock Hoooolmes"

  erb :home
end

get "/chapters/:chapter_number" do
  number = params[:chapter_number].to_i
  redirect '/' unless (1..@list_of_chapters.size).cover?(number)
  @title = "Chapter #{number} - #{@list_of_chapters[number - 1]}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get '/search' do
  search_term = params[:query]

  # unless search_term.nil? || search_term.empty?
  #   @search_results = @contents.select do |chapter|
  #     chapter[:paragraphs].map { |paragraph| paragraph[:text] }.join.include?(search_term)
  #   end
  #   @search_results.each do |chapter|
  #     chapter[:paragraphs] = chapter[:paragraphs].select do |paragraph|

  unless search_term.nil?
    # @search_results should return an array of chapters with nested array of paragraphs including search term
    # [{number: 1, name: "some chapter", paragraphs: {1: "once upon a time", 2: "and then he died..."}}]
    @search_results = 1.upto(@list_of_chapters.size).each_with_object([]) do |chapter_number, results|
      text = File.read("data/chp#{chapter_number}.txt")
      paragraphs = text.split("\n\n")
      matching_paragraphs = paragraphs.each_with_index.with_object({}) do |(text, index), results|
        if text.include?(search_term)
          paragraph_number = index + 1
          results[paragraph_number] = text
        end

        chapter_name = # UNFINISHED!!!
        
        unless matching_paragraphs.empty?
          results << {number: chapter_number, chapter_name, matching_paragraphs}
        end
      end
    end
  end



  unless search_term.nil?
    @search_results = 1.upto(@list_of_chapters.size).each_with_object([]) do |chapter_number, results|
      contents = File.read("data/chp#{chapter_number}.txt")
      if contents.include?(search_term)
        results << {number: chapter_number, name: @list_of_chapters[chapter_number -1]}
      end
    end
  end

  

  erb :search
end