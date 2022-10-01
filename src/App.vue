<template>
  <div id="app">
    <!-- LOADING SCREEN UNTIL ALL DATASETS ARE LOADED -->
    <LoadingScreen
      v-if="
        (song_hums.length == 0) |
          (major_albums.length == 0) |
          (album_hums.length == 0) |
          (sections_grouped.length == 0)
      "
    />
    <div
      v-if="
        (song_hums.length > 0) &
        (major_albums.length > 0) &
        (album_hums.length > 0) &
        (sections_grouped.length > 0)
      "
    >
      <!-- If on Safari, nudge to another browser -->
      <!-- <div class="notification is-fixed is-danger mb-0" v-if="showSafariWarning">
			<button class="delete" @click="showSafariWarning = false"></button>
			Thanks for visiting!
			<span class="has-text-weight-semibold"
				>There is a known issue with this project's appearance on Safari.</span
			>
			If possible, visit the page on another browser, such as Chrome or Firefox.
		</div> -->
      <!-- If mobile, nudge to larger screen -->
      <!-- Only show mobile nudge on non-Safari browsers (don't want to duplicate) -->
      <!-- Mobile safari users can attribute the bugginess to Safari, not mobile -->
      <!-- <div class="notification is-fixed is-danger mb-0" v-if="showMobileNudge">
				<button class="delete" @click="showMobileNudge = false"></button>
				Pssst. You might have a better experience on a wider screen, such as a
				desktop computer.
			</div> -->
      <Intro :width="windowWidth" />
      <Barchart
        :data="album_hums"
        :containerWidth="width"
        :containerHeight="height"
        :windowWidth="windowWidth"
        :responsiveOffset="responsiveOffset"
      />
      <Beeswarm
        :data="song_hums"
        :major_albums="major_albums"
        :album_data="album_hums"
        :containerWidth="width"
        :containerHeight="height"
        :windowWidth="windowWidth"
        :responsiveOffset="responsiveOffset"
      />
      <Table
        :containerWidth="windowWidth"
        :data="song_hums"
        :major_albums="major_albums"
      />
      <!-- Spacer -->
      <div class="spacer"></div>
      <Stripplot
        :data="motm_tokenized"
        :major_albums="major_albums"
        :album_data="album_hums"
        :sections_data="sections_grouped"
        :containerWidth="width"
        :containerHeight="height"
        :windowWidth="windowWidth"
        :responsiveOffset="responsiveOffset"
      />
      <Outro />
      <div class="container is-widescreen">
        <SongSelector :data="motm_tokenized" :songData="song_hums" />
      </div>
      <Footer />
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";

import Stripplot from "./components/Stripplot.vue";
import Beeswarm from "./components/Beeswarm.vue";
import Barchart from "./components/Barchart.vue";
import Table from "./components/Table.vue";
import SongSelector from "./components/SongSelector.vue";

import Intro from "./components/Intro.vue";
import Outro from "./components/Outro.vue";
import Footer from "./components/Footer.vue";
import LoadingScreen from "./components/LoadingScreen.vue";

export default {
  name: "App",
  components: {
    Stripplot,
    Beeswarm,
    Barchart,
    Table,
    SongSelector,
    Intro,
    Outro,
    Footer,
    LoadingScreen,
  },
  data() {
    return {
      song_hums: [],
      album_hums: [],
      motm_tokenized: [],
      major_albums: [],
      song_names: [],
      sections_grouped: [],
      windowWidth: null,
      width: null,
      height: null,
      // showSafariWarning: false,
      // showMobileNudge: false,
      DEBUG: false,
    };
  },
  async mounted() {
    // HANDLE SAFARI AND MOBILE USERS
    // if (
    // 	navigator.userAgent.indexOf("Safari") != -1 &&
    // 	navigator.userAgent.indexOf("Chrome") == -1
    // ) {
    // 	this.showSafariWarning = true;
    // }
    // this.checkWidthForWarning();

    this.windowWidth = window.innerWidth;
    // Eventual chart container width is dependent on screensize
    // On mobile devices, should take up nearly the whole viewport because step is overlayed on top
    // On desktop, chart only takes up 2/3 width
    this.width =
      window.innerWidth < 968
        ? window.innerWidth * 0.9
        : window.innerWidth * 0.6;
    this.height = window.innerHeight * 0.8;

    const song_hums = await d3.csv("./data/song_hums.csv");
    song_hums.forEach((d) => {
      d.n_hums = +d.n_hums;
      d.n_regulars = +d.n_regulars;
      d.percent_hums = +d.percent_hums;
    });
    this.song_hums = song_hums;

    let album_hums = await d3.csv("./data/album_hums.csv");
    album_hums.forEach((d) => {
      d.sum_hums = +d.sum_hums;
      d.sum_regulars = +d.sum_regulars;
      d.percent_hums = +d.percent_hums;
      d.year = +d.year;
    });
    album_hums.sort((a, b) => d3.descending(a.percent_hums, b.percent_hums));
    this.album_hums = album_hums;

    let motm_tokenized = await d3.csv("./data/motm_tokenized.csv");
    motm_tokenized.forEach((d) => {
      d.normalized_position = +d.normalized_position;
      d.position = +d.position;
      d.song_rank = +d.song_rank;
    });
    motm_tokenized.sort((a, b) => d3.descending(a.song_rank, b.song_rank));
    this.motm_tokenized = motm_tokenized;

    let major_albums = album_hums.map((d) => d.album_name);
    this.major_albums = major_albums;

    let song_names = [...new Set(motm_tokenized.map((d) => d.song_name))];
    this.song_names = song_names;

    let sections_grouped = await d3.csv("./data/sections_grouped.csv");
    sections_grouped.forEach((d) => {
      d.Hum = +d.Hum;
      d.Regular = +d.Regular;
    });
    this.sections_grouped = sections_grouped;

    if (this.DEBUG) {
      console.log(album_hums);
      console.log(song_hums);
      console.log(motm_tokenized);
      console.log(song_names);
      console.log(sections_grouped);
    }
  },
  methods: {
    watchResize: function () {
      // * Only trigger resize if width changes
      // * Moreover, only change height if we are already on a large device
      // * Prevents rerender on mobile scroll (with URL bar bug)
      // https://stackoverflow.com/questions/8898412/iphone-ipad-triggering-unexpected-resize-events
      if (window.innerWidth < 768) {
        if (window.innerWidth != this.windowWidth) {
          this.width =
            window.innerWidth < 968
              ? window.innerWidth * 0.9
              : window.innerWidth * 0.6;
          this.height = window.innerHeight * 0.8;
          this.windowWidth = window.innerWidth;
          // this.checkWidthForWarning();
        }
      } else {
        this.width =
          window.innerWidth < 968
            ? window.innerWidth * 0.9
            : window.innerWidth * 0.6;
        this.height = window.innerHeight * 0.8;
        this.windowWidth = window.innerWidth;
        // this.checkWidthForWarning();
      }
    },
    // checkWidthForWarning: function () {
    // 	window.innerWidth > 600
    // 		? (this.showMobileNudge = false)
    // 		: (this.showMobileNudge = true);
    // },
  },
  computed: {
    responsiveOffset() {
      return this.windowWidth > 600 ? 0.8 : 0.8;
    },
  },
  created() {
    window.addEventListener("resize", debounce(this.watchResize, 100)); // this.watchResize
  },
  destroyed() {
    window.removeEventListener("resize", debounce(this.watchResize, 100)); // this.watchResize
  },
};
</script>

<style lang="scss">
body,
text {
  color: $white-alt;
  font-family: $font-sans;
}

.title {
  color: $white-alt !important;
}

html {
  font-family: $font-sans;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: $white-alt;
  background-color: $background;
}

#app {
  font-family: $font-sans;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: $white-alt;
  background-color: $background;
}

