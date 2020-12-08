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
  'mhmm',
  'nah ',
  'na',
  'oh',
  'ooh',
  'ahh',
  'ah',
  'aa',
  'aaa',
  'ay',
  'ayy',
  'meh',
  'hey',
  'heh',
  'bmm'
)


## Cudi artist IDs: search_artist('Kid Cudi')

songs <-
  get_artist_songs_df(artist_id = 68)


for (song in songs$song_name) {
  # Count frequency of hums
  song_hums <- get_lyrics_search(artist_name = "Kid Cudi",
                                 song_title = song) %>% #song
    # get lyric bigrams
    unnest_tokens(bigram, line, token = "ngrams", n = 1) %>%
    # look for hums
    mutate(hum = ifelse(bigram %in% hums, TRUE, FALSE))
  
  song_name <- unique(song_hums$song_name)
  
  if (nrow(song_hums) <= 1) {
    print(paste0('Error in ', song_name))
  } else {
    table(song_hums$hum)
    print(paste0(
      'In ',
      song_name,
      ', ',
      scales::percent(nrow(song_hums %>% filter(hum == TRUE)) / nrow(song_hums)),
      ' of words are hums'
    ))
  }
}
