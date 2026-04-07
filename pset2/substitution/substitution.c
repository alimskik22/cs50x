#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, string argv[])
{
    // Get and validate key

    if (argc == 1 || argc > 2)
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }
    int len = strlen(argv[1]);
    if (len != 26)
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }
    int seen[26] = {0};
    for (int n = 0; n < len; n++)
    {
        if (!isalpha(argv[1][n]))
        {
            printf("Key must only contain alphabetic characters\n");
            return 1;
        }
        int index = toupper(argv[1][n]) - 'A';
        if (seen[index] == 1)
        {
            printf("Key must not contain repeated characters\n");
            return 1;
        }
        seen[index] = 1;
    }
    // Get plaintext
    string plaintext = get_string("plaintext:  ");

    // Encipher
    int lenn = strlen(plaintext);
    char ciphertext[lenn + 1];
    for (int n = 0; n < lenn; n++)
    {
        if (isalpha(plaintext[n]))
        {
            if (isupper(plaintext[n]))
            {
                int index = toupper(plaintext[n]) - 'A';
                ciphertext[n] = toupper(argv[1][index]);
            }
            else if (islower(plaintext[n]))
            {
                int index = toupper(plaintext[n]) - 'A';
                ciphertext[n] = tolower(argv[1][index]);
            }
        }
        else
        {
            ciphertext[n] = plaintext[n];
        }
    }
    ciphertext[lenn] = '\0';

    // Print ciphertext
    printf("ciphertext: %s", ciphertext);
    printf("\n");
    return 0;
}
