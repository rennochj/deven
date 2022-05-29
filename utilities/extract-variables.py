import sys
import re

if __name__ == "__main__":
 
    variable_re = "variable\s+\"([a-zA-Z0-9_-]+)\"\s+\{(.*?)\}"
    default_re = "default\s+=\s+(.*?)\n"

    file = open(sys.argv[1] + "/variables.tf", "r")
    content = file.read()
    file.close

    for v, d in sorted( re.findall( variable_re, content, re.MULTILINE | re.DOTALL), key=lambda tup: tup[0]):
        value = re.search(default_re, d, re.MULTILINE | re.DOTALL)
        print(f"{'' if value == None else '# '}{v} = {'' if value == None else value.group(1)}")



