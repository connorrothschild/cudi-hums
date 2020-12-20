library(geniusr)
library(dplyr)
library(tidytext)

source(here::here('process/hums_list.R'))
song_hums <- readr::read_csv(here::here('public/data/song_hums.csv'))

#### AGGREGATE BY ALBUM
album_hums <- song_hums %>%
  group_by(album_name) %>%
  summarise(sum_hums = sum(n_hums),
            sum_regulars = sum(n_regulars)) %>%
  ungroup %>%
  mutate(percent_hums = sum_hums / (sum_regulars + sum_hums)) %>%
  arrange(desc(percent_hums))

major_albums <-
  c(
    "Passion, Pain & Demon Slayin’",
    "Man on the Moon II: The Legend of Mr. Rager",
    "Speedin’ Bullet 2 Heaven",
    "Indicud",
    "Man on the Moon: The End of Day",
    "A Kid Named Cudi",
    "KiD CuDi presents SATELLITE FLIGHT: The journey to Mother Moon",
    "Man on the Moon III: The Chosen"
  )

album_id_lookup <- song_hums %>% distinct(album_name, album_id)

albums <- album_hums %>%
  filter(album_name %in% major_albums) %>%
  left_join(., album_id_lookup, by = 'album_name')

for (row in 1:nrow(albums)) {
  # Grab album id
  album_id <- albums[row, 'album_id']
  # Lookup
  album_meta <- get_album_df(album_id)
  
  ## On the first iteration, create a DF called all_album_meta
  if (row == 1) {
    all_album_meta <- album_meta
  } else {
    # Every other time, append via rbind
    all_album_meta <- rbind(album_meta, all_album_meta)
  }
}

final_albums <- left_join(albums, all_album_meta) %>% 
  mutate(year = lubridate::year(album_release_date))

readr::write_csv(final_albums, here::here('public/data/album_hums.csv'))
# albums <- readr::read_csv(here::here('public/data/album_hums.csv'))
