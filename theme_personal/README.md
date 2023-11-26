# Joshua Yuki Levy -- Personal Visual Identity Guide

## About

The materials contained in this repo represent the basis for my (Joshua's) personal Visual Identity Guide.

The goal of this design system is to bring greater consistency in the visual materials I produce. I think that data visualization is a particularly useful tool for making clear conclusions about data that are, by definition, abstract.

In addition to trying to develop a consistent design system, this repo contains templates for data visualization in `ggplot` for `R` as this is my preferred method for making plots. The point of these defaults is to make producing consistent visualizations easier. After all, a design system is useless if it is not used.

## How-to:

I want my custom `ggplot` functions to be readily available to me. So, I have added some material to my `.Rprofile` file, that automatically loads in my custom functions etc. In particular, because my system uses user-download fonts see below I have added the following lines which ensure that these fonts are available on and R session starting up:

```{r}
## Make sure to change paths/names to your font file(s) as appropriate
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
```

Finally, I include some customized `ggplot` themes and function to my `.Rprofile`

```{r}
### loading personal theme for dataviz
source("/Users/joshuaylevy/Documents/Work/General/projectTemplatesSnips/theme_personal/r_materials/theme_personal.R")
```

You should make changes to your `.Rprofile` if you want to clone/use this repo (as a baseline) and have these customizations available to you _everywhere_ in your R environment. Otherwise, you could make these customizations on a project-by-project or even a script-by-script basis.

## Typefaces

### Inter

Inter is a font developed by Rasmus Andersson and widely distributed by Google Fonts. It is a sans serif font that does a lot of hte heavy lifting for this this visual identity guide. It can be downloaded can be downloaded [here](https://fonts.google.com/specimen/Inter). The `.otf` and `.ttf` might be useful to download to your machine.

**Use Cases**
I use Inter for things like titles, sub-titles, caption- and note text, etc.

### Intel One Mono

Intel One Mono was originally developed by Intel to help developers with impaired vision more easily work on their code. In addition to being a monospace font that spports many languages, Intel claims that it was developed to improve legibility and to improve reduce eye fatigue.

Intel One Mono is an open-source font and can be downloaded [here](https://github.com/intel/intel-one-mono). The `.otf` and `.ttf` might be useful to download to your machine.

**Use Cases**

## Colors

## Sizes

## Plot Types and Hierarchies of Information

## Resources and other materials

I became vaguely interested in (and then obsessed with) what makes for effective and aesthetically pleasing data visualization some time during my undergraduate studies. Since then, I have been collecting interesting resources, tips, and tricks for data visualization. Of the resources below, some I have used extensively, others less so. Have fun :)

### Full Style Guides

- [The Economist Visual Identity Guide](https://design-system.economist.com/documents/CHARTstyleguide_20170505.pdf) -- This is already a little bit out of date but very comprehensive. I basically started by ripping this off.
  - [The Economists' Branding Guides](https://design-system.economist.com/brand-and-marketing#style-guides) -- In my opinion, no other publication has done as good a job developing an immediately recognizable and distinctive visual identity. Other lessons to be learned here...
- [The Urban Institute Data Visualization Style Guide](https://urbaninstitute.github.io/graphics-styleguide/) -- What is says on the tin
- [The Financial Times Visual Vocabulary](https://github.com/Financial-Times/chart-doctor/tree/main/visual-vocabulary) -- Not quite a style guide but a useful resource for thinking about _how_ you want to visually present your data.
- [List of other style guides](https://blog.datawrapper.de/colors-for-data-vis-style-guides/#:~:text=as%20the%20result.-,Collection%20of%20data%20vis%20style%20guides,-For%20a%20list) -- Collated by Jon Schwabish, Amy Cesal, and Lisa Charlotte Muth. Lots of great stuff here to consider.

### Colors

- [Datawrapper - A detailed guide to colors in data viz style guides](https://blog.datawrapper.de/colors-for-data-vis-style-guides/) -- A (shallow) deep dive into color (theory) and you might think about developing a palette. A must read.
- [Coolors](https://coolors.co/) -- A useful palette generator if you are seeking some inspiration
- [Adobe Color](https://color.adobe.com/create/color-contrast-analyzer) - Testing for contrast and other accessibility considerations (the palette generator is only okay...)
- [Chroma.js Color Palette Helper](https://www.vis4.net/palettes/#/9|s|00429d,96ffea,ffffe0|ffffe0,ff005e,93003a|1|1) -- If you want to generate a Brewer-esque color palette with finer controls on interpolation methods.
  -- [Viz Palette](https://projects.susielu.com/viz-palette?colors=%5b%22#800000%22,%22#115e67%22,%22#4c8f98%22,%22#4d0000%22,%22#ba402c%22,%22#ea6a51%22,%22#ffa487%22,%22#7ec0ca%22,%22#baf5ff%22,%22#00323b%22]&backgroundColor=%22white%22&fontColor=%22black%22&mode=%22normal%22) -- A great tool for quickly testing a palette across multiple use cases (also lots of good tools for color-accessibility)

### Personalities...

... among many other cool people doing data viz online! :) (Link destinations vary)

- [Albert Rapp](https://twitter.com/rappa753?lang=en)
- [Cedric Scherer](https://www.cedricscherer.com/)
- [Jon Schwabish](https://twitter.com/jschwabish)

### ggplot Materials

- [https://ggplot2.tidyverse.org/index.html] -- More useful than you would imagine
- [June Choe's personal website](https://yjunechoe.github.io/blog.html#category:ggplot2) -- June really seems to understand what's going on. I'm just trying to make pretty graphs. His `ggtrace` package might be of interest if you really want to understand how `ggplot` works. [This](https://yjunechoe.github.io/posts/2021-06-24-setting-up-and-debugging-custom-fonts/#advanced-font-features) post was also quite helpful in understanding how `ggplot` handles fonts. I read this quite closely but ended up taking a different path.
- [Creating corporate color palettes for ggplot2](https://drsimonj.svbtle.com/creating-corporate-colour-palettes-for-ggplot2) -- A step-by-step guide to implementing custom color palettes as scales in `ggplot`

### Other stuff

- [An Economist's Guide to Data Visualization](https://www.aeaweb.org/articles?id=10.1257/jep.28.1.209) -- Schwabish (2014) _Journal of Economic Perspectives_
