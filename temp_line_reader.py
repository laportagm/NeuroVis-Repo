
import sys

def read_line(file_path, line_number):
    with open(file_path, 'r') as file:
        lines = file.readlines()
        if 1 <= line_number <= len(lines):
            return f"Line {line_number}: {lines[line_number - 1]}"
        else:
            return f"Line number {line_number} out of range (file has {len(lines)} lines)"

if __name__ == "__main__":
    file_path = "/Users/gagelaporta/A1-NeuroVis/scripts/DebugCommands.gd"
    line_number = 38
    print(read_line(file_path, line_number))
