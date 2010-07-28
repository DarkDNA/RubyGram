require 'socket'

def getAnagram(anagram)
    #server info + port + path
    host = 'wordsmith.org'
    path = "/anagram/anagram.cgi?anagram=#{anagram}"
    port = 80
    
    #formated GET request to the webserver.. it expects this stuff
    request = "GET #{path} HTTP/1.0\r\n\r\n"
    #opens connection to host on the port
    s = TCPSocket.open(host, port)

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

def anagramParse(anagramPage)

#my progress/attempts at this 
#regex = / <\/b><br>(\w.+)<br>\n(\w+\s+\w+) /
#regex2 = /Displaying all:\n<\/b><br>(\w.+)<br>\n(.+)<br>\n(\w+\s\w+).{2,}\n.{2,}\n\n<!.{1,33}->/
#regex3 = /Displaying all:\n<\/b><br>(\w.+)<br>\n(.+)<br>\n(.+)<br>\n(.+)<br>\n\n<!--\sAd/
#regex4=/([0-9]).+Displaying all:\n<\/b><br>(\w.+)<br>\n(.+)<br>\n(.+)<br>\n(.+)<br>\n\n<!--\sAd/
#regex-final=/(?:(?:<b>)(\d+))?(?: found. Displaying all:\r?\n<\/b><br>|\G<br>\r?\n)([\w ]+)/

    
 #m3 = /(?:(?:<b>)(\d+))?(?: found. Displaying all:\r?\n<\/b><br>|\G<br>\r?\n)([\w ]+)/
 
#big help from freenode.net regex wildcat and mizardx 
#first group = at the beginning of the line, match at least 1 decimal and store it
#2nd group 
#3rd group
pat = /^<b>(\d+) found\. Displaying all:\s*<\/b><br>|\G(?!\A)\s*([\w ]+)<br>/

#takes the arguement and scans through it capturing the patterns we find
#count goes to the first capturing group if it exists
# anagram represents all other capturing groups in this looping/iteration 
anagramPage.scan(pat) { |count,anagram|
  if count
    puts "Results: #{count}"
    puts
  else
    puts anagram
  end
}
    
end

def getAndParseAnagram()
   print "Please enter an anagram: "
   input = gets.chomp
   if input.empty?
        puts "\nError: Nothing Entered.\n"
        exit
   end

   #Go and fetch the anagram and store it
   myAnagram = getAnagram(input)

   #Parse and print anagram
   anagramParse(myAnagram)

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
                getAndParseAnagram()
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




