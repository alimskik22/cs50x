#include <cs50.h>
#include <stdio.h>

void print_pyramid(int n);
int get_height(void);
int main(void)
{
    // ask and execute pyramid
    int height = get_height();
    print_pyramid(height);
}

int get_height(void)
{
    // prompt user for the height
    int height;
    do
    {
        height = get_int("Height: ");
    }
    while (height <= 0 || height > 8);
    return height;
}

void print_pyramid(int height)
{
    // print pyramid

    for (int row = 0; row < height; row++)
    {

        // print space
        for (int s = 0; s < height - row - 1; s++)
        {
            printf(" ");
        }
        // print #p1
        for (int i = 0; i < row + 1; i++)
        {
            printf("#");
        }

        // print space
        printf("  ");

        // print #p2
        for (int a = 0; a < row + 1; a++)
        {
            printf("#");
        }

        printf("\n");
    }
}
