# How Much Does Kid Cudi Hum?

### Need to have
* ~~Hums over time, by album etc.~~
* ~~Tokenized view of lyrics of a song, with all of the hums highlighted~~
    * ~~Spotify embed for each of the songs in this section~~
* ~~Somewhere (intro?), explanation of the definition of 'hums'~~
* ~~The intro prose should include some prototypical example of Cudi hums~~
    * ~~[Examples](https://www.youtube.com/watch?v=PZ_cpLwzBbw)~~
    * ~~Sad People, The Void... (the songs should have hums in the beginning so the listener gets an idea early)~~
* ~~A table for user exploration~~
    * ~~Example: table in https://pudding.cool/2018/08/wiki-death/~~
    * ~~Tech: https://vuetifyjs.com/en/components/data-tables/~~
* ~~Conclusion prose?~~
    * ~~This should summarize the top level stats (e.g. *actually answer the question*)~~
        * ~~Number of hums, total (including the breakdown of hmm, hum, ahhh, etc.)~~
        * ~~Proportion over his entire discography~~

### Nice to have
* ~~Where hums occur in a song (beginning, end, middle)~~
    * ~~Strip plot per song~~
    * ~~When does Cudi hum? Intro, bridge, chorus, outro~~
* Hums compared to critical reception (Pitchfork, Metacritic)
* Hums by popularity (`song_pageviews` in my data)
* Hums per song compared to average sentiment per song (no way there's any relationship here?)
* Barchart in the song explorer section for MOTM ranking

## Considerations
* [Mobile responsiveness](https://pudding.cool/process/responsive-scrollytelling/)
* [Techniques for Data Visualization on both Mobile & Desktop](https://www.visualcinnamon.com/2019/04/mobile-vs-desktop-dataviz)

## Things I ~~need to~~ couldn't fix
- [ ] The transition from stripplot to barchart doesn't render correctly on mobile

## Things I fixed
- [x] Bar chart transitions race (heh) on scroll
- [x] ~~Tooltip should follow mouse on mousemove? Or static positioning~~
- [x] ~~Add axis titles~~
- [x] ~~On mobile, the last step only lasts for a few pixels before losing `.active`~~
- [x] ~~Disable stripplot tooltip on mobile?~~
- [x] ~~On mobile, scrolling up causes URL bar to reappear and therefore triggers resize events...~~
    * ~~Do this https://stackoverflow.com/a/24212316/14518978~~
- [x] ~~Add tooltips to barchart and beeswarm~~
- [x] ~~? Handle resize better~~
    * ~~Resize currently breaks stripplot~~
- [x] ~~"Show Only Hums" should be a toggle, not a button... maybe?~~
    * ~~Usage of bulma switch extension was annoyingly hard~~
- [x] ~~Safari? Text shows up behind graphic~~
    * ~~This randomly went away?~~
- [x] ~~Make current notification for mobile and safari users fixed top 0~~
- [x] ~~Get rid of VW/VH (https://pudding.cool/process/responsive-scrollytelling/)~~
- [x] ~~Beautify charts a bit more~~
- [x] ~~Consider different background color?~~
- [x] ~~Ordering of sections in LyricExplorer should be same (toggled view currently reorders them)~~
