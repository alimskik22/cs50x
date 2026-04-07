#include <cs50.h>
#include <stdio.h>

int main(void)
{
    // prompt user for height of pyramid
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height < 1);

    // print pyramid
    for (int row = 0; row < height; row++)
    {

        // print space
        for (int s = 0; s < height - row - 1; s++)
        {
            printf(" ");
        }
        // print #
        for (int i = 0; i < row + 1; i++)
        {
            printf("#");
        }

        printf("\n");
    }
}
