# compiles all the reports in the .rmds/ directory
#source("functions/make_reports.R")
if (!("pacman" %in% installed.packages())){
  install.packages("pacman")
}
pacman::p_load(rmarkdown) 
# compile individual reports
render("rmds/01_Import.Rmd", "all", output_dir = "reports")
render("rmds/02_Tidy.Rmd", "all", output_dir = "reports")
render("rmds/03_Analyses.Rmd", output_dir = "reports")
render("", "all", output_dir = "reports")

# render(input, output_format = NULL, output_file = NULL, output_dir = NULL,
#        output_options = NULL, intermediates_dir = NULL,
#        knit_root_dir = NULL,
#        runtime = c("auto", "static", "shiny", "shiny_prerendered"),
#        clean = TRUE, params = NULL, knit_meta = NULL, envir = parent.frame(),
#        run_pandoc = TRUE, quiet = FALSE, encoding = getOption("encoding"))
render("rmds/01_Import.Rmd", "all", output_dir = "reports")