print "Please input card number: "
card_number = gets.chomp
#card_number = "4929735477250543"
valid = false
card_length = card_number.length - 1
luhn_algorithm = []

counter = 0
while counter <= card_length
  luhn_algorithm.push(card_number[counter].to_i)
  counter += 1
end

card_number = luhn_algorithm
luhn_algorithm = []
counter = 0
card_number.each do |number|
  if card_length - counter == 0
    luhn_algorithm.push(number)
  elsif (card_length - counter) % 2 != 0
    if (number * 2) >= 10
      temp_tens = (number*2).to_s[0].to_i
      temp_ones = (number*2).to_s[1].to_i
      number = temp_tens + temp_ones
      luhn_algorithm.push(number)
    else
      luhn_algorithm.push(number*2)
    end
  else
    luhn_algorithm.push(number)
  end
  counter += 1
end

check_number = 0
luhn_algorithm.each do |number|
  check_number += number
end

puts "The number is valid!" if (check_number%10) == 0
puts "The number is invalid!" if (check_number%10) != 0
