require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "Message length of #{message.length} exceeds 140 character limit"
		end
	end

	def run
    	puts "Welcome to the JSL Twitter Client!"
    	command = ""
    	while command != "q"
    		printf "enter command: "
    		input = gets.chomp
    		parts = input.split(" ")
    		command = parts[0]
    		case command
    		when "q" then puts "Goodbye!"
    		when "t" then tweet(parts[1..-1].join(" "))
    		when "dm" then dm(parts[1],parts[2..-1].join(" "))
    		when "spam" then spam_my_followers(parts[2..-1].join(" "))
    		when "elt" then everyones_last_tweet()
    		when "s" then shorten(parts[1])
    		when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
    		else
    			puts "Sorry, I dont know how to #{command}"
    		end
    	end
  	end

  	def dm(target, message)
  		screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name}
  		if screen_names.include? target
	  		puts "Trying to send #{target} this direct message: "
	  		puts message
	  		message = "d @#{target} #{message}"
	  		tweet(message)
	  	else
	  		puts "Can not dm #{target} since its not your follower"
	  	end
  	end

  	def followers_list
  		screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name}
  		return screen_names
  	end

  	def spam_my_followers(message)
  		screen_names = followers_list
  		screen_names.each do |follower|
  			dm(follower, message)
  		end
  	end

  	def everyones_last_tweet
    	#friends = @client.friends
    	screen_names = @client.friends.collect {|friend| @client.user(friend).screen_name}
    	screen_names = screen_names.sort_by {|screen_name| screen_name.downcase }
    	screen_names.each do |screen_name|
    		message = @client.user(screen_name).status.text
    		timestamp = @client.user(screen_name).status.created_at

    		puts " #{screen_name} at --> #{message}"
    		puts timestamp.strftime("%A, %b %d")
      		puts ""  # Just print a blank line to separate people
    	end
  	end

  	def shorten(original_url)
  		puts "Shortening this URL: #{original_url}"
  		Bitly.use_api_version_3

		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		short_url =  bitly.shorten(original_url).short_url
		puts short_url
		return short_url
  	end
end

blogger = MicroBlogger.new
blogger.run