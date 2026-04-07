def main():
    # Prompt the user for some text
    text = input("Text: ")

    # Count the number of letters, words, and sentences in the text
    number_of_letters = count_letters(text)
    number_of_words = count_words(text)
    number_of_sent = count_sentences(text)

    # Compute the Coleman-Liau index
    l = (number_of_letters / number_of_words) * 100
    s = (number_of_sent / number_of_words) * 100
    index = 0.0588 * l - 0.296 * s - 15.8

    # Print the grade level
    if index < 1:
        print("Before Grade 1")

    elif index < 16:
        print(f"Grade {round(index)}")

    if index >= 16:
        print("Grade 16+")


def count_letters(text):
    number_of_letters = 0

    for n in range(len(text)):
        if text[n].isalpha():
            number_of_letters += 1

    return number_of_letters


def count_words(text):
    number_of_words = 1
    for n in range(len(text)):
        if text[n].isspace():
            number_of_words += 1

    return number_of_words


def count_sentences(text):
    number_of_sent = 0
    for n in range(len(text)):
        if text[n] == '.' or text[n] == '!' or text[n] == '?':
            number_of_sent += 1

    return number_of_sent


main()
