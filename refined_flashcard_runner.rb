require_relative 'flashcards'
require 'pry'

puts "Welcome To RyCards... Where flashcards are our business."
local_cards = []
user_deck = String.new
until user_deck == 'y' || user_deck == 'n'
  print "First, do you have a previous deck saved (Y/N)? \n> "
  user_deck = gets.downcase.chomp
  puts "\nYou must enter either Y or N.\n" if user_deck != 'y' && user_deck != 'n'
end
# User uploads a deck text file from the directory
local_cards = UploadSavedDeck.new.read_file if user_deck == 'y'
# Below is the loop that allows the user to make a new deck of flashcards
local_cards = CreateNewDeck.new.create_deck if user_deck == 'n'
# Option to save new deck cards to directory so they can be used in the future
puts "\nThank you.  We are now creating and shuffling your deck of #{local_cards.length} cards."
deck = Deck.new(local_cards)
round = Round.new(deck)
round.start
