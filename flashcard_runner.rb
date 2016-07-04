require_relative 'flashcards'
require 'pry'

puts "Welcome To RyCards... Where flashcards are our business."
local_cards = []
user_deck = nil
loop do
  puts "First, do you have a previous deck saved (Y/N)?"
  print "> "
  user_deck = gets.downcase.chomp
  break if user_deck == 'y' || user_deck == 'n'
  puts "\nYou must enter either Y or N.\n"
end
if user_deck == 'y'
  loop do
    puts "Enter the name of the deck file now."
    print "> "
    filename = gets.downcase.chomp
    filename += ".txt" if filename[-4] != '.' && filename != '0' # Adds the .txt extension if the user did not type it in.
    if File.exist?(filename)
      local_cards = CardGenerator.new(filename).cards # Save the array of the cards in the text file to local_cards
      break
    elsif filename == '0'
      user_deck = 'n'  # Break to the loop and allow the user to create a brand new deck from scratch
      break
    else
      puts "The file name you entered does not exist.  Please type the correct file name or 0 to create a deck."
      # File name does not exist in the relative directory.  Prompts user to re-enter the file name or type 0 to create a new deck
    end
  end
end
# Below is the loop that allows the user to make a new deck of flashcards
if user_deck == 'n'
  raw_string_of_cards = String.new  # String that can be saved to a text file if user wants to save the questions they entered
  save_deck = nil # Initialized variable to determine if user wants to save the new deck
  loop do
    puts "You have #{local_cards.length} cards in your deck.\nPlease enter a question, or 0 to quit."
    print "> "
    user_question = gets.chomp
    raw_string_of_cards += user_question + ";" if user_question != '0' # Ensures a 0 is not tacked on to the end of the raw string of cards for the text file
    break if user_question == '0'
    puts "You entered: #{user_question}\nNow enter the answer to that question."
    print "> "
    user_answer = gets.chomp
    raw_string_of_cards += user_answer + ";"
    puts "You entered: #{user_answer}\nNow enter a hint to help the user out."
    print "> "
    user_hint = gets
    raw_string_of_cards += user_hint
    local_cards << Card.new(user_question, user_answer, user_hint.chomp)
    local_cards.shuffle! # Automatically shuffle the cards to keep things interesting
  end
  # Option to save new deck cards to directory so they can be used in the future
  puts "Thank you."
  loop do
    puts "Would you like to save your new deck of #{local_cards.length} cards to access in the future (Y/N)?"
    print "> "
    save_deck = gets.downcase.chomp
    break if save_deck == 'y' || save_deck == 'n'
    puts "You must enter either Y or N."
  end
  if save_deck == 'y'
    new_saved_deck = CreateNewDeckFile.new(raw_string_of_cards)
    loop do
      puts "What would you like to save the file as?"
      print "> "
      new_filename = gets.downcase.chomp
      new_filename += ".txt" if new_filename[-4] != '.'
      if new_saved_deck.filename_exist?(new_filename)
        overwrite_file = String.new # Declare variable to determine if user wants to overwrite existing file
        loop do
          puts "That file already exists.  Would you like to overwrite it (Y/N)?"
          print "> "
          overwrite_file = gets.downcase.chomp
          break if overwrite_file == 'y' || overwrite_file == 'n'
          puts "You must enter either Y or N."
        end
        if overwrite_file == 'y'
          new_saved_deck.filename_exist?(new_filename, true) # Telling the program to save the file name regardless of whether or not it already exists
          new_saved_deck.save_file
          break
        else # Prompts user to enter new file name and does not overwrite existing file
          puts "Please enter a new file name."
        end
      else
        new_saved_deck.save_file
        break
      end
    end
  end
end
puts "\nThank you.  We are now creating and shuffling your deck of #{local_cards.length} cards."
deck = Deck.new(local_cards)
deck.cards.shuffle!
start_round = String.new
loop do
  puts"\nWould you like to start a round (Y/N)?"
  print "> "
  start_round = gets.downcase.chomp
  break if start_round == 'y' || start_round == 'n'
  puts "You must enter either Y or N."
end
if start_round == 'y'
  round = Round.new(deck)
  puts "Before we begin...\nWould you like your incorrect answers to be shuffled back into the deck (Y/N)?"
  print "> "
  reshuffle_cards = gets.downcase.chomp
  loop do
    break if reshuffle_cards == 'y' || reshuffle_cards == 'n'
    puts "Please enter Y or N.\nWould you like your incorrect answers to be shuffled back into the deck (Y/N)?"
    print "> "
    reshuffle_cards = gets.downcase.chomp
  end
  round.extra_practice(true) if reshuffle_cards == 'y' # Declares true for variable enabling reshuffling
  round.start
  current_card_number = 1 # TESTING SOME SHIT!!!!!!
  deck_size = round.deck.cards.count # TESTING SOME SHIT!!!!!!
  while round.deck.cards[0] != nil
    puts "\nThis is card number #{current_card_number} out of #{deck_size}."
    puts "Question: #{round.current_card.question}"
    puts "Enter your answer or enter the word 'hint' for extra help."
    print "> "
    user_response = gets.chomp
    if user_response.downcase == 'hint'
      puts "Question: #{round.current_card.question}"
      puts "Hint: #{round.hint_to_current_question}"
      print "Your answer: "
      user_response = gets.chomp
    end
    round.record_guess(user_response)
    if round.guesses.last.correct? && reshuffle_cards == 'y'
      current_card_number += 1
    elsif reshuffle_cards == 'n'
      current_card_number += 1
    end
    puts round.guesses.last.feedback + "\n"
  end
  puts "\n****** Game over! ******"
  puts "You had #{round.number_correct} correct guesses out of #{round.guesses.count} for a score of #{round.percent_correct}%.\n"
  save_outcome = String.new
  loop do
    puts "Would you like to save your results (Y/N)?"
    print "> "
    save_outcome = gets.downcase.chomp
    break if save_outcome == 'y' || save_outcome == 'n'
    puts "Please enter either Y or N.\n"
  end
  round.save_results if save_outcome == 'y'
  puts "Thank you for playing."
else
  puts "Thank you for playing."
end
