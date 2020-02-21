
if (exists("snakemake")) {
    format <- snakemake@params[['format']]
    input_file <- snakemake@input[['rmd']]
    output_file <- snakemake@output[['file']]
}
else {
    format <- 'pdf_document'
    input_file <- here::here("submission", "abstract.Rmd")
    output_file <- here::here("submission", "abstract.pdf")
}
# TODO: dictionary mapping input file extensions to format strings
rmarkdown::render(input_file,
                  output_format=format,
                  output_file=output_file)
