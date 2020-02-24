readme_head = """# asm-microbe-2020

Analysis repo: [OptiFitAnalysis](https://github.com/SchlossLab/OptiFitAnalysis/tree/master/subworkflows/2_fit_sample_ref/results)

To render the abstract & poster, run:
```bash
snakemake
```

See the [submission/](submission) directory for the R Markdown source for the abstract & poster. See the [docs/](docs) directory for the rendered PDF/HTML.
"""

rule targets:
    input:
        "docs/abstract.pdf",
        "README.md",
        "docs/poster.html"

rule render_abstract_pdf:
    input:
        code="code/render.R",
        rmd="submission/abstract.Rmd",
        preamble="submission/preamble.tex"
    output:
        file="docs/abstract.pdf"
    params:
        format="pdf_document"
    script:
        "{input.code}"

rule render_abstract_md:
    input:
        code="code/render.R",
        rmd="submission/abstract.Rmd",
        preamble="submission/preamble.tex"
    output:
        file="submission/README.md",
        html=temp("submission/README.html")
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
        "figures/mothur_RGB.png",
        "figures/u-m_logo-hex.png"
    params:
        urls=['https://raw.githubusercontent.com/mothur/logo/master/mothur_RGB.png',
              'https://brand.umich.edu/assets/brand/downloads/um-logos/primary_logo_kit/color-logo/u-m_logo-hex.png']
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
        rmd="submission/poster.Rmd",
        logos=rules.download_logos.output
    output:
        file="docs/poster.html"
    script:
        "{input.code}"
