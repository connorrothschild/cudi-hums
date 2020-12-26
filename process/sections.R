library(dplyr)
library(tidyverse)

motm <-
  readr::read_csv(here::here('public/data/motm_tokenized.csv'))

sections_grouped <- motm %>%
  group_by(section_name, category) %>%
  tally() %>%
  ungroup %>%
  pivot_wider(names_from = category, values_from = n)

sections_grouped <-
  sections_grouped[order(factor(sections_grouped$section_name, levels = c(
    c(
      "Intro",
      "Verse",
      "Pre-Chorus",
      "Chorus",
      "Post-Chorus",
      "Bridge",
      "Interlude",
      "Outro"
    )
  ))), ]

readr::write_csv(sections_grouped,
                 here::here('public/data/sections_grouped.csv'))
