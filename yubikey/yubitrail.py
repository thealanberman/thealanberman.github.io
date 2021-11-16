#!/usr/bin/env python3

import sys
import random

score = -56  # subtract 56 because all OTPs start with vvcccc
vowels = ["a", "e", "i", "o", "u", "y"]
positives = [
    "Found wild fruit.",
    "Hunted a bear.",
    "Bought a wagon wheel.",
    "Caulked the wagon and floated across.",
    "Hunted a squirrel.",
    "Mended the wagon yoke."
]
negatives = [
    "Bandits shot Jenkins.",
    "Ethel has typhoid.",
    "Steve has a broken arm.",
    "Stacy has cholera.",
    "Jimbo has measles.",
    "Wagon was attacked by wolves.",
    "Wagon broke an axle.",
    "Wagon capsized in the river.",
    "Lose the trail, lose 12 days.",
    "Mosquitos!",
    "Bad water.",
    "No water.",
    "An ox died."
]
otp = str(sys.argv[1])

for letter in otp:
    number = ord(letter) - 96  # a=1,b=2,etc.
    if letter in vowels:
        print(random.choice(positives))
        score = score + number + 50
    else:
        print(random.choice(negatives))
        score = score - number

print("==============================")
if score < 1:
    print("You have died of dysentery.")
else:
    print("You made it to Oregon!")
print(f'Final score: {score}')

# https://learn.hashicorp.com/terraform/aws/lambda-api-gateway
