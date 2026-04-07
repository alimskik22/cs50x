#include <cs50.h>
#include <ctype.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

int count_letters(string text);
int count_words(string text);
int count_sentences(string text);

int main(void)
{
    // Prompt the user for some text
    string text = get_string("Text: ");

    // Count the number of letters, words, and sentences in the text

    int number_of_letters = count_letters(text);
    int number_of_words = count_words(text);
    int number_of_sent = count_sentences(text);

    // Compute the Coleman-Liau index

    float l = (number_of_letters / (float) number_of_words) * 100;
    float s = (number_of_sent / (float) number_of_words) * 100;
    float index = 0.0588 * l - 0.296 * s - 15.8;

    // Print the grade level
    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index < 16 && index >= 1)
    {
        printf("Grade %i\n", (int) round(index));
    }

    if (index >= 16)
    {
        printf("Grade 16+\n");
    }
}

int count_letters(string text)
{
    int number_of_letters = 0;

    for (int n = 0, i = strlen(text); n < i; n++)
    {

        if (isalpha(text[n]))
        {
            number_of_letters++;
        }
    }
    return number_of_letters;
}

int count_words(string text)
{
    int number_of_words = 1;
    for (int n = 0, i = strlen(text); n < i; n++)
    {

        if (isspace(text[n]))
        {
            number_of_words++;
        }
    }
    return number_of_words;
}

int count_sentences(string text)
{
    int number_of_sent = 0;
    for (int n = 0, i = strlen(text); n < i; n++)
    {

        if (text[n] == '.' || text[n] == '!' || text[n] == '?')
        {
            number_of_sent++;
        }
    }
    return number_of_sent;
}
