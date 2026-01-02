require(showtext)
require(ggpubr)
require(ggtext)
require(ggprism)

### THEME OBJECTS

theme_personal <- function() {
    sysfonts::font_add(
        family = "Intel One",
        regular = "intelone-mono-font-family-regular.ttf",
        bold = "intelone-mono-font-family-bold.ttf",
        italic = "intelone-mono-font-family-italic.ttf",
        bolditalic = "intelone-mono-font-family-bolditalic.ttf"
    )
    sysfonts::font_add(
        family = "Inter",
        regular = "Inter-Regular.ttf",
        bold = "Inter-Bold.ttf",
        italic = "Inter-Light.ttf"
    )
    showtext::showtext_auto()
    showtext::showtext_opts(dpi = 300)
    font <- "Inter"
    alt_font <- "Intel One"


    theme_minimal() %+replace%
        theme(
            ### DEBUGGING
            # plot.background = element_rect(
            #     color = "palevioletred1",
            #     linewidth = 3
            # ),

            ### Setup
            plot.margin = margin(t = 20, r = 25, b = 20, l = 25),
            line = element_line(
                color = "#676E73"
            ),
            text = element_text(family = "Inter"),

            ### Labelling
            plot.title = element_markdown(
                # face = "bold", # Typeface style
                size = 18, # Size (pt)
                hjust = 0, # hjust = 0 "left-aligned"
                vjust = 0, # vjust = 0 "top-aligned"
                margin = margin(t = 10, r = 0, b = 0, l = 0, unit = "pt"),
                debug = FALSE
            ),
            plot.subtitle = element_markdown(
                size = 16, # Size (pt)
                hjust = 0, # hjust = 0 "left-aligned"
                vjust = 0, # vjust = 0 "top-aligned"
                margin = margin(t = 5, r = 0, b = 0, l = 0, unit = "pt"),
                debug = FALSE
            ),
            plot.caption.position = "panel",
            plot.caption = element_markdown(
                size = 12,
                hjust = 0,
                vjust = 0,
                margin = margin(t = 5, r = 0, b = 0, l = 0, unit = "pt"),
                debug = FALSE
            ),
            plot.tag.position = c(0, 1),
            plot.tag = element_text(
                family = alt_font,
                face = "bold",
                size = 14,
                color = "#3482F6",
                hjust = 0,
                vjust = 0,
                margin = margin(t = 5, r = 0, b = 0, l = 0, unit = "pt"),
                debug = FALSE
            ),

            ### Axes
            axis.title.x = element_text(
                family = font,
                face = "italic",
                size = 12,
                hjust = 0.5,
                vjust = 1,
                margin = margin(t = 5, r = 0, b = 0, l = 0, unit = "pt"),
                debug = FALSE
            ),
            axis.title.y = element_blank(),
            axis.text = element_text(
                family = font
            ),
            axis.text.y.right = element_text(
                size = 11,
                hjust = 1,
                vjust = -0.5,
                margin = margin(t = 0, r = 0, b = 0, l = -20, unit = "pt"),
                debug = FALSE
            ),
            axis.line.x = element_line(
                color = "black",
                linewidth = 0.75
            ),
            axis.ticks.x = element_line(
                color = "black",
            ),
            axis.ticks.length.x = unit(5, unit = "pt"),

            ### Panel features
            panel.grid.minor.x = element_blank(),
            panel.grid.minor.y = element_blank(),

            ### Legend features
            legend.position = "top",
            legend.justification = "left",
            legend.box.margin = margin(t = 5, r = 5, b = 5, l = 0, unit = "pt"),
            legend.margin = margin(t = 5, r = 5, b = 5, l = 0, unit = "pt"),
            # legend.title.align = 0,
            # legend.key.size = unit(20, unit = "pt"),
            legend.title = element_text(
                family = font,
                size = 14,
                hjust = -1,
                vjust = 0.5,
                debug = FALSE
            ),
            legend.text = element_text(
                family = font,
                size = 12,
                hjust = 0,
                vjust = 0.5,
                debug = FALSE
            ),
        )
}


