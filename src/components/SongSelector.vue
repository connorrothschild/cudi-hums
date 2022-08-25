<template>
  <div class="p-1">
    <div class="is-flex flex-direction-column-mobile is-align-items-center">
      <div class="flex-30-fixed">
        <h1
          class="title has-text-centered has-text-weight-semibold has-text-white"
        >
          Why don't you explore for yourself?
        </h1>
        <h2 class="subtitle mt-2 has-text-centered has-text-white">
          Here, you can select a song from
          <span class="has-text-weight-semibold">Man on the Moon III</span>
          and read the hums from each section.
        </h2>
        <div class="has-text-centered content">
          <label for="songs" class="heading">Select a song:</label>
          <div class="select" v-if="songNames">
            <select id="songs" name="songs" v-model="selectedSong">
              <option v-for="song in songNames" :key="song" :value="song">
                {{ song }}
              </option>
            </select>
          </div>
        </div>
        <div v-if="selectedSongData" class="better-flex">
          <!-- Once the user selects a song, provide them a link to the Genius lyrics page -->
          <div class="mb-2">
            <!-- <a
					class="heading button genius-style"
					target="_blank"
					rel="noopener"
					v-bind:href="selectedSongData.song_lyrics_url"
					>See this song on Genius</a
				> -->
            <!-- Embed of spotify player -->
            <iframe
              :src="selectedSongEmbed"
              width="300"
              height="80"
              frameborder="0"
              allowtransparency="true"
              allow="encrypted-media"
            ></iframe>
          </div>
          <!-- Here, user selects a song.
            Their options are all of the songs in MOTM3, provided as a prop from App.vue -->
          <!-- <p>{{ selectedSong }}</p> -->
          <div class="is-flex">
            <div
              class="card is-flex is-justify-content-center has-background-dark m-1"
            >
              <div
                class="card-content is-flex is-flex-direction-column is-justify-content-space-around less-padding has-text-white"
              >
                <p class="card-title">
                  {{ percentFormat(selectedSongData.percent_hums) }} hums
                </p>
                <p class="small">
                  {{ commaFormat(selectedSongData.n_hums) }} hums
                </p>
                <p class="small">
                  {{ commaFormat(selectedSongData.n_regulars) }}
                  regular lyrics
                </p>
              </div>
            </div>
            <div
              class="card is-flex is-justify-content-center has-background-dark m-1"
            >
              <div
                class="card-content is-flex is-flex-direction-column is-justify-content-space-around less-padding has-text-white"
              >
                <p class="card-title">#{{ selectedSongData.rank }}</p>
                <p class="small">Out of 16 songs</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Once the user selects a song, render LyricExplorer component -->
      <div v-if="selectedSong" class="flex-70-fixed">
        <LyricExplorer
          :songData="selectedSongLyrics"
          :sections="allSongSections"
        />
      </div>
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";
import LyricExplorer from "@/components/LyricExplorer.vue";

export default {
  name: "SongSelector",
  props: {
    data: Array,
    songData: Array,
  },
  mounted() {},
  components: {
    LyricExplorer,
  },
  data() {
    return {
      selectedSong: "Sept. 16",
    };
  },
  computed: {
    songNames: function () {
      return this.songData
        .filter((d) => d.album_name == "Man on the Moon III: The Chosen")
        .map((d) => d.song_name);
    },
    selectedSongData: function () {
      return this.songData.find((d) => d.song_name == this.selectedSong);
    },
    selectedSongLyrics: function () {
      // This represents the filtered dataset for user-selected song
      const { selectedSong } = this;
      const allData = this.data;

      const selectedSongLyrics = allData.filter(function (d) {
        return d.song_name == selectedSong;
      });
      return selectedSongLyrics;
    },
    selectedSongEmbed: function () {
      // The Spotify embed code for user-selected song
      const { selectedSongLyrics } = this;
      return [...new Set(selectedSongLyrics.map((d) => d.embed_url))];
    },
    allSongSections: function () {
      // All of the song 'sections' in user-selected song (intro, chorus, outro, etc.)
      const { selectedSongLyrics } = this;
      return [...new Set(selectedSongLyrics.map((d) => d.section_name))];
    },
  },
  methods: {
    percentFormat: d3.format(".1%"),
    commaFormat: d3.format(","),
  },
  created() {},
  destroyed() {},
};
</script>

<style lang="scss">
.better-flex {
  display: flex;
  flex-direction: column;
  justify-content: space-around;
  place-items: center;

  // @media screen and (max-width: 768px) {
  // 	flex-direction: column;
  // }
}

.flex-direction-column-mobile {
  @media screen and (max-width: 1000px) {
    flex-direction: column;
  }
}

.vertical-align-flex {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.button.genius-style {
  background: #121212;
  color: yellow;
  border-color: transparent;

  &:hover {
    color: yellow;
    border-color: yellow;
  }
}

// CARD FORMATTING
.card-content {
  &.less-padding {
    padding: 1rem !important;
  }
  .card-title {
    text-align: center;
    text-transform: uppercase;
    font-size: 1.2rem;
  }
  .small {
    text-transform: uppercase;
    letter-spacing: 1px;
    font-size: 0.7rem;
    text-align: center;
  }
}

.flex-30-fixed {
  flex-basis: 30%;
  flex-grow: 0;
  flex-shrink: 0;
}

.flex-70-fixed {
  flex-basis: 70%;
  flex-shrink: 0;
  flex-grow: 0;
}
</style>
