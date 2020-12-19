# How Much Does Kid Cudi Hum?

## Ideas 

#### Need to have:
* ~~Hums over time, by album etc.~~
* ~~Tokenized view of lyrics of a song, with all of the hums highlighted~~
    * Spotify embed for each of the songs in this section (done on the data processing side)
* Hums compared to critical reception (Pitchfork, Metacritic)
* Hums by popularity (`song_pageviews` in my data)
* YouTube link to the vid that has Cudi humming for 10 mins

### Nice to have:
* Hums per song compared to average sentiment per song (no way there's any relationship here?)
* ~~Where hums occur in a song (beginning, end, middle)~~
    * ~~Strip plot per song~~
    * ~~When does Cudi hum? Intro, bridge, chorus, outro ~~

## Considerations
* [Mobile responsiveness](https://pudding.cool/process/responsive-scrollytelling/)
* [Techniques for Data Visualization on both Mobile & Desktop](https://www.visualcinnamon.com/2019/04/mobile-vs-desktop-dataviz)
* A table might break up the story nicely and allow for user exploration
    * See table in https://pudding.cool/2018/08/wiki-death/
* [VH and VW on mobile](https://css-tricks.com/the-trick-to-viewport-units-on-mobile/)

## Things I need to fix:
- [ ] Finish stripplot grouping thing
- [ ] Handle resize better
    * Resize currently breaks stripplot
- [ ] "Show Only Hums" should be a toggle, not a button... maybe?
- [ ] Add axis titles
- [ ] Safari? Text shows up behind graphic
    * Current solution is notification/alert
- [ ] Make current notification for mobile and safari users fixed top 0
- [x] Get rid of VW/VH (https://pudding.cool/process/responsive-scrollytelling/)
- [x] Beautify charts a bit more
- [x] Consider different background color?
- [x] Ordering of sections in LyricExplorer should be same (toggled view currently reorders them)
