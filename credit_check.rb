# Method to convert numbers that are 10 or over
def over_ten(number)
  temp_tens = number.to_s[0]
  temp_ones = number.to_s[1]
  return (temp_ones.to_i + temp_tens.to_i)
end

# Algorithm to run through convert_number and create key_number which will be used to check the check_digit
def luhn_algorithm(number, check_digit = nil)
  key_number = ""
  if check_digit == nil
    counter = number.length - 2
  else
    counter = number.length - 1
  end
  while counter >= 0
    digit = number[counter].to_i * 2
    digit = over_ten(digit) if digit >= 10
    if counter == (number.length - 1) && check_digit == nil
      key_number = digit.to_s
    else
      key_number = digit.to_s + number[counter+1].to_s + key_number
    end
    counter -= 2
  end
  return key_number
end

# calculating the sum of all the numbers in the key_number to get the check_digit
def confirm_number(number, digit, modulo = nil)
  counter = 0
  check_it = 0
  while counter <= (number.length - 1)
    check_it += number[counter].to_i
    counter += 1
  end
  # check_it now equals the sum of the number provided
  if modulo == nil
    check_it = 10 - check_it.to_s[1].to_i
    check_it = 0 if check_it == 10
    return true if check_it == digit
    return false if check_it != digit
  else
    check_it = check_it % 10
    return true if check_it == 0
    return false if check_it != 0
  end
end

print "Please input card number: "
card_number = gets.chomp
check_digit = card_number[card_number.length - 1].to_i
convert_number = card_number.chop
# check_digit is now the last digit of the card number given
# convert_number is the card_number without the check_digit
# card_number is the complete credit card number

key_number = luhn_algorithm(convert_number, true)
valid = confirm_number(key_number, check_digit)

if valid == true
  key_number = luhn_algorithm(card_number)
  puts card_number
  puts key_number
  valid = confirm_number(key_number, check_digit, true)
  puts "The number is valid!" if valid == true
  puts "The number is invalid!" if valid == false
else
  puts "The number is invalid!"
end
