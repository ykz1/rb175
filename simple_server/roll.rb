require 'socket'

def parse_request(request_line)
  method, path_and_params, http_version = request_line.split
  
  path, params = path_and_params.split("?")

  params = params.split("&")
  params = params.each_with_object({}) do |param, hash|
    key, value = param.split("=")
    hash[key] = value
  end

  [method, path, params]
end


server = TCPServer.new("localhost", 3003)

loop do
  client = server.accept
  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  method, path, params = parse_request(request_line)

  
  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts request_line
  client.puts "</pre>"
  
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i
  
  client.puts "<h1>Rolls:</h1>"
  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end

  client.puts "</body>"
  client.puts "</html>"

  client.close
end