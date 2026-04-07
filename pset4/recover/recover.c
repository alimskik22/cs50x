#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define BYTES 512
int main(int argc, char *argv[])
{
    // Accept a single command-line argument
    if (argc != 2)
    {
        printf("Usage: ./recover FILE\n");
        return 1;
    }

    // Open the memory card
    FILE *card = fopen(argv[1], "r");
    if (card == NULL)
    {
        return 1;
    }

    // While there's still data left to read from the memory card
    uint8_t buffer[BYTES];
    char filename[8];
    int counter = 0;
    FILE *new = NULL;
    while (fread(buffer, 1, BYTES, card) == BYTES)
    {
        // If start of a new JPEG
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff &&
            (buffer[3] & 0xf0) == 0xe0)
        {
            if (new != NULL)
            {
                fclose(new);
            }
            sprintf(filename, "%03i.jpg", counter);
            new = fopen(filename, "w");
            fwrite(buffer, 1, BYTES, new);
            counter++;
        }
        else
        {
            if (new != NULL)
            {
                fwrite(buffer, 1, BYTES, new);
            }
        }
    }
    // Close any remaining files
    if (new != NULL)
    {
        fclose(new);
    }

    fclose(card);
}
