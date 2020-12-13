# How Much Does Kid Cudi Hum?

## Ideas 

#### Need to have:
* ~~Hums over time, by album etc.~~
* Tokenized view of lyrics of a song, with all of the hums highlighted
* Hums compared to critical reception (Pitchfork, Metacritic)
* Hums by popularity (`song_pageviews` in my data)

### Nice to have:
* Hums per song compared to average sentiment per song (no way there's any relationship here?)
* Where hums occur in a song (beginning, end, middle)
    * Song on Y axis, one line for each term (all low opacity, thin), and hums are pink lines

## Considerations
* [Mobile responsiveness](https://pudding.cool/process/responsive-scrollytelling/)
    * How does the app handle resize? (current method doesn't work)
* A table might break up the story nicely and allow for user exploration
    * See table in https://pudding.cool/2018/08/wiki-death/

## Things I need to fix:
* Get rid of VW/VH (https://pudding.cool/process/responsive-scrollytelling/)
* Handle resize better
* Get rid of scatterplot
* Beautify charts a bit more
* Consider different background color?