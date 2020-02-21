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
        "abstract/abstract.pdf",
        "abstract/README.md",
        "README.md",
        "poster/poster.html"

rule render_abstract_pdf:
    input:
        code="code/render.R",
        rmd="abstract/abstract.Rmd",
        preamble="abstract/preamble.tex"
    output:
        file="abstract/abstract.pdf"
    params:
        format="pdf_document"
    script:
        "{input.code}"

rule render_abstract_md:
    input:
        code="code/render.R",
        rmd="abstract/abstract.Rmd",
        preamble="abstract/preamble.tex"
    output:
        file="abstract/README.md",
        html=temp("abstract/README.html")
    params:
        format="github_document"
    script:
        "{input.code}"

rule char_count_readme:
    input:
        md=rules.render_abstract_md.output.file
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

rule download_logos:
    output:
        "figures/mothur_RGB.png"
    params:
        urls=['https://raw.githubusercontent.com/mothur/logo/master/mothur_RGB.png']
    shell:
        """
        for url in {params.urls};
        do
            wget $url -P figures/
        done
        """


rule render_poster:
    input:
        code="code/render.R",
        rmd="poster/poster.Rmd",
        logos=rules.download_logos.output
    output:
        file="poster/poster.html"
    script:
        "{input.code}"