ggsave_personal <- function(
  plot = NULL,
  filename = NULL,
  size = NULL,
  height = NULL,
  width = NULL,
  units = "in",
  dpi = 300,
  bg = "white",
  ...
) {
    # Size preset lookup
    # Dimensions optimized for LaTeX integration with 1" margins
    # Standard letter paper (8.5" x 11") with 1" margins = 6.5" text width
    size_presets <- list(
        # Full-width figure for LaTeX documents
        # Width: 6.5" matches \textwidth in standard article class with 1" margins
        # LaTeX usage: \includegraphics[width=\textwidth]{figure.png} - no scaling needed
        "full" = list(width = 6.5, height = 9.0),

        # Half-width for two panels side-by-side
        # Width: 3.2" allows spacing between panels (slightly less than half)
        # LaTeX usage: \includegraphics[width=0.48\textwidth]{figure.png} or \includegraphics[width=3.2in]{figure.png}
        "half" = list(width = 3.2, height = 9.0),

        # Full-width Beamer presentation slide (16:9 aspect ratio)
        # Standard Beamer slide dimensions optimized for font sizes: 18pt title, 16pt subtitle, 12pt body
        "full_presentation" = list(width = 10.0, height = 5.625),

        # Half-width presentation slide (maintains 16:9 aspect ratio)
        "half_presentation" = list(width = 5.0, height = 2.8125)
    )

    # Apply size preset if specified (overrides custom height/width)
    if (!is.null(size)) {
        if (size %in% names(size_presets)) {
            preset <- size_presets[[size]]
            width <- preset$width
            height <- preset$height
        } else {
            warning(paste0(
                "Unknown size preset '", size, "'. Available presets: ",
                paste(names(size_presets), collapse = ", ")
            ))
        }
    }

    # DPI and pixel count reference:
    # - 300 DPI: standard print quality (1" = 300px) - recommended for publications
    # - 150 DPI: web quality (1" = 150px) - suitable for online viewing
    # - 72 DPI: screen resolution (1" = 72px) - basic screen display
    # When using custom dimensions, calculate pixels: width_inches * dpi = width_pixels
    # Example: 6.5" width at 300 DPI = 1950px

    # Prepare arguments for ggsave
    # Note: plot can be NULL (ggsave will use last_plot() in that case)
    # Piping support: my_plot %>% ggsave_personal(...) works because %>% passes as first positional argument
    ggsave_args <- list(
        plot = plot,
        filename = filename,
        units = units,
        dpi = dpi,
        bg = bg
    )

    # Only add height/width if they are set (either via size preset or custom values)
    if (!is.null(height)) {
        ggsave_args$height <- height
    }
    if (!is.null(width)) {
        ggsave_args$width <- width
    }

    # Add any additional arguments passed via ...
    dots <- list(...)
    if (length(dots) > 0) {
        ggsave_args <- c(ggsave_args, dots)
    }

    # Call ggplot2::ggsave
    do.call(ggplot2::ggsave, ggsave_args)
}


### PERSONAL COLORS AND SCALES
personal_colors <- c(
    # personal_dark_blue = "#020E37",
    personal_dark_blue = "#000633",
    personal_medium_blue = "#005780",
    personal_bright_blue = "#00CBFF",
    personal_fuscia = "#FF1155",
    personal_green = "#00FFA2",
    personal_purple = "#9E00FF",
    personal_tan = "#BDB8AC",
    personal_red = "#EE2700",
    personal_yellow = "#FFDB2A",
    personal_democratic_blue = "#0066CC",
    personal_republican_red = "#CC0000"
)

personal_cols <- function(...) {
    cols <- c(...)
    if (is.null(cols)) {
        return(personal_colors)
    }
    personal_colors[cols]
}

personal_palettes <- list(
    `main` = personal_cols(
        "personal_bright_blue",
        "personal_fuscia",
        "personal_purple",
        "personal_green",
        "personal_yellow",
        "personal_dark_blue"
    ),
    `blues` = personal_cols(
        "personal_bright_blue",
        "personal_dark_blue"
    ),
    `reds` = personal_cols(
        "personal_fuscia",
        # "personal_red"
        "personal_dark_blue"
    ),
    `blue_red` = personal_cols(
        "personal_dark_blue",
        "personal_bright_blue",
        "personal_purple",
        "personal_fuscia",
        "personal_red"
    ),
    `us_partisan` = personal_cols(
        "personal_democratic_blue",
        "personal_republican_red"
    )
)

personal_pal <- function(palette = "main", reverse = FALSE, n = NULL, ...) {
    if (!is.null(n)) {
        pal <- personal_palettes[[palette]][1:n]
    } else {
        pal <- personal_palettes[[palette]]
    }

    if (reverse) pal <- rev(pal)

    colorRampPalette(pal)
}

scale_color_personal <- function(
  palette = "main",
  discrete = TRUE,
  reverse = FALSE,
  n_colors = NULL,
  ...
) {
    pal <- personal_pal(
        palette = palette,
        reverse = reverse,
        n = n_colors,
        ...
    )
    if (discrete) {
        discrete_scale("color", paste0("personal_", palette), palette = pal, ...)
    } else {
        scale_color_gradientn(colors = pal(256), ...)
    }
}

scale_fill_personal <- function(
  palette = "main",
  discrete = TRUE,
  reverse = FALSE,
  n_colors = NULL,
  ...
) {
    pal <- personal_pal(
        palette = palette,
        reverse = reverse,
        n = n_colors,
        ...
    )
    if (discrete) {
        discrete_scale("fill", paste0("personal_", palette), palette = pal, ...)
    } else {
        scale_fill_gradientn(colors = pal(256), ...)
    }
}

