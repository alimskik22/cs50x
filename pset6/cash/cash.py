from cs50 import get_float

while True:
    dollars = get_float("Change owed: ")
    if dollars > 0:
        break

# Convert dollars to cents
dollars = dollars * 100
coins = 0
while dollars > 0:
    if dollars >= 25:
        coins += 1
        dollars = dollars - 25

    elif dollars >= 10:
        coins += 1
        dollars = dollars - 10

    elif dollars >= 5:
        coins += 1
        dollars = dollars - 5
    else:
        coins += 1
        dollars = dollars - 1

print(coins)
