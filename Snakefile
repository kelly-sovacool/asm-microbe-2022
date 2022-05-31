rule targets:
    input:
        "README.md",
        "docs/abstract.pdf",
        "docs/poster.html"

rule render_abstract_pdf:
    input:
        code="code/render.R",
        rmd="abstract.Rmd",
        preamble="preamble.tex"
    output:
        file="docs/abstract.pdf"
    params:
        format="pdf_document"
    script:
        "code/render.R"

rule render_abstract_md:
    input:
        code="code/render.R",
        rmd="abstract.Rmd",
        preamble="preamble.tex"
    output:
        file="abstract.md",
        html=temp("abstract.html")
    params:
        format="github_document"
    script:
        "code/render.R"

rule count_chars:
    input:
        code="code/char_count.py",
        md=rules.render_abstract_md.output.file
    output:
        txt="char_count.txt"
    script:
        "code/char_count.py"

rule render_readme:
    input:
        code="code/render.R",
        rmd="README.Rmd",
        txt=rules.count_chars.output.txt
    output:
        file="README.md"
    params:
        format="github_document"
    script:
        "code/render.R"


rule download_logos:
    output:
        mothur="figures/mothur_RGB.png",
        umich="figures/u-m_logo-hex.png",
        smk="figures/biglogo.png",
        schlab='figures/triple-hex-logos.png'
    params:
        urls=['https://raw.githubusercontent.com/mothur/logo/master/mothur_RGB.png',
              'https://brand.umich.edu/assets/brand/downloads/um-logos/primary_logo_kit/color-logo/u-m_logo-hex.png',
              'https://raw.githubusercontent.com/snakemake/snakemake/master/images/biglogo.png',
              'https://raw.githubusercontent.com/SchlossLab/logos/main/triple-hex-logos.png']
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
        rmd="poster.Rmd",
        logos=rules.download_logos.output
    output:
        file="docs/poster.html"
    script:
        "code/render.R"
