library(geniusr)
library(dplyr)
library(tidytext)

source(here::here('process/hums_list.R'))

## Cudi artist IDs: search_artist('Kid Cudi') # 68

songs <-
  get_artist_songs_df(artist_id = 68)

final_hums_df <-
  data.frame(
    song_name = character(),
    song_id = integer(),
    most_common_hum = character(),
    n_hums = integer(),
    n_regulars = integer()
  )

for (row in 1:nrow(songs)) {
  ### Grab song names and IDs
  song_id <- songs[row, 'song_id']
  song_name <- songs[row, 'song_name']
  
  # Count frequency of hums
  lyrics <- tryCatch({
    get_lyrics_search(artist_name = "Kid Cudi",
                      song_title = song_name)
  },
  error = function(e)
    e)
  
  if (inherits(lyrics, "error") ||
      is.na(lyrics$section_name) || nrow(lyrics) == 0) {
    print(paste('Error in', song_name))
  } else {
    song_hums <- lyrics %>%
      # get lyric bigrams
      unnest_tokens(bigram, line, token = "ngrams", n = 1) %>%
      # look for hums
      mutate(category = ifelse(bigram %in% hums, 'n_hums', 'n_regulars'))
    
    # Get the most common 'hum term' from that song
    most_common_hum <-
      song_hums %>% filter(category == 'n_hums') %>% count(bigram, sort = T) %>% slice(1) %>% pull(bigram)
    
    if (identical(most_common_hum, character(0))) {
      most_common_hum = 'NONE'
    }
    # Pivot this df to a one-row format so that we can append it to our big dataset
    song_hum_stats <- song_hums %>%
      group_by(category) %>%
      tally() %>%
      tidyr::pivot_wider(names_from = 'category', values_from = 'n') %>%
      mutate(song_name,
             song_id,
             most_common_hum)
    
    if (!'n_hums' %in% colnames(song_hum_stats)) {
      song_hum_stats$n_hums = 0
    }
    
    final_hums_df <- rbind(song_hum_stats, final_hums_df)
  }
}

final_hums_df <- final_hums_df %>%
  mutate(percent_hums = n_hums / (n_hums + n_regulars)) %>%
  ### Exclude all remixes of original songs and miscellaneous other 'songs'
  filter(stringr::str_detect(song_name, '[Rr]emix|dub|TEDx Talk', negate = TRUE))

# final_hums_df %>% arrange(desc(n_hums))

### Bring in song_art_image, song_release_data, song_pageviews, and album_name
for (row in 1:nrow(songs)) {
  # Grab song id
  song_id <- songs[row, 'song_id']
  # Lookup
  song_meta <- get_song_df(song_id)
  
  ## On the first iteration, create a DF called all_song_meta
  if (row == 1) {
    all_song_meta <- song_meta
  } else {
    # Every other time, append via rbind
    all_song_meta <- rbind(song_meta, all_song_meta)
  }
}

final_songs <-
  left_join(final_hums_df, all_song_meta, by = c('song_id', 'song_name')) %>%
  ### Reorder
  select(
    song_name,
    n_hums,
    n_regulars,
    most_common_hum,
    song_release_date,
    album_name,
    song_art_image_url,
    song_pageviews,
    everything()
  ) %>% 
  # Replace problematic
  mutate(song_name = ifelse(song_id == 6250779, "Lovin’ Me", song_name))

readr::write_csv(final_songs, here::here('public/data/song_hums.csv'))
