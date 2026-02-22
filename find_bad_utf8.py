import sys

def find_bad_line(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            for i, line in enumerate(f, 1):
                pass
        print("All lines are valid UTF-8")
    except UnicodeDecodeError as e:
        print(f"Unicode Error on line {i}")
        print(f"Error: {e}")
        with open(filepath, 'rb') as f:
            f.seek(e.start - 20 if e.start > 20 else 0)
            context = f.read(40)
            print(f"Bynary context: {context.hex()}")

if __name__ == "__main__":
    find_bad_line(sys.argv[1])
