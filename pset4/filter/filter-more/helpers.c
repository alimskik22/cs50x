#include "helpers.h"
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // Take average of red, green, and blue
            int value =
                round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            // Update pixel values
            image[i][j].rgbtRed = value;
            image[i][j].rgbtGreen = value;
            image[i][j].rgbtBlue = value;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            RGBTRIPLE temp = image[i][j];
            image[i][j] = image[i][width - 1 - j];
            image[i][width - 1 - j] = temp;
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE copy[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int totalRed = 0;
            int totalGreen = 0;
            int totalBlue = 0;
            int count = 0;

            // Check neighbors in 3x3 grid
            for (int di = -1; di <= 1; di++)
            {
                for (int dj = -1; dj <= 1; dj++)
                {
                    int new_i = i + di;
                    int new_j = j + dj;

                    if (new_i >= 0 && new_i < height && new_j >= 0 && new_j < width)
                    {
                        totalRed += copy[new_i][new_j].rgbtRed;
                        totalGreen += copy[new_i][new_j].rgbtGreen;
                        totalBlue += copy[new_i][new_j].rgbtBlue;
                        count++;
                    }
                }
            }

            image[i][j].rgbtRed = round((float) totalRed / count);
            image[i][j].rgbtGreen = round((float) totalGreen / count);
            image[i][j].rgbtBlue = round((float) totalBlue / count);
        }
    }
    return;
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE copy[height][width];
    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int Gy[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int GxRed = 0, GyRed = 0;
            int GxGreen = 0, GyGreen = 0;
            int GxBlue = 0, GyBlue = 0;
            int red = 0;
            int green = 0;
            int blue = 0;

            // Check neighbors in 3x3 grid
            for (int di = -1; di <= 1; di++)
            {
                for (int dj = -1; dj <= 1; dj++)
                {
                    int new_i = i + di;
                    int new_j = j + dj;

                    if (new_i >= 0 && new_i < height && new_j >= 0 && new_j < width)
                    {
                        GxRed += copy[new_i][new_j].rgbtRed * Gx[di + 1][dj + 1];
                        GyRed += copy[new_i][new_j].rgbtRed * Gy[di + 1][dj + 1];
                        GxGreen += copy[new_i][new_j].rgbtGreen * Gx[di + 1][dj + 1];
                        GyGreen += copy[new_i][new_j].rgbtGreen * Gy[di + 1][dj + 1];
                        GxBlue += copy[new_i][new_j].rgbtBlue * Gx[di + 1][dj + 1];
                        GyBlue += copy[new_i][new_j].rgbtBlue * Gy[di + 1][dj + 1];
                    }
                }
            }

            red = round(sqrt(GxRed * GxRed + GyRed * GyRed));
            green = round(sqrt(GxGreen * GxGreen + GyGreen * GyGreen));
            blue = round(sqrt(GxBlue * GxBlue + GyBlue * GyBlue));
            if (red > 255)
            {
                red = 255;
            }
            if (green > 255)
            {
                green = 255;
            }
            if (blue > 255)
            {
                blue = 255;
            }
            image[i][j].rgbtRed = red;
            image[i][j].rgbtGreen = green;
            image[i][j].rgbtBlue = blue;
        }
    }
    return;
}
