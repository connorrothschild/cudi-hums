<template>
	<div class="container is-max-desktop px-3">
		<h1 class="title has-text-centered has-text-white">
			Why don't you explore for yourself?
		</h1>
		<h2 class="subtitle mt-2 has-text-centered has-text-white">
			Here, you can select a song from
			<span class="has-text-weight-semibold">Man on the Moon III</span> and read
			the hums from each section.
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
		<div v-if="selectedSongData" class="is-flex better-flex">
			<!-- Here, user selects a song.
            Their options are all of the songs in MOTM3, provided as a prop from App.vue -->
			<!-- <p>{{ selectedSong }}</p> -->
			<div class="is-flex">
				<div class="card has-background-dark m-1">
					<div class="card-content has-text-white font-alt">
						{{ commaFormat(selectedSongData.n_hums) }} /
						{{
							commaFormat(selectedSongData.n_hums + selectedSongData.n_regulars)
						}}
						<br />
						{{ percentFormat(selectedSongData.percent_hums) }}
					</div>
				</div>
				<div class="card has-background-dark m-1">
					<div class="card-content has-text-white font-alt">
						Ranking within MOTM3
					</div>
				</div>
			</div>
			<!-- Once the user selects a song, provide them a link to the Genius lyrics page -->
			<div class="mobile-mt-3">
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
		</div>
		<!-- Once the user selects a song, render LyricExplorer component -->
		<div v-if="selectedSong">
			<LyricExplorer
				:songData="selectedSongLyrics"
				:sections="allSongSections"
			/>
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
		songNames: function () {
			return this.songData
				.filter((d) => d.album_name == "Man on the Moon III: The Chosen")
				.map((d) => d.song_name);
		},
		selectedSongData: function () {
			// console.log(this.songData.find((d) => d.song_name == this.selectedSong));
			return this.songData.find((d) => d.song_name == this.selectedSong);
		},
		selectedSongLyrics: function () {
			// This represents the filtered dataset for user-selected song
			const { selectedSong } = this;
			const allData = this.data;

			const selectedSongLyrics = allData.filter(function (d) {
				return d.song_name == selectedSong;
			});
			// console.log(selectedSongLyrics);
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

.mobile-mt-3 {
	@media screen and (max-width: 768px) {
		margin-top: 1.5rem;
	}
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
</style>
