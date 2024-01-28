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


if __name__ == "__main__":
    fizzbuzz(100)