### HIGHLIGHT SCALE FUNCTIONS
scale_color_highlight <- function(
  grey = "#CCCCCC",
  highlight_colors = NULL,
  n_colors = NULL,
  palette = "main",
  reverse = FALSE,
  ...
) {
    # If colors not provided, use main personal palette
    if (is.null(highlight_colors)) {
        if (is.null(n_colors)) {
            # Default to 6 colors from main palette (can handle up to 6 non-zero categories)
            n_colors <- 6
        }
        pal <- personal_pal(
            palette = palette,
            reverse = reverse,
            n = n_colors
        )
        highlight_colors <- pal(n_colors)
    }

    # Create values mapping: 0 -> grey, 1+ -> colors
    # Use scale_color_manual with a named vector mapping values to colors
    # Values are converted to character strings for matching
    # Note: scale_color_manual works with both numeric and factor values
    values_map <- c("0" = grey)
    if (length(highlight_colors) > 0) {
        values_map <- c(values_map, setNames(highlight_colors, as.character(seq_along(highlight_colors))))
    }

    # Direct call - scale_color_manual is always discrete, so no need for argument filtering
    scale_color_manual(
        values = values_map,
        na.value = grey,
        ...
    )
}

scale_fill_highlight <- function(
  grey = "#CCCCCC",
  colors = NULL,
  n_colors = NULL,
  palette = "main",
  reverse = FALSE,
  ...
) {
    # If colors not provided, use main personal palette
    if (is.null(colors)) {
        if (is.null(n_colors)) {
            # Default to 6 colors from main palette (can handle up to 6 non-zero categories)
            n_colors <- 6
        }
        pal <- personal_pal(
            palette = palette,
            reverse = reverse,
            n = n_colors
        )
        colors <- pal(n_colors)
    }

    # Create values mapping: 0 -> grey, 1+ -> colors
    # Use scale_fill_manual with a named vector mapping values to colors
    # Values are converted to character strings for matching
    # Note: scale_fill_manual works with both numeric and factor values
    values_map <- c("0" = grey)
    if (length(colors) > 0) {
        values_map <- c(values_map, setNames(colors, as.character(seq_along(colors))))
    }

    # Direct call - scale_fill_manual is always discrete, so no need for argument filtering
    scale_fill_manual(
        values = values_map,
        na.value = grey,
        ...
    )
}

### STIGLER FUNCTIONS
stigler_colors <- c(
    booth_maroon = "#800000",
    booth_teal = "#115E67",
    black_bean = "#4D0000",
    persian_red = "#BA402C",
    burnt_sienna = "#EA6A51",
    pale_tangerine = "#FFA487",
    midnight_green = "#00323B",
    munsell_blue = "#4C8F98",
    sky_blue = "#7EC0CA",
    celeste = "#BAF5FF"
)

stigler_cols <- function(...) {
    cols <- c(...)
    if (is.null(cols)) {
        return(stigler_colors)
    }
    stigler_colors[cols]
}


stigler_palettes <- list(
    `main` = stigler_cols(
        "booth_maroon",
        "booth_teal",
        "persian_red",
        "munsell_blue",
        "burnt_sienna",
        "sky_blue",
        "pale_tangerine",
        "celeste",
        "black_bean",
        "midnight_green"
    ),
    `reds` = stigler_cols(
        "booth_maroon",
        "persian_red",
        "burnt_sienna",
        "pale_tangerine",
        "black_bean"
    ),
    `blues` = stigler_cols(
        "booth_teal",
        "munsell_blue",
        "sky_blue",
        "celeste",
        "midnight_green"
    ),
    `red_to_blue` = stigler_cols(
        "booth_maroon",
        "booth_teal"
    ),
    `reds_2` = stigler_cols(
        "black_bean",
        "pale_tangerine"
    ),
    `blues_2` = stigler_cols(
        "midnight_green",
        "celeste"
    )
)

stigler_pal <- function(palette = "main", reverse = FALSE, ...) {
    pal <- stigler_palettes[[palette]]

    if (reverse) pal <- rev(pal)

    colorRampPalette(pal)
}


scale_color_stigler <- function(
  palette = "main",
  reverse = FALSE,
  discrete = TRUE,
  ...
) {
    pal <- stigler_pal(palette = palette, reverse = reverse, ...)
    if (discrete) {
        discrete_scale("color", paste0("stigler_", palette), palette = pal, ...)
    } else {
        scale_color_gradientn(colors = pal(256), ...)
    }
}

scale_fill_stigler <- function(
  palette = "main",
  reverse = FALSE,
  discrete = TRUE,
  ...
) {
    pal <- stigler_pal(palette = palette, reverse = reverse, ...)
    if (discrete) {
        discrete_scale("fill", paste0("stigler_", palette), palette = pal, ...)
    } else {
        scale_fill_gradientn(colors = pal(256), ...)
    }
}

###
