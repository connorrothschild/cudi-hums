library(geniusr)
library(dplyr)
library(tidytext)
library(ggplot2)

source(here::here('process/hums_list.R'))
song_hums <- readr::read_csv(here::here('public/data/song_hums.csv'))
album_hums <- readr::read_csv(here::here('public/data/album_hums.csv'))

motm3 <- song_hums %>% filter(album_name == 'Man on the Moon III: The Chosen')

motm_lyrics <-
  data.frame(
    section_name = character(),
    section_artist = character(),
    song_name = character(),
    artist_name = character(),
    song_id = numeric(),
    bigram = character(),
    category = character(),
    normalized_position = numeric()
  )
for (row in 1:nrow(motm3)) {
  song_name <- motm3[row, 'song_name'] %>% pull()
  id <- motm3[row, 'song_id'] %>% pull()
  
  # Count frequency of hums
  lyrics <- tryCatch({
    get_lyrics_id(id)
  },
  error = function(e)
    e)
  
  if (inherits(lyrics, "error") ||
      is.na(lyrics$section_name) || nrow(lyrics) == 0) {
    print(paste('Error in', song_name))
  } else {
    tokenized <- lyrics %>%
      ### collapse = FALSE preserves row order
      unnest_tokens(bigram,
                    line,
                    token = "ngrams",
                    n = 1,
                    collapse = FALSE) %>%
      # look for hums
      mutate(category = ifelse(bigram %in% hums, 'Hum', 'Regular')) %>%
      mutate(position = row_number(),
             normalized_position = row_number() / nrow(.))
  }
  
  motm_lyrics <- rbind(motm_lyrics, tokenized)
}

## Albums are sorts by percent hums already; pull that order and reorder motm 
song_order <- motm3 %>% arrange(desc(percent_hums)) %>% select(song_name) %>% mutate(song_rank = row_number())
final_motm <- motm_lyrics %>% left_join(., song_order)

final_motm <- final_motm[order(final_motm$song_rank, decreasing = T), ]

## This is what to recreate in D3
final_motm %>% ggplot(aes(x = normalized_position, y = song_name, color = category)) + geom_point()
final_motm %>% group_by(section_name) %>% count(category)

final_motm <-
  final_motm %>% mutate(
    section_name = ifelse(
      section_name == 'Verse 1' |
      section_name == 'Verse 2',
      'Verse',
      section_name
    )
  ) %>%
  left_join(song_hums)

### ADD SPOTIFY EMBED URLS

# Used to add the embed code before each song uri, and remove spotify:track: from the URIs (copied from Spotify)
add_embed_pre <- function(str) {
  str <- stringr::str_replace(str, 'spotify:track:', '')
  paste0('https://open.spotify.com/embed/track/', str)
}

# unique(final_motm$song_name)

# Get song URI and use the above function to make into embed code
final_motm <- final_motm %>% 
  mutate(embed_url = 
           case_when(
             song_name == "Elsie’s Baby Boy (flashback)" ~ "spotify:track:6jiwr6xTHqjdun5d3cEwXV",
             song_name == "Another Day" ~ "spotify:track:6myUpr3GDR80Dg3zqNTmmG",
             song_name == "The Void" ~ "spotify:track:2yg7MXp8nSPaf61HVkhEr3",
             song_name == "Dive" ~ "spotify:track:7Hc3YL8oDiAzbiAW32KXrw",
             song_name == "Heaven on Earth" ~ "spotify:track:2koUj1Fn5TKFEkChSmBPIb",
             song_name == "Sad People" ~ "spotify:track:4nuAslShoN77tq12fzwjUq",
             song_name == "Tequila Shots" ~ "spotify:track:30KctD1WsHKTIYczXjip5a",
             song_name == "She Knows This" ~ "spotify:track:1xzUQMiCoY5pdego0pHMeV",
             song_name == "Lord I Know" ~ "spotify:track:7f2voPcnDEAzX4yB8SLnU2",
             song_name == "Lovin’ Me" ~ "spotify:track:3JdwGk8j7lHN5qdzJZklam",
             song_name == "Sept. 16" ~ "spotify:track:3Uw2se3aQU1UFrpRBvBnB4",
             song_name == "Damaged" ~ "spotify:track:2n7Ao4nyESBa5ti8gcAbBt",
             song_name == "The Pale Moonlight" ~ "spotify:track:4EjbAh7YHU3VARkfkamZ8R",
             song_name == "Mr. Solo Dolo III" ~ "spotify:track:27oVCAziETRbNuo5A8LNpg",
             song_name == "4 da Kidz" ~ "spotify:track:2ZDRkJrKbceJRgLKkuex14",
             song_name == "Beautiful Trip" ~ "spotify:track:4IIuCotvqijraSdnVLaFnM"),
         embed_url = add_embed_pre(embed_url))


readr::write_csv(final_motm, here::here('public/data/motm_tokenized.csv'))
# motm <- readr::read_csv(here::here('public/data/motm_tokenized.csv'))
