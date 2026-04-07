while True:
    try:
        height = int(input("Height: "))
    except ValueError:
        continue
    if height < 9 and height > 0:
        break


for row in range(height):
    for s in range(height - row - 1):
        print(" ", end="")
    for i in range(row + 1):
        print("#", end="")
    print()
