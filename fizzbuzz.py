import tomllib
# import os
from pprint import pprint


# fizzbuzz
def fizzbuzz(loop_index: int):
    for i in range(1, loop_index):
        if i % 15 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)


def toml_load():
    with open("/home/yasunori/dotfiles/config/nvim/toml/dpp.toml", "rb") as f:
        toml_data = tomllib.load(f)
    pprint(toml_data)


if __name__ == "__main__":
    toml_load()
