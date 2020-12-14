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
      mutate(normalized_position = row_number() / nrow(.))
  }
  
  motm_lyrics <- rbind(motm_lyrics, tokenized)
}

## Albums are sorts by percent hums already; pull that order and reorder motm 
song_order <- motm3 %>% arrange(desc(percent_hums)) %>% select(song_name) %>% mutate(song_rank = row_number())
final_motm <- motm_lyrics %>% left_join(., song_order)

final_motm <- final_motm[order(final_motm$song_rank, decreasing = T), ]

## This is what to recreate in D3
final_motm %>% ggplot(aes(x = normalized_position, y = song_name, color = category)) + geom_point()

readr::write_csv(final_motm, here::here('public/data/motm_tokenized.csv'))

