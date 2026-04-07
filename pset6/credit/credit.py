def main():
    while True:
        try:
            card_number = int(input("Number: "))
        except ValueError:
            continue
        if card_number > 0:
            break

    sum_stl_digit = stl_digit(card_number)
    length = get_length(card_number)
    start_digits = get_start_digits(card_number)

    if sum_stl_digit % 10 != 0:
        print("INVALID")

    elif length == 15 and (start_digits == 34 or start_digits == 37):
        print("AMEX")

    elif length == 16 and (start_digits >= 51 and start_digits <= 55):
        print("MASTERCARD")

    elif (length == 13 or length == 16) and start_digits // 10 == 4:
        print("VISA")

    else:
        print("INVALID")


def stl_digit(card_number):
    sum = 0
    isEveryOtherDigit = False
    while card_number > 0:
        if isEveryOtherDigit == True:
            last_digit = card_number % 10
            product = products(last_digit)
            sum = sum + product
        else:
            last_digit = card_number % 10
            sum = sum + last_digit
        isEveryOtherDigit = not isEveryOtherDigit
        card_number = card_number // 10

    return sum


def products(last_digit):
    multiply = last_digit * 2
    sum = 0
    while multiply > 0:
        last_digit_multiply = multiply % 10
        sum = sum + last_digit_multiply
        multiply = multiply // 10

    return sum


def get_length(number):
    length = 0
    while number > 0:
        number = number // 10
        length += 1

    return length


def get_start_digits(number):
    while number >= 100:
        number = number // 10

    return number


main()
