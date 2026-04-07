#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, string argv[])
{
    if (argc == 1 || argc > 2)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    for (int n = 0, i = strlen(argv[1]); n < i; n++)
    {
        if (!isdigit(argv[1][n]))
        {
            printf("Usage: ./caesar key\n");
            return 1;
        }
    }
    // Convert argument from str to int
    int key = atoi(argv[1]);

    string plaintext = get_string("plaintext:  ");
    // Rotate the chars
    int len = strlen(plaintext);
    char ciphertext[len + 1];
    for (int i = 0; i < len; i++)
    {
        if (isalpha(plaintext[i]))
        {
            if (isupper(plaintext[i]))
            {
                ciphertext[i] = (plaintext[i] - 'A' + key) % 26;
                ciphertext[i] += 'A';
            }
            else if (islower(plaintext[i]))
            {
                ciphertext[i] = (plaintext[i] - 'a' + key) % 26;
                ciphertext[i] += 'a';
            }
        }
        else
        {
            ciphertext[i] = plaintext[i];
        }
    }
    ciphertext[len] = '\0';
    printf("ciphertext: %s", ciphertext);
    printf("\n");
    return 0;
}
