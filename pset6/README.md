# Problem Set 6

This problem set transitions from C to Python, re-implementing familiar problems while introducing new concepts like DNA pattern matching.

## Problems

| Problem | Difficulty | Description |
|---------|-----------|-------------|
| [Sentimental / Hello](/pset6/hello/) | Warmup | Greet the user with "Hello, `[name]`" (now in Python) |
| [Sentimental / Mario](/pset6/mario/) | Less / More | Build a pyramid of `#` characters (Python version) |
| [Sentimental / Cash](/pset6/cash/) | Less | Calculate minimum coins for change (Python version) |
| [Sentimental / Credit](/pset6/credit/) | More | Validate credit card numbers using Luhn's algorithm (Python version) |
| [Sentimental / Readability](/pset6/readability/) | Less | Compute grade level using Coleman-Liau index (Python version) |
| [DNA](/pset6/dna/) | Practice | Identify person based on STR (short tandem repeat) patterns in DNA |

## What I Learned

- **Python syntax**: No semicolons, no curly braces, indentation matters
- **Data types**: `str`, `int`, `float`, `list`, `dict` (vs C's strict types)
- **Built-in functions**: `len()`, `range()`, `print()`, `open()`, `max()`
- **String methods**: `.strip()`, `.upper()`, `.lower()`, `.split()`, `.find()`
- **File I/O**: `open()`, `read()`, `readlines()`, `csv.DictReader`
- **Lists vs arrays**: Dynamic sizing, slicing, list comprehensions
- **Dictionaries**: Key-value pairs for DNA database matching
- **CSV parsing**: Reading and processing structured data


## C vs Python Comparison

| Concept | C | Python |
|---------|---|--------|
| **Printing** | `printf("Hello, %s\n", name);` | `print(f"Hello, {name}")` |
| **String input** | `get_string("Name: ")` | `input("Name: ")` |
| **Integer input** | `get_int("Number: ")` | `int(input("Number: "))` |
| **String length** | `strlen(s)` | `len(s)` |
| **String indexing** | `s[i]` (char) | `s[i]` (str of length 1) |
| **For loops** | `for (int i = 0; i < n; i++)` | `for i in range(n):` |
| **Lists/Arrays** | Fixed size with `int arr[n]` | Dynamic with `list = []` |
| **Dictionaries** | Not built-in (hash table needed) | Built-in `dict = {}` |
| **File reading** | `fopen()`, `fread()`, `fclose()` | `with open(file) as f:` |


## DNA Problem Breakdown

The DNA problem identifies a person by matching STR counts:

| Step | What it does |
|------|--------------|
| **1. Parse databases** | Read CSV file containing names and STR counts |
| **2. Read sequence** | Load the DNA sequence text file |
| **3. Compute STR repeats** | Count longest consecutive repeats for each STR in the sequence |
| **4. Find match** | Compare computed counts against database entries |
| **5. Output result** | Print matching name or "No match" |

### STR Counting Algorithm

```python
def longest_match(sequence, subsequence):
    # Returns maximum number of consecutive repeats of subsequence in sequence
    # Example: "AAAA" with subsequence "AA" returns 2
