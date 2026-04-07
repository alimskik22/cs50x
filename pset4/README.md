# Problem Set 4

This problem set introduces pointers, file I/O, image processing, and data recovery at the byte level.

## Problems

| Problem | Difficulty | Description |
|---------|-----------|-------------|
| [Volume](/pset4/volume/) | Warmup | Modify audio volume of a WAV file by reading/writing 16-bit samples |
| [Filter (less)](/pset4/filter/filter-less/) | Less | Apply image filters: grayscale, sepia, reflect, blur |
| [Filter (more)](/pset4/filter/filter-more/) | More | Advanced filters: edges (Sobel operator) in addition to all less filters |
| [Recover](/pset4/recover/) | Practice | Recover JPEG images from a raw memory card forensic image |

## What I Learned

- **File I/O**: `fopen`, `fread`, `fwrite`, `fclose`
- **Pointers**: Working with memory addresses and buffer arrays
- **Bitwise operations**: Manipulating individual bytes and bits
- **Audio processing**: Reading/writing 16-bit samples (WAV format)
- **Image processing**: RGB pixel manipulation, convolution, Sobel operator
- **Forensic recovery**: Detecting JPEG signatures (`0xff 0xd8 0xff`) in raw data
- **Memory management**: Working with buffers of different sizes (512 bytes for JPEGs)
