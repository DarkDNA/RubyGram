require 'socket'

class RubyGram

    #initilizer method... initialized with anagram
    def initialize(anagram)

        # Server setup stuff, setup as instance variables so they are global to that particular
        # object upon creation
        @anagram = anagram
        @host = 'wordsmith.org'
        @port = 80
        @path = "/anagram/anagram.cgi?anagram=#{anagram}"

    end

    def getAnagram(anagram)

        #formated GET request to the webserver.. it expects this stuff
        request = "GET #{@path} HTTP/1.0\r\n\r\n"
        #opens connection to host on the port
        s = TCPSocket.open(@host, @port)

        #sends GET stuff to the server
        s.print(request)

        #reads what the GET returns (what data it's GETing)
        response = s.read

        #split divides the result where the pattrn matches
        # returns 2 fields in the array.. \r\n is CRLF line termination
        headers,body = response.split("\r\n\r\n", 2)

        #close socket
        s.close
    
        #return body back to caller
        return body

    end

    def parseAnagram(anagramPage)

        pat = /^<b>(\d+) found\. Displaying all:\s*<\/b><br>|\G(?!\A)\s*([\w ]+)<br>/

        #takes the arguement and scans through it capturing the patterns we find
        #count goes to the first capturing group if it exists
        # anagram represents all other capturing groups in this looping/iteration 
        anagramPage.scan(pat) { |count,anagram|
        if count
            puts
            puts "Results: #{count}"
            puts
        else
            puts anagram
        end
        }
        
        puts

    end

    def getAndParse()

        #Go and fetch the anagram and store it
        myAnagram = getAnagram(@anagram)

        #Parse and print anagram
        parseAnagram(myAnagram)
    end

    def mainMenu()
        puts
        puts "----------------------------------"
        puts "\tWelcome to RubyGram!"
        puts "----------------------------------"
        puts 
        puts "Enter one of the menu choices"
        puts "\t1. Find Anagrams"
        puts "\t2. Exit"
        print "Please enter your selection: "
        choice = gets.chomp
             case choice
                 when "1"
                     #get anagram, parse it, and print it
                     getAndParse()
                 when "2"
                     puts "\nExiting!\n"
                     exit
                 else
                     puts "\nInvalid Selection!\n"
                    # using some recursion that i don't fully grasp at this state, we call the menu structure again
                    # because on the stack and in mmemory it's already created.
                    mainMenu()
             end

    end


end
