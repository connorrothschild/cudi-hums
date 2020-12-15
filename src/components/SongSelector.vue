<template>
	<div class="container is-max-desktop">
		<div class="is-flex better-flex">
			<!-- Here, user selects a song.
            Their options are all of the songs in MOTM3, provided as a prop from App.vue -->
			<div class="vertical-align-flex">
				<label for="songs" class="heading">Select a song:</label>
				<div class="select" v-if="song_names">
					<select id="songs" name="songs" v-model="selectedSong">
						<option v-for="song in song_names" :key="song" :value="song">
							{{ song }}
						</option>
					</select>
				</div>
			</div>
			<!-- Once the user selects a song, provide them a link to the Genius lyrics page -->
			<div v-if="selectedSong">
				<a
					class="heading button"
					target="_blank"
					rel="noopener"
					v-bind:href="selectedSongUrl"
					>See this song on Genius</a
				>
			</div>
			<!-- ! FIXME: Also do Spotify embed? -->
		</div>
		<!-- Once the user selects a song, render LyricExplorer component -->
		<div v-if="selectedSong">
			<LyricExplorer :songData="selectedSongData" :sections="allSongSections" />
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
		song_names: Array,
		containerHeight: Number,
		containerWidth: Number,
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
		selectedSongData: function () {
			// This represents the filtered dataset for user-selected song
			const { selectedSong } = this;
			const allData = this.data;

			const selectedSongData = allData.filter(function (d) {
				return d.song_name == selectedSong;
			});
			console.log(selectedSongData.song_lyrics_url);
			return selectedSongData;
		},
		selectedSongUrl: function () {
			// The Genius lyrics page for user-selected song
			const { selectedSongData } = this;
			return [...new Set(selectedSongData.map((d) => d.song_lyrics_url))];
		},
		allSongSections: function () {
			// All of the song 'sections' in user-selected song (intro, chorus, outro, etc.)
			const { selectedSongData } = this;
			return [...new Set(selectedSongData.map((d) => d.section_name))];
		},
	},
	methods: {},
	created() {},
	destroyed() {},
};
</script>

<style lang="scss">
.better-flex {
	flex-direction: row;
	justify-content: space-around;
	place-items: center;

	@media screen and (max-width: 768px) {
		flex-direction: column;
	}
}

.vertical-align-flex {
	display: flex;
	flex-direction: column;
	align-items: center;
}
</style>