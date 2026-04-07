#include <cs50.h>
#include <stdio.h>

int stl_digit(long card_number);
int products(int last_digit);
int get_length(long number);
int get_start_digits(long number);
int main(void)
{
    // Prompt for credit card number
    long card_number;
    do
    {
        card_number = get_long("Number: ");
    }
    while (card_number <= 0);

    // Calculate checksum
    int sum_stl_digit = stl_digit(card_number);
    // *Multiply every other digit by 2, starting with the number’s second-to-last digit, and then
    // add those products’ digits together. printf("%i\n", sum_stl_digit); *Add the sum to the sum
    // of the digits that weren’t multiplied by 2. *If the total’s last digit is 0 (or, put more
    // formally, if the total modulo 10 is congruent to 0), the number is valid!

    // Check for card length and starting digits
    int length = get_length(card_number);
    int start_digits = get_start_digits(card_number);
    // Print AMEX, MASTERCARD, VISA, or INVALID

    if (sum_stl_digit % 10 != 0)
    {
        printf("INVALID\n");
    }
    else if ((length == 15) && (start_digits == 34 || start_digits == 37))
    {
        printf("AMEX\n");
    }
    else if ((length == 16) && (start_digits >= 51 && start_digits <= 55))
    {
        printf("MASTERCARD\n");
    }
    else if ((length == 13 || length == 16) && (start_digits / 10 == 4))
    {
        printf("VISA\n");
    }
    else
    {
        printf("INVALID\n");
    }
}

// Calculate checksum

int stl_digit(long card_number)
{
    int sum = 0;
    bool isEveryOtherDigit = false;
    while (card_number > 0)
    {
        if (isEveryOtherDigit == true)
        {
            int last_digit = card_number % 10;
            int product = products(last_digit);
            sum = sum + product;
        }
        else
        {
            int last_digit = card_number % 10;
            sum = sum + last_digit;
        }
        isEveryOtherDigit = !isEveryOtherDigit;
        card_number = card_number / 10;
    }
    return sum;
}

// Multiply every other digit by 2, starting with the number’s second-to-last digit, and then add
// those products’ digits together.

int products(int last_digit)
{
    int multiply = last_digit * 2;
    int sum = 0;
    while (multiply > 0)
    {
        int last_digit_multiply = multiply % 10;
        sum = sum + last_digit_multiply;
        multiply = multiply / 10;
    }
    return sum;
}

int get_length(long number)
{
    int length = 0;
    while (number > 0)
    {
        number = number / 10;
        length++;
    }
    return length;
}

int get_start_digits(long number)
{
    while (number >= 100)
    {
        number = number / 10;
    }
    return number;
}
