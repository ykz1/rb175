require "sinatra"
require "sinatra/reloader"
# require "tilt/erubi"

# =================
# Before items

before do
  @list_of_chapters = File.readlines("./data/toc.txt")
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

  def bold_matching(text, term)
    text.gsub(term, "<strong>#{term}</strong>")
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

  unless search_term.nil?
    # @search_results should return an array of chapters with nested array of paragraphs including search term
    # [{number: 1, name: "some chapter", paragraphs: {1: "once upon a time", 99: "and then he died..."}}]
    
    # For each chapter(c), check each paragraph(p) and add to output if search term found:
    @search_results = @list_of_chapters.each_with_index.with_object([]) do |(c_name, c_index), results|
      c_num = c_index + 1

      paragraphs = File.read("data/chp#{c_num}.txt").split("\n\n")
      p_matches = paragraphs.each_with_index.with_object({}) do |(p_text, p_index), matches|
        p_num = p_index + 1
        if p_text.include?(search_term)
          matches[p_num.to_s] = p_text
        end
      end

      unless p_matches.empty?
        results << {number: c_num, name: c_name, paragraphs: p_matches}
      end
    end
  end

  erb :search
end