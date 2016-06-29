# Method to run card_number array through the alogrithm
def luhn_algorithm(card_number)
  calculated_number = []   # Empty array to dump the calculated numbers into
  card_number.each.with_index do |num, index|
    num = num.to_i     # Converts element in array from a string to integer
    if index.even? || index == 0
      calculated_number << num
    else
      calculated_number << over_ten_split(num * 2) if (num * 2) >= 10  # Calls method to convert double digit numbers
      calculated_number << (num * 2) if (num * 2) < 10
    end
  end
  return calculated_number
end
# Method to convert double digit numbers by adding the tens digit and ones digit together
def over_ten_split(number)
  return (1 + (number - 10))
end

loop do
  print "Please input card number or 0 to quit: "
  card_number = gets.chomp
  #card_number = "4929735477250543"
  break if card_number == '0'
  card_number = card_number.reverse.split(//)
  card_number = luhn_algorithm(card_number)
  algorithm_sum = 0  # Empty integer to dump the sum of all the digits into
  card_number.each {|number| algorithm_sum += number} # Adds up all the digits in the algorithm card number
  if (algorithm_sum % 10) == 0   # Tests to determine if card is valid or invalid
    puts "The card number is valid."
  else
    puts "The card number is invalid."
  end
end
