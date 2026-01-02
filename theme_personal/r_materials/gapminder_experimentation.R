library(tidyverse)
library(gapminder)
library(scales)
library(ggdist)
library(zoo)
library(RDHonest)


df <- gapminder

ggplot(df %>% filter(year == 2007)) +
    geom_point(
        aes(
            x = gdpPercap, y = lifeExp,
            size = pop, color = continent
        ),
        alpha = 0.8
    ) +
    scale_x_continuous(
        name = "GDP per capita",
        labels = scales::dollar,
        limits = c(0, 50000),
        expand = expansion(
            mult = c(0.0, 0)
        )
    ) +
    scale_y_continuous(
        position = "right",
        name = "this is a test y-axis title",
        limits = c(40, 85),
        expand = expansion(
            mult = c(0, 0)
        ),
    ) +
    scale_color_personal(
        palette = "main", discrete = TRUE,
        n_colors = 5,
        name = "Continent"
    ) +
    scale_size_binned(
        guide = "none"
    ) +
    guides(
        color = guide_legend(
            override.aes = list(size = 4)
        ),
    ) +
    labs(
        title = "**Life expectancy vs GDP per Capita**",
        subtitle = "Years",
        caption = "Caption text goes here:",
        tag = "1|"
    ) +
    theme_personal()

ggplot(
    mtcars
) +
    geom_point(
        aes(
            x = mpg,
            y = disp,
            color = hp
        ),
        size = 3
    ) +
    scale_color_personal(
        palette = "blues",
        discrete = FALSE,
        reverse = TRUE,
        name = "Horsepower"
    ) +
    scale_x_continuous(
        limits = c(10, 35),
        expand = expansion(mult = 0),
        name = "Miles per gallon (mpg)"
    ) +
    scale_y_continuous(
        position = "right",
        name = "Engine displacement (cc)"
    ) +
    guides(
        color = guide_colorbar(
            title.position = "top",
            direction = "horizontal",
            label.position = "bottom",
            ticks = TRUE,
            barwidth = 20,
            barheight = 0.7
        )
    ) +
    labs(
        title = "**Vehicle fuel efficiency and engine displacement**",
        subtitle = "Engine displacement (cc)",
        tag = "2|"
    ) +
    theme_personal() +
    theme(
        axis.text.y.right = element_text(
            margin = margin(t = 0, r = 0, b = 0, l = -27, unit = "pt")
        )
    )

ggplot(
    economics_long %>%
        filter(variable %in% c("uempmed", "unemploy")) %>%
        group_by(variable) %>%
        mutate(
            base = ifelse(
                date == ymd("1967-07-01"),
                value,
                999
            ),
            base = ifelse(
                base == 999,
                min(base),
                base
            ),
            normed = value / base
        )
) +
    geom_line(
        aes(
            x = date,
            y = normed,
            group = variable,
            color = variable
        ),
        linewidth = 1.3
    ) +
    scale_x_date(
        limits = c(ymd("1965-01-01"), ymd("2015-04-01")),
        date_breaks = "5 years",
        date_labels = "%Y",
        expand = expansion(add = c(0, 700)),
        name = NULL,
    ) +
    scale_y_continuous(
        position = "right",
        # limits = c(0, 1),
        expand = expansion(mult = c(0, 0.05))
    ) +
    scale_color_personal(
        discrete = TRUE,
        n_colors = 2,
        label = c("Median enmployment duration (weeks)", "Unemployment rate (%)"),
        name = "Indicator"
    ) +
    labs(
        title = "**Unemployment in the United States since 1967**",
        subtitle = "Indexed values, July 1967 = 1",
        tag = "3|"
    ) +
    theme_personal()



eusm_df <- EuStockMarkets %>%
    as.data.frame() %>%
    mutate(
        day = row_number()
    ) %>%
    pivot_longer(
        cols = c("DAX", "SMI", "CAC", "FTSE"),
        names_to = "market",
        values_to = "index"
    ) %>%
    group_by(market) %>%
    mutate(
        smooth_5 = rollmean(index, 5, align = "left", na.pad = TRUE),
        smooth_15 = rollmean(index, 15, align = "left", na.pad = TRUE),
        smooth_30 = rollmean(index, 30, align = "left", na.pad = TRUE),
        smooth_90 = rollmean(index, 90, align = "left", na.pad = TRUE),
    ) %>%
    ungroup() %>%
    pivot_longer(
        cols = c("smooth_5", "smooth_15", "smooth_30", "smooth_90"),
        names_to = "roll_avg_window",
        values_to = "roll_avg",
    ) %>%
    mutate(
        market_smooth_code = paste(roll_avg_window, market, sep = "_")
    )

