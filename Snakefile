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

rule char_count:
    input:
        rmd="submission/abstract.Rmd"
    run:
        with open(input.rmd, 'r') as file:
            is_body = False
            text = list()
            for line in file:
                line = line.strip()
                if is_body:
                    # TODO: strip citations
                    text.append(line.replace(' ', ''))
                if line == "<!-- abstract body -->":
                    is_body = True
        chars = ''.join(text)
        print(text)
        print("Character count: ", len(chars))