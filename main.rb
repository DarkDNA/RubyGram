require 'ana-class.rb'

# Get anagram from user
puts
print "Please enter an anagram: "
myInput = gets.chomp

if myInput.empty?
    puts "Error! Nothing entered"
    exit
end

# Ok so we got a non blank input from the user, time to create a new RubyGram object
test = RubyGram.new(myInput)

# Now that we got the new object created, let's run the mainMenu Method to find or exit
test.mainMenu()