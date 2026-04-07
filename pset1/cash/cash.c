#include <cs50.h>

#include <stdio.h>

int calculate_coins(int cents);

int main(void)
{
    // Prompt the user for change owed
    int cents;
    do
    {
        cents = get_int("Change owed: ");
    }
    while (cents <= 0);

    // Calculate how many coins you should give customer
    int coins = calculate_coins(cents);

    // Print that sum
    printf("%i\n", coins);
}

// Calculate coins
int calculate_coins(int cents)
{
    int coins = 0;
    while (cents > 0)
    {
        if (cents >= 25)
        {
            coins++;
            cents = cents - 25;
        }

        else if (cents >= 10)
        {
            coins++;
            cents = cents - 10;
        }
        else if (cents >= 5)
        {
            coins++;
            cents = cents - 5;
        }
        else
        {
            coins++;
            cents = cents - 1;
        }
    }

    return coins;
}
