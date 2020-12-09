library(geniusr)
library(dplyr)
library(tidytext)

hums <- c(
  'hm',
  'hmm',
  'hmmm',
  'hum',
  'mm',
  'mmm',
  'mmmm',
  'mmmmm',
  'mmmmmm',
  'mhmm',
  'mhmmm',
  'mhmmmm',
  'mmhm',
  'nah',
  'na',
  'oh',
  'ooh',
  'oooh',
  'ooooh',
  'oooooh',
  'ohh',
  'ohhh',
  'ohhhh',
  'ohhhhh',
  'ohhhhhh',
  'ohhhhhhh',
  'ah',
  'ahh',
  'ahhh',
  'ahhhh',
  'ahhhhh',
  'ahhhhhh',
  'ahhhhhhh',
  'ahhhhhhhh',
  'aa',
  'aaa',
  'ay',
  'ayy',
  'meh',
  'hey',
  'heh',
  'bmm',
  'woah',
  'wooah',
  'woooah',
  'woaah',
  'woaaah',
  'woaaaah',
  'woaaaaah',
  'woaaaaaah'
)

## Cudi artist IDs: search_artist('Kid Cudi') # 68

songs <-
  get_artist_songs_df(artist_id = 68)

final_hums_df <-
  data.frame(
    n_hums = integer(),
    n_regulars = integer(),
    song_name = character(),
    most_common_hum = character()
  )

for (row in 1:nrow(songs)) {
  ### Grab song names
  song_name <- songs[row, 'song_name']
  
  # Count frequency of hums
  lyrics <- tryCatch({get_lyrics_search(artist_name = "Kid Cudi",
                                 song_title = song_name)},
                     error = function(e) e)
  
  if (inherits(lyrics, "error") || is.na(lyrics$section_name) || nrow(lyrics) == 0) {
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
  
  if(identical(most_common_hum, character(0))) {
    most_common_hum = 'NONE'
  }
  # Pivot this df to a one-row format so that we can append it to our big dataset
  song_hum_stats <- song_hums %>%
    group_by(category) %>%
    tally() %>%
    tidyr::pivot_wider(names_from = 'category', values_from = 'n') %>%
    mutate(song_name,
           most_common_hum)
  
  if (!'n_hums' %in% colnames(song_hum_stats)) {
    song_hum_stats$n_hums = 0
  }
  
  final_hums_df <- rbind(song_hum_stats, final_hums_df)
  }
}

final_hums_df <- final_hums_df %>% 
  relocate(n_regulars, .after = 'n_hums') %>% 
  mutate(percent_hums = n_hums/(n_hums + n_regulars)) %>% 
  ### Exclude all remixes of original songs and miscellaneous other 'songs'
  filter(stringr::str_detect(song_name, '[Rr]emix|dub|TEDx Talk', negate = TRUE))

final_hums_df %>% arrange(desc(n_hums))

readr::write_csv(final_hums_df, here::here('data/hums.csv'))