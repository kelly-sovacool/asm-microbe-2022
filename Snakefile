readme_head = """# asm-microbe-abstract-2020

Analysis repo: [OptiFitAnalysis](https://github.com/SchlossLab/OptiFitAnalysis/tree/master/subworkflows/2_fit_sample_ref/results)

To render the abstract, run:
```bash
snakemake
```

See the [submission](submission) directory for the R Markdown source & rendered files.

"""

rule targets:
    input:
        "submission/abstract.pdf",
        "README.md"

rule render_pdf:
    input:
        code="code/render.R",
        rmd="submission/abstract.Rmd",
        preamble="submission/preamble.tex"
    output:
        pdf="submission/abstract.pdf",
        md="submission/README.md"
    shell:
        """
        Rscript {input.code}
        rm submission/README.html
        """

rule char_count_readme:
    input:
        md=rules.render_pdf.output.md
    output:
        md="README.md"
    run:
        with open(input.md, 'r') as infile:
            is_body = False
            text = list()
            for line in infile:
                line = line.strip()
                if "References" in line:
                    break
                elif is_body:
                    text.append(line.replace(' ', ''))
                elif "Abstract" in line:
                    is_body = True
        chars = ''.join(text)
        with open(output.md, 'w') as outfile:
            outfile.write(readme_head)
            outfile.write(f"Character count (excluding whitespace): **{len(chars)}**")

