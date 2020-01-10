datasets=("marine","soil")

rule render:
    input:
        rmd="submission/abstract.Rmd",
        data=expand("results/{dataset}.aggregate.sensspec", dataset=datasets)
    output:
        pdf="submission/abstract.pdf"
    shell:
        """
        Rscript -e "library(rmarkdown); rmarkdown::render('{input.rmd}', output_file='{output.pdf}')"
        """
