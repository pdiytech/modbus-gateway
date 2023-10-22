import minify_html
import sys
import os.path

n = len(sys.argv)
if n < 2:
  print("Error: argument invalid")
  exit(1)

ifile = sys.argv[1]

if(os.path.isfile(ifile) == False):
  print("Error: input file path invalid")
  exit(1)

# Get file name
fileex = ifile.split("/")
filename = fileex[len(fileex)-1]

# Minify
f = open(ifile, "r")
fr = f.read()
f.close()

minified = minify_html.minify(fr, minify_js=True, remove_processing_instructions=True)
print("Minify file", filename, "from:", len(fr), "to:", len(minified))

ofile_path = "_minify/"+filename
f = open(ofile_path, "w")
f.write(minified)
print("Write to", ofile_path)
f.close()
