source("renv/activate.R")
### print current working directory of R instance
print("#############################################################################")
print("Loading local custom .Rprofile: ~/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/.Rprofile")
print(paste("CURRENT WORKING DIRECTORY:", getwd(), sep = " "))
print("#############################################################################")



### setting CRAN mirror default
local({
    r <- getOption("repos")
    r["CRAN"] <- "https://cran.rstudio.com/"
    options(repos = r)
})
Sys.setenv(RGL_USE_NULL = TRUE)

## Optional: print to confirm
print("renv external.libraries set to:")
print(renv::settings$external.libraries())

### httpgd plot viewer setup
options(vsc.plot = FALSE)
if (interactive() && Sys.getenv("TERM_PROGRAM") == "vscode") {
    if ("httpgd" %in% .packages(all.available = TRUE)) {
        options(vsc.plot = FALSE)
        options(device = function(...) {
            httpgd::hgd(silent = TRUE)
            .vsc.browser(httpgd::hgd_url(history = FALSE), viewer = "Beside")
        })
    }
}

# if (interactive() && Sys.getenv("RSTUDIO") == "") {
#     Sys.setenv(TERM_PROGRAM = "vscode")
#     source(file.path(Sys.getenv(
#         if (.Platform$OS.type == "windows") "USERPROFILE" else "HOME"
#     ), ".vscode-R", "init.R"))
# }

## loading custom fonts
inter_font_load <- function() {
    tryCatch(
        {
            sysfonts::font_add(
                family = "Inter",
                regular = "Inter-Regular.ttf",
                bold = "Inter-Bold.ttf",
                italic = "Inter-Light.ttf"
            )
        },
        warning = function(w) {
            message("WARNING: Custom font ('Inter') failed to load properly. Custom themes may not load properly")
        }
    )
}
inter_font_load()

intel_font_load <- function() {
    tryCatch(
        {
            sysfonts::font_add(
                family = "Intel One",
                regular = "intelone-mono-font-family-regular.ttf",
                bold = "intelone-mono-font-family-bold.ttf",
                italic = "intelone-mono-font-family-italic.ttf"
            )
        },
        warning = function(w) {
            message("WARNING: Custom font ('Intel One') failed to load properly. Custom themes may nto load properly")
        }
    )
}
intel_font_load()

### loading personal theme for dataviz
source("/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/r_materials/theme_personal.R")
