require 'socket'               # Get sockets from stdlib
require 'json'

def serve_get(parts)
	response = ""
	if parts[1] == "/index.html"
		response << "HTTP/1.0 200 OK\r\n"
		response << "Date: #{Time.now.utc}\r\n"
		response << "Content-Type: text/html\r\n"
	    webpage = File.read("index.html")
	    response << "Content-Length: #{webpage.bytesize}\r\n"
	    response << "\r\n"
	    response << webpage
	else
		response << "HTTP/1.0 404 Not Found"
	end
	return response
end

def serve_post(parts, params)
	puts "in serve post"
	if parts[1] == "/script.cgi"
		response << "HTTP/1.0 200 OK\r\n"
		response << "Date: #{Time.now.utc}\r\n"
		response << "Content-Type: text/html\r\n"
	    webpage = File.read("thanks.html")
	    dynamic_content = "<li>Name: #{params["viking"]["name"]}</li><li>Email: #{params["viking"]["email"]}</li>"
	    webpage = webpage.gsub("<%= yield %>",dynamic_content)
	    response << "Content-Length: #{webpage.bytesize}\r\n"
	    response << "\r\n"
	    response << webpage
	else
		response << "HTTP/1.0 404 Not Found"
	end
	return response
end

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever

  client = server.accept       # Wait for a client to connect
  # request = client.read
  request = ""
  action = ""
  while action = client.gets
     request += action
     break if request =~ /\r\n\r\n$/
   end 

  # puts request
  parts = request.split(" ")
  puts parts
  body_size = parts.last.to_i
  #puts "body_size #{body_size}"
  body = client.read(body_size)
  #puts body
  params = JSON.parse(body)
  case parts[0]
  when "GET" then client.puts(serve_get(parts))
  when "POST" then client.puts(serve_post(parts, params))
  else
  	client.puts(Time.now.ctime)  # Send the time to the client
  	client.puts "Closing the connection. Bye!"
  end
  client.close                 # Disconnect from the client
}