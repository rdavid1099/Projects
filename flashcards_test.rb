gem 'minitest', '~> 5.0'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'flashcards'

class FlashcardsTest < Minitest::Test
  def test_making_a_question_and_answer
    flashcards = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    assert_equal "What is the capital of Alaska?", flashcards.question
    assert_equal "Juneau", flashcards.answer
    assert_equal "A famous movie shares the same name.", flashcards.hint
  end
  def test_user_guess_correct
    card = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    guess = Guess.new("Juneau", card)
    assert_equal card, guess.card
    assert_equal "Juneau", guess.response
    assert guess.correct?
    assert_equal "Correct!", guess.feedback
  end
  def test_user_guess_incorrect
    card = Card.new("Which planet is closest to the sun?", "Mercury", "MY very educated mother just served us nine pizzas.")
    guess = Guess.new("Saturn", card)
    assert_equal card, guess.card
    assert_equal "Saturn", guess.response
    refute guess.correct?
    assert_equal "Incorrect.", guess.feedback
  end
  def test_making_a_deck_with_multiple_cards
    card_1 = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    card_2 = Card.new("The viking spacecraft sent back to Earth photographs and reports abut the surface of which planet?", "Mars","It's the red planet.")
    card_3 = Card.new("Describe in words the exact direction that is 697.5 degrees clockwise from due north.", "North north west","It's a little more north than north west.")
    deck = Deck.new([card_1, card_2, card_3])
    assert_equal [card_1, card_2, card_3], deck.cards
    assert_equal 3, deck.count
  end
  def testing_through_a_round
    card_1 = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    card_2 = Card.new("Approximately how many miles are in one astronomical unit?", "93,000,000", "93 Bees")
    deck = Deck.new([card_1, card_2])
    round = Round.new(deck)
    assert_equal deck, round.deck
    assert_equal [], round.guesses
    assert_equal card_1, round.current_card
    assert_equal round.guesses[0], round.record_guess("Juneau")
    assert_equal 1, round.guesses.count
    assert_equal "Correct!", round.guesses.first.feedback
    assert_equal 1, round.number_correct
    assert_equal card_2, round.current_card
    assert_equal round.guesses[1], round.record_guess("2")
    assert_equal 2, round.guesses.count
    assert_equal "Incorrect.", round.guesses.last.feedback
    assert_equal 1, round.number_correct
    assert_equal 50, round.percent_correct
  end
  def test_creating_deck_from_text_file
    filename = 'cards.txt'
    cards = CardGenerator.new(filename)
    deck = Deck.new(cards.cards)
    assert_equal "What is 5 + 5?", deck.cards[0].question
    assert_equal "10", deck.cards[0].answer
    assert_equal "You should know this.", deck.cards[0].hint
    assert_equal 4, deck.count
  end
=begin
THE TESTS COMMENTED OUT BELOW READ AND WRITE FILES!!  BE SURE TO DELETE THE TEST FILES IF YOU RUN THESE!!!
  def test_saving_deck_to_text_file
    local_card_collection = "What is the capital of Colorado?;Denver;The mile high city.\nWhat is the best football team in the nation?;Denver Broncos;Super Bowl 50 champs.\n"
    filename = "test cards.txt"
    deck_creation = CreateNewDeckFile.new(local_card_collection)
    refute deck_creation.filename_exist?(filename), "Somehow we found a file called #{filename}"
    deck_creation.save_file
    assert deck_creation.filename_exist?(filename), "The file did not save!"
    assert_equal "What is the capital of Colorado?;Denver;The mile high city.\nWhat is the best football team in the nation?;Denver Broncos;Super Bowl 50 champs.\n", File.read(filename)
  end
  def test_saving_results_to_file
    card_1 = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    card_2 = Card.new("Approximately how many miles are in one astronomical unit?", "93,000,000", "93 Bees")
    deck = Deck.new([card_1, card_2])
    round = Round.new(deck)
    round.record_guess("Juneau")
    round.record_guess("2")
    round.save_results
    assert File.exist?("#{Date.today.strftime('%Y-%m-%d')}-#{Time.now.hour.to_s}:#{Time.now.min.to_s}.txt")
  end
=end
  def test_reshuffling_incorrect_cards
    card_1 = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    card_2 = Card.new("Approximately how many miles are in one astronomical unit?", "93,000,000", "93 Bees")
    deck = Deck.new([card_1, card_2])
    round = Round.new(deck)
    round.extra_practice(true)
    round.record_guess("Denver")
    refute round.guesses[0].correct?
    assert_equal 2, round.deck.count
    assert_equal round.guesses[-1].card, round.previous_card
  end
  def test_hint_functionality
    card_1 = Card.new("What is the capital of Alaska?","Juneau","A famous movie shares the same name.")
    deck = Deck.new([card_1])
    round = Round.new(deck)
    assert_equal "A famous movie shares the same name.", round.hint_to_current_question
    assert_equal "A famous movie shares the same name.", round.current_card.hint
  end
end
