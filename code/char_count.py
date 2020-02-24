with open(snakemake.input.md, "r") as infile:
    is_body = False
    text = list()
    for line in infile:
        line = line.strip()
        if "References" in line:
            break
        elif is_body:
            text.append(line.replace(" ", ""))
        elif "Abstract" in line:
            is_body = True
char_count = str(len("".join(text)))
with open(snakemake.output.txt, "w") as outfile:
    outfile.write(char_count)