/* SCROLLAMA */
.graphic {
  border: none;
  background-color: $background;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.step {
  padding: 1rem;
  width: 90%;
  max-width: 568px;
  margin: 30rem auto; // 0 auto 50%
  display: flex;
  flex-direction: column;
  text-align: left;
  line-height: 1.5;
  font-weight: 300;
  z-index: 999;
  opacity: 0.85;

  background: transparent;
  color: white;
  border: none;

  font-family: $font-sans;

  .highlight-text {
    font-weight: 600;
    padding: 3px;
    border-radius: 3px;
    /* white-space: nowrap; */
    display: inline;
    box-decoration-break: clone;
    background: $cudi-pink;
    background: linear-gradient(to left, transparent 50%, $cudi-pink 50%) right;
    background-size: 200% 1.2em;
    transition: 1s ease-out 200ms;

    &.blue {
      background: #4c6dbc;
      background: linear-gradient(to left, transparent 50%, #4c6dbc 50%) right;
      background-size: 200% 1.2em;
      transition: 1s ease-out 200ms;
    }
  }

  &.active {
    opacity: 1;
    pointer-events: auto;

    .highlight-text {
      color: $white-alt;
      background-position: left;
    }
  }

  & p:not(:last-child) {
    margin-bottom: 1rem;
  }
  @media screen and (max-width: 968px) {
    @supports (-webkit-backdrop-filter: blur(7px)) or (backdrop-filter: blur(7px)) {
      background: rgba(0, 0, 0, .25);
      color: white;
      backdrop-filter: blur(10px) contrast(90%);
      border-radius: 2px;

      & .content {
        text-shadow: 1px 1px 1px black;
      }
    }

    @supports ((not (-webkit-backdrop-filter: blur(7px))) and (not (backdrop-filter: blur(7px)))) {
          background: rgba(0, 0, 0, 0.9);
          color: white;
          border-radius: 2px;
      }
  }
}

.scrollama-steps {
  pointer-events: none;
}

.step iframe,
.step button {
  pointer-events: auto;
}

.scrollama-container {
  display: flex;
  flex-direction: row-reverse;
  .scrollama-graphic {
    flex: 2;
    height: 95%;
  }
  .scrollama-steps {
    flex: 1;
  }

  @media screen and (max-width: 968px) {
    flex-direction: column;
    // align-items: center;
    // justify-content: center;
  }

  margin-bottom: 500px;
}

// TEXT HIGHLIGHTING AND OTHER GLOBALs
// no animation text-highlight
.highlight-text-static {
  font-weight: 600;
  padding: 3px;
  border-radius: 3px;
  display: inline;
  background: $cudi-pink;
  color: $white-alt;

  &.mobile-toggle {
    @media screen and (max-width: 768px) {
      background: none;
      color: $cudi-pink;
    }
  }
}

.blue {
  background: $cudi-blue;
}

// rect {
//   stroke: black;
// }

.place-items-center {
  place-items: center;
}

// For notification/warnings
.is-fixed {
  position: fixed !important;
  bottom: 0; // top: 0
  z-index: 1000;
  width: 100%;
}

a[href] {
  color: $cudi-pink;
  // text-decoration: underline;

  &:hover {
    color: white;
  }
}

.absolute-bottom-right {
  position: fixed;
  bottom: 0;
  right: 0;
  z-index: 1000;
}

.spacer {
  height: 300px;
}

a {
  color: #ce496a !important;
  font-weight: 300;
}

.button:focus:not(:active),
.button.is-focused:not(:active) {
  -webkit-box-shadow: none;
  box-shadow: none;
}

.button:focus,
.button.is-focused {
  border-color: #ce496a;
}

.select select:focus,
.taginput .taginput-container.is-focusable:focus,
.textarea:focus,
.input:focus,
.select select.is-focused,
.taginput .is-focused.taginput-container.is-focusable,
.is-focused.textarea,
.is-focused.input,
.select select:active,
.taginput .taginput-container.is-focusable:active,
.textarea:active,
.input:active,
.select select.is-active,
.taginput .is-active.taginput-container.is-focusable,
.is-active.textarea,
.is-active.input {
  border-color: #ce496a;
  box-shadow: none;
}

.switch input[type="checkbox"]:focus:checked + .check,
.switch input[type="checkbox"]:active:checked + .check {
  -webkit-box-shadow: 0 0 0.5em #ce496a;
  box-shadow: 0 0 0.5em #ce496a;
}
</style>
