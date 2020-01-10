datasets=("marine","soil")

rule render_pdf:
    input:
        code="code/render.R",
        rmd="submission/abstract.Rmd",
        preamble="submission/preamble.tex",
        data=expand("results/{dataset}.aggregate.sensspec", dataset=datasets)
    output:
        pdf="submission/abstract.pdf",
        md="submission/README.md"
    shell:
        """
        Rscript {input.code}
        rm submission/README.html
        """