ggplot(eusm_df) +
    geom_line(
        aes(
            x = day, y = roll_avg,
            color = market, alpha = roll_avg_window,
            group = market_smooth_code
        ),
        linewidth = 1.3
    ) +
    scale_color_personal(
        palette = "blues",
    ) +
    scale_y_continuous(
        position = "right"
    ) +
    labs(
        title = "TEST",
        tag = "4A|"
    ) +
    theme_personal()



ggplot(eusm_df) +
    geom_line(
        aes(
            x = day,
            y = roll_avg,
            color = market,
            alpha = roll_avg_window,
            group = market_smooth_code
        ),
        linewidth = 1.3
    ) +
    scale_color_personal(
        palette = "reds",
    ) +
    scale_y_continuous(
        position = "right"
    ) +
    labs(
        title = "TEST",
        tag = "4B|"
    ) +
    theme_personal()


ggplot(eusm_df %>% filter(market == "FTSE")) +
    geom_line(
        aes(
            x = day, y = roll_avg,
            alpha = roll_avg_window,
            group = market_smooth_code
        ),
        color = personal_cols("personal_medium_blue"),
        linewidth = 1.3
    ) +
    scale_y_continuous(
        position = "right"
    ) +
    labs(
        title = "TEST",
        tag = "4C|"
    ) +
    theme_personal()


partisan_df <- lee08 %>%
    mutate(dem_incumbent = factor(ifelse(margin > 0, 1, 0)))

ggplot(partisan_df) +
    geom_point(
        aes(x = margin, y = voteshare, color = dem_incumbent),
        shape = 1, alpha = 0.8
    ) +
    scale_color_personal(
        palette = "us_partisan",
        discrete = TRUE,
        name = "Democratic Incumbent"
    ) +
    theme_personal()

ggplot(partisan_df) +
    geom_point(
        aes(x = margin, y = voteshare, color = voteshare),
        shape = 1
    ) +
    scale_color_personal(
        palette = "us_partisan",
        discrete = FALSE,
        name = "Democratic Incumbent"
    ) +
    theme_personal()


# Example using scale_fill_highlight with gapminder data
highlight_df <- df %>%
    filter(year == 2007) %>%
    arrange(desc(gdpPercap)) %>%
    mutate(
        # Create highlight categories: 0 for low GDP, 1-3 for high GDP quartiles
        gdp_category = case_when(
            gdpPercap >= quantile(gdpPercap, 0.75) ~ 3,
            gdpPercap >= quantile(gdpPercap, 0.50) ~ 2,
            gdpPercap >= quantile(gdpPercap, 0.25) ~ 1,
            TRUE ~ 0
        ),
        gdp_category = factor(gdp_category)
    )


ggplot(highlight_df) +
    geom_point(
        aes(x = gdpPercap, y = lifeExp, color = gdp_category),
        size = 3
    ) +
    scale_color_highlight(
        guide = "legend",
        name = "GDP Category"
    ) +
    theme_personal()

ggplot(highlight_df) +
    geom_point(
        aes(x = gdpPercap, y = lifeExp, color = gdp_category),
        size = 3
    ) +
    scale_color_highlight(
        highlight_colors = c("#A2C3E5", "#357ABD", "#183D57"),
        n_colors = 3,
        guide = "legend",
        name = "GDP Category"
    ) +
    theme_personal()

### To-Dos
# - Start splitting out functions and themes into separate files.
# - Identify greys
# - Construct special partisan palettes
# - Construct two-way gradient palettes
# - Decide whether y-axis titles live at the top of the figure or along the axis
# - Get positioning of the y-axis tick text right
# - Generate color scales functions
# - Think about x- and y-axis scale functions
