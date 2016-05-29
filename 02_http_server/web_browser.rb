require 'socket'
require 'json'
 
def open
	host = 'localhost'     # The web server
	port = 2000            # Default HTTP port
	socket = TCPSocket.open(host,port)  # Connect to server
	puts "type /page.html to open"
	path = gets.chomp
	request = "GET #{path} HTTP/1.0\r\n\r\n"
	socket.print(request)
	response(socket.read)
end

def submit
	host = 'localhost'     # The web server
	port = 2000            # Default HTTP port
	socket = TCPSocket.open(host,port)  # Connect to server
	puts "type name email to submit form"
	input = gets.chomp
	input = input.split(" ")
	viking = {:viking =>{:name => input[0], :email => input[1]}}
	request = "POST /script.cgi HTTP/1.0\r\n"
	request << "From: x@y.com\r\n"
	request << "User-Agent: HTTPTool/1.0\r\n"
	request << "Content-Type: application/x-www-form-urlencoded\r\n"
	request << "Content-Length: #{viking.to_json.bytesize}\r\n"
	request << "\r\n"
	request << viking.to_json
	puts request
	socket.print(request)
	response(socket.read)
end

def response (response)
	headers,body = response.split("\r\n\r\n", 2)
	puts "---------------------------------------------"
	print headers
	puts ""
	puts "---------------------------------------------"
	print body                          # And display it
	puts ""
	puts "---------------------------------------------"
end

loop  do
	puts "Text web browser:"
	puts "open -> opens a webpage"
	puts "submit -> submit a form to server"
	puts "q -> quits"
	input = gets.chomp
	case input
	when "open" then open
	when "submit" then submit
	when "q" then break
	end
end