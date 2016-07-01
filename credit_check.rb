# Method to run card_number array through the alogrithm
def luhn_algorithm(card_number)
  card_number.map.with_index do |num, index|
    num = num.to_i     # Converts element in array from a string to integer
    if index.even?
      num
    else
      if (num * 2) >= 10
        over_ten_split(num * 2)  # Calls method to convert double digit numbers
      else
        num * 2
      end
    end
  end
end
# Method to convert double digit numbers by adding the tens digit and ones digit together
def over_ten_split(number)
  return (number - 10).succ
end

loop do
  print "Please input card number or 0 to quit: "
  card_number = gets.chomp
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
