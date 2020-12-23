<template>
	<div id="app">
		<!-- If on Safari, nudge to another browser -->
		<div class="notification is-fixed is-danger mb-0" v-if="showSafariWarning">
			<button class="delete" @click="showSafariWarning = false"></button>
			Thanks for visiting!
			<span class="has-text-weight-semibold"
				>There is a known issue with this project's appearance on Safari.</span
			>
			If possible, visit the page on another browser, such as Chrome or Firefox.
		</div>
		<!-- If mobile, nudge to larger screen -->
		<!-- Only show mobile nudge on non-Safari browsers (don't want to duplicate) -->
		<!-- Mobile safari users can attribute the bugginess to Safari, not mobile -->
		<div
			class="notification is-fixed is-danger mb-0"
			v-if="showMobileNudge & !showSafariWarning"
		>
			<button class="delete" @click="showMobileNudge = false"></button>
			Pssst. You might have a better experience on a wider screen, such as a
			desktop computer.
		</div>
		<Intro :width="windowWidth" />
		<div
			v-if="
				(song_hums.length > 0) &
				(major_albums.length > 0) &
				(album_hums.length > 0)
			"
		>
			<Barchart
				:data="album_hums"
				:containerWidth="width"
				:containerHeight="height"
			/>

			<Beeswarm
				:data="song_hums"
				:major_albums="major_albums"
				:album_data="album_hums"
				:containerWidth="width"
				:containerHeight="height"
			/>
			<Stripplot
				:data="motm_tokenized"
				:major_albums="major_albums"
				:album_data="album_hums"
				:containerWidth="largerChartWidth"
				:containerHeight="height"
			/>
			<SongSelector
				:data="motm_tokenized"
				:songData="song_hums"
				:containerWidth="largerChartWidth"
				:containerHeight="height"
			/>
		</div>
		<Outro />
	</div>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";

import Stripplot from "./components/Stripplot.vue";
import Beeswarm from "./components/Beeswarm.vue";
import Barchart from "./components/Barchart.vue";
import SongSelector from "./components/SongSelector.vue";

import Intro from "./components/Intro.vue";
import Outro from "./components/Outro.vue";

export default {
	name: "App",
	components: {
		Stripplot,
		Beeswarm,
		Barchart,
		SongSelector,
		Intro,
		Outro,
	},
	data() {
		return {
			song_hums: [],
			album_hums: [],
			motm_tokenized: [],
			major_albums: [],
			song_names: [],
			windowWidth: null,
			width: null,
			largerChartWidth: null,
			height: null,
			showSafariWarning: false,
			showMobileNudge: false,
		};
	},
	async mounted() {
		// HANDLE SAFARI AND MOBILE USERS
		if (navigator.userAgent.indexOf("Safari") != -1) {
			this.showSafariWarning = true;
		}
		this.checkWidthForWarning();

		this.windowWidth = window.innerWidth;
		this.width =
			window.innerWidth < 1000
				? window.innerWidth * 0.9
				: window.innerWidth * 0.5;
		this.largerChartWidth = window.innerWidth * 0.8;
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
		motm_tokenized = motm_tokenized.filter(
			(d) => d.song_name != "Beautiful Trip"
		);

		this.motm_tokenized = motm_tokenized;

		let major_albums = album_hums.map((d) => d.album_name);
		this.major_albums = major_albums;

		let song_names = [...new Set(motm_tokenized.map((d) => d.song_name))];
		this.song_names = song_names;

		console.log(album_hums);
		console.log(song_hums);
		console.log(motm_tokenized);
		console.log(song_names);
	},
	methods: {
		watchResize: function () {
			this.width =
				window.innerWidth < 1000
					? window.innerWidth * 0.9
					: window.innerWidth * 0.5;
			this.height = window.innerHeight * 0.8;
			this.largerChartWidth = window.innerWidth * 0.8;
			this.windowWidth = window.innerWidth;

			this.checkWidthForWarning();

			// alert("You might want to refresh your browser");
		},
		checkWidthForWarning: function () {
			if (window.innerWidth < 600) {
				this.showMobileNudge = true;
			} else {
				this.showMobileNudge = false;
			}
		},
	},
	created() {
		window.addEventListener("resize", this.watchResize); // debounce(this.watchResize, 500));
	},
	destroyed() {
		window.removeEventListener("resize", this.watchResize); //debounce(this.watchResize, 500));
	},
};
</script>

<style lang="scss">
body,
text {
	color: $white-alt;
}

.title {
	color: $white-alt !important;
}

#app {
	font-family: BlinkMacSystemFont, -apple-system, "Segoe UI", "Roboto", "Oxygen",
		"Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
		"Helvetica", "Arial", sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	color: $white-alt;
	background-color: $background;
}

text {
	font-family: BlinkMacSystemFont, -apple-system, "Segoe UI", "Roboto", "Oxygen",
		"Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
		"Helvetica", "Arial", sans-serif;
}

/* SCROLLAMA */
.graphic {
	/* height: 50%; */
	border: none;
	background-color: $background;
	/* font-size: 10rem; */
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
}

.step {
	padding: 2.5%;
	min-width: 300px;
	width: 60%;
	margin: 0 auto 50vh;
	background-color: $white-alt;
	border: 1px solid #cecece;
	/* border-radius: 3px; */
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	color: #ccc;
	text-align: center;
	// opacity: 0.9;
	line-height: 1.6;
	z-index: 1000;

	.highlight-text {
		font-weight: 600;
		padding: 3px;
		border-radius: 3px;
		/* white-space: nowrap; */
		display: inline-block;
		background: $cudi-pink;
		background: linear-gradient(to left, $white-alt 50%, $cudi-pink 50%) right;
		background-size: 200% 1.2em;
		transition: 1s ease-out 200ms;

		&.blue {
			background: #4c6dbc;
			background: linear-gradient(to left, $white-alt 50%, #4c6dbc 50%) right;
			background-size: 200% 1.2em;
			transition: 1s ease-out 200ms;
		}
	}

	&.active {
		color: black;
		border-left: 2px solid $cudi-pink;
		box-shadow: 0 0 7px 0 rgba(0, 0, 0, 0.12);

		.highlight-text {
			color: $white-alt;
			background-position: left;
		}
	}

	// Adding an empty modifier to the last section of each Scrollama instance
	&.empty {
		visibility: hidden;
	}
}

.scrollama-steps {
	pointer-events: none;
}

.step iframe {
	pointer-events: auto;
}

.step button {
	pointer-events: auto;
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
		@media screen and(max-width: 768px) {
			background: none;
			color: $cudi-pink;
		}
	}
}

.blue {
	background: $cudi-blue;
}

rect {
	stroke: black;
}

.has-text-primary {
	color: $cudi-pink !important;
}

.font-alt {
	font-family: $font-alt;
}

// For notification/warnings
.is-fixed {
	position: fixed !important;
	bottom: 0; // top: 0
	z-index: 1000;
}
</style>
