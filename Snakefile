readme_head = """# asm-microbe-2020

Analysis repo: [OptiFitAnalysis](https://github.com/SchlossLab/OptiFitAnalysis/tree/master/subworkflows/2_fit_sample_ref/results)

To render the abstract & poster, run:
```bash
snakemake
```

See the [submission/](submission) directory for the R Markdown source for the abstract & poster. View the rendered poster [here](https://sovacool.dev/asm-microbe-2020/poster.html).

"""

rule targets:
    input:
        "README.md",
        "docs/abstract.pdf",
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

rule count_chars:
    input:
        code="code/char_count.py",
        md=rules.render_abstract_md.output.file
    output:
        txt="submission/char_count.txt"
    script:
        "{input.code}"

rule render_readme:
    input:
        code="code/render.R",
        rmd="README.Rmd",
        txt=rules.count_chars.output.txt
    output:
        file="README.md",
        html=temp("README.html")
    params:
        format="github_document"
    script:
        "{input.code}"


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
