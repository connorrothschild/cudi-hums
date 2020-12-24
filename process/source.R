# for(file in list.files(here::here('process'))) {
#   source(paste0(here::here('process/', file)))
# }

# Because order matters:
source(here::here('process/hums_list.R'))
source(here::here('process/lyrics.R'))
source(here::here('process/albums.R'))
source(here::here('process/motm.R'))