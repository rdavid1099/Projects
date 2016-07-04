require 'date'

class Card
  def initialize(question, answer, hint)
    @question = question
    @answer = answer
    @hint = hint
  end
  def question
    @question
  end
  def answer
    @answer
  end
  def hint
    @hint
  end
end

class Deck
  def initialize(cards)
    @cards = cards
  end
  def cards
    @cards
  end
  def count
    @cards.length
  end
end

class CardGenerator
  def initialize(file_name)
    @file_name = file_name
  end
  def cards
    cards_in_file = File.read(@file_name).split(/\n/)
    cards_in_file.map {|card| Card.new(card.split(';')[0],card.split(';')[1],card.split(';')[2])}
  end
end

class CreateNewDeckFile
  def initialize(string_of_cards)
    @string_of_cards = string_of_cards
  end
  def filename_exist?(filename, overwrite = false)  # Only saves file name if it is a new file... OR the user says it is okay to overwrite the file.
    @filename = filename if File.exist?(filename) == false || overwrite == true
    return File.exist?(filename) if overwrite == false
    File.exist?(filename)
  end
  def save_file
    File.new(@filename, "w")
    File.open(@filename, "w") {|cards| cards.puts @string_of_cards}
    puts "#{@filename.capitalize} has successfully been saved."
  end
end

class Round
  def initialize(deck)
    @deck = deck
    @guesses = []
  end
  def start
    puts "\nLet's Play RyCARDS!  You're playing with #{@deck.cards.count} cards.\n-------------------------------------------------\n"
  end
  def deck
    @deck
  end
  def guesses
    @guesses
  end
  def extra_practice(more_practice = false)
    @reshuffle_incorrect_cards = more_practice
  end
  def current_card
    return @deck.cards[0]
  end
  def previous_card
    return @guesses[-1].card
  end
  def record_guess(user_guess)
    @guesses << Guess.new(user_guess, current_card)
    if @guesses[-1].correct? == false && @reshuffle_incorrect_cards == true # User didn't get question right and wants extra practice
      @deck.cards.shuffle!
      puts "Card was reshuffled into the deck."
  elsif @guesses[-1].correct? && @reshuffle_incorrect_cards == true
      @deck.cards.delete(previous_card)
    else
      @deck.cards.shift
    end
  end
  def number_correct
    correct = 0
    @guesses.each {|response| correct += 1 if response.correct?}
    return correct
  end
  def percent_correct
    ((number_correct.to_f / guesses.count) * 100).round
  end
  def save_results
    results_filename = "#{Date.today.strftime('%Y-%m-%d')}-#{Time.now.hour.to_s}:#{Time.now.min.to_s}.txt"
    File.new(results_filename, 'w')
    results = "On #{Date.today.strftime('%Y-%m-%d')} at #{Time.now.hour.to_s}:#{Time.now.min.to_s} user scored #{percent_correct}%.  Below are the results.\n"
    @guesses.each do |result|
      results += "-------------------------------------------------\nQuestion: #{result.card.question}\nAnswer: #{result.card.answer}\nUser Response: #{result.response}\nEvaluation: #{result.feedback}\n"
    end
    File.open(results_filename, "w") {|file| file.puts results}
  end
  def hint_to_current_question
    return current_card.hint
  end
end

class Guess
  def initialize(user_input, card)
    @response = user_input
    @card = card
  end
  def card
    @card
  end
  def response
    @response
  end
  def correct?
    return true if @response.downcase == card.answer.downcase # .downcase ensures that answers are NOT case sensitive
    false
  end
  def feedback
    return "Correct!" if correct?
    "Incorrect."
  end
end
