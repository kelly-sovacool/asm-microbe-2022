library(here)
library(rmarkdown)

rmd_file = here::here("submission", "abstract.Rmd")
pdf_file = here::here("submission", "abstract.pdf")
gh_file = here::here("submission", "README.md")

rmarkdown::render(rmd_file,
                  output_format='pdf_document',
                  output_file=pdf_file)
rmarkdown::render(rmd_file,
                  output_format='github_document',
                  output_file=gh_file)
