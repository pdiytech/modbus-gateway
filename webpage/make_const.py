import sys

def main(argv):
  if len(argv) < 2:
    return
  filename = argv[1]

  f = open(filename, "r")
  f_content = f.read()
  f.close()

  f_content = f_content.replace("unsigned char", "const unsigned char")

  f = open(filename, "w")
  f.write(f_content)
  f.close()

  print("Update file: " + filename)

if __name__ == "__main__":
  main(sys.argv)