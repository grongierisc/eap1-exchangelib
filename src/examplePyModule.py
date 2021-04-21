import sys

def printSomething():
    sys.stdout.write("Hello World\n")

def returnList():
    return ['a', 'b', 'c', 3.14159]

def returnDict():
    return {'a':1, 'b':2, 'c':3}

if __name__ == "__main__" :
    printSomething()
    print(returnList())
    print(returnDict())
    exit()

