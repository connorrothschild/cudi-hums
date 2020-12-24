# How Much Does Kid Cudi Hum?

## Ideas 

#### Need to have
* ~~Hums over time, by album etc.~~
* ~~Tokenized view of lyrics of a song, with all of the hums highlighted~~
    * ~~Spotify embed for each of the songs in this section~~
* The intro prose should include some prototypical example of Cudi hums
    * [Examples](https://www.youtube.com/watch?v=PZ_cpLwzBbw)
    * Sad People, The Void... (the songs should have hums in the beginning so the listener gets an idea early)
* Somewhere (intro?), explanation of the definition of 'hums'
* Conclusion prose? 
    * Before or after song/lyric exploration?
* Some obvious separation (like a horizontal rule, but better) between intro prose and chart content

### Nice to have
* ~~Where hums occur in a song (beginning, end, middle)~~
    * ~~Strip plot per song~~
    * ~~When does Cudi hum? Intro, bridge, chorus, outro ~~
* Hums compared to critical reception (Pitchfork, Metacritic)
* Hums by popularity (`song_pageviews` in my data)
* Hums per song compared to average sentiment per song (no way there's any relationship here?)
* Barchart in the song explorer section for MOTM ranking

## Considerations
* [Mobile responsiveness](https://pudding.cool/process/responsive-scrollytelling/)
* [Techniques for Data Visualization on both Mobile & Desktop](https://www.visualcinnamon.com/2019/04/mobile-vs-desktop-dataviz)
* A table might break up the story nicely and allow for user exploration
    * See table in https://pudding.cool/2018/08/wiki-death/
* [VH and VW on mobile](https://css-tricks.com/the-trick-to-viewport-units-on-mobile/)

## Things I need to fix
- [ ] Finish stripplot grouping thing
- [ ] Add axis titles
- [ ] Disable stripplot tooltip on mobile?
- [ ] A lil explainer like 'Know literally nothing about Kid Cudi? Click here! With modal popup or smth

## Things I fixed
- [ ] **BIG: On mobile, scrolling up causes URL bar to reappear and therefore triggers resize events...
    * Do this https://stackoverflow.com/a/24212316/14518978
- [x] Add tooltips to barchart and beeswarm
- [x] ? Handle resize better
    * Resize currently breaks stripplot
- [x] ~~"Show Only Hums" should be a toggle, not a button... maybe?~~
    * Usage of bulma switch extension was annoyingly hard
- [x] Safari? Text shows up behind graphic
    * Current solution is notification/alert
- [x] Make current notification for mobile and safari users fixed top 0
- [x] Get rid of VW/VH (https://pudding.cool/process/responsive-scrollytelling/)
- [x] Beautify charts a bit more
- [x] Consider different background color?
- [x] Ordering of sections in LyricExplorer should be same (toggled view currently reorders them)
