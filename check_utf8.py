import sys

def check_utf8(filepath):
    try:
        with open(filepath, 'rb') as f:
            content = f.read()
        content.decode('utf-8')
        print("File is valid UTF-8")
    except UnicodeDecodeError as e:
        print(f"ERROR: {e}")
        print(f"Position: {e.start}")
        # Show some context around the error
        start = max(0, e.start - 50)
        end = min(len(content), e.start + 50)
        print(f"Context (hex): {content[start:end].hex()}")
        print(f"Context (raw): {content[start:end]}")

if __name__ == "__main__":
    check_utf8(sys.argv[1])
