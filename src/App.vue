<template>
	<div id="app">
		<!-- LOADING SCREEN UNTIL ALL DATASETS ARE LOADED -->
		<div
			v-if="
				(song_hums.length == 0) |
					(major_albums.length == 0) |
					(album_hums.length == 0) |
					(sections_grouped.length == 0)
			"
			class="hero"
		>
			<div class="hero-body">
				<div class="title">LOADING SCREEN</div>
			</div>
		</div>
		<div
			v-if="
				(song_hums.length > 0) &
				(major_albums.length > 0) &
				(album_hums.length > 0) &
				(sections_grouped.length > 0)
			"
		>
			<div class="absolute-bottom-right">
				<p class="heading">{{ section }}</p>
			</div>
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
			<div class="notification is-fixed is-danger mb-0" v-if="showMobileNudge">
				<button class="delete" @click="showMobileNudge = false"></button>
				Pssst. You might have a better experience on a wider screen, such as a
				desktop computer.
			</div>
			<Intro
				:width="windowWidth"
				v-observe-visibility="
					(isVisible, entry) => visibilityChanged(isVisible, entry, '')
				"
			/>
			<Barchart
				v-observe-visibility="
					(isVisible, entry) =>
						visibilityChanged(isVisible, entry, '01. Albums')
				"
				:data="album_hums"
				:containerWidth="width"
				:containerHeight="height"
			/>
			<!-- <div class="section container better-container">
				<p class="content">
					Kid Cudi hums a good amount—in some albums, up to 8% of his lyrics are
					hums or hum-like sounds. But is this really an accurate statistic? Are
					Cudi's hums equally distributed across songs, or could it be the case
					that one song with two-hundred hums is artificially inflating the
					proportions?
				</p>
			</div> -->
			<Beeswarm
				v-observe-visibility="
					(isVisible, entry) =>
						visibilityChanged(isVisible, entry, '02. Tracks')
				"
				:data="song_hums"
				:major_albums="major_albums"
				:album_data="album_hums"
				:containerWidth="width"
				:containerHeight="height"
			/>
			<Stripplot
				v-observe-visibility="
					(isVisible, entry) =>
						visibilityChanged(isVisible, entry, '03. Lyrics')
				"
				:data="motm_tokenized"
				:major_albums="major_albums"
				:album_data="album_hums"
				:sections_data="sections_grouped"
				:containerWidth="largerChartWidth"
				:containerHeight="height"
			/>
			<div>
				<SongSelector
					:data="motm_tokenized"
					:songData="song_hums"
					:containerWidth="largerChartWidth"
					:containerHeight="height"
				/>
			</div>
			<Outro
				v-observe-visibility="
					(isVisible, entry) => visibilityChanged(isVisible, entry, '')
				"
			/>
		</div>
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
			sections_grouped: [],
			windowWidth: null,
			width: null,
			largerChartWidth: null,
			height: null,
			// showSafariWarning: false,
			showMobileNudge: false,
			DEBUG: false,
			section: null,
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
		// motm_tokenized = motm_tokenized.filter(
		// 	(d) => d.song_name != "Beautiful Trip"
		// );

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
		sections_grouped = sections_grouped.filter(
			(d) =>
				(d.section_name != "Pre-Chorus") &
				(d.section_name != "Post-Chorus") &
				(d.section_name != "Bridge") &
				(d.section_name != "Interlude")
		);
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
			// ! Make this for mobile only, in each of the charts resize events
			// https://stackoverflow.com/questions/8898412/iphone-ipad-triggering-unexpected-resize-events
			if (window.innerWidth != this.windowWidth) {
				this.width =
					window.innerWidth < 1000
						? window.innerWidth * 0.9
						: window.innerWidth * 0.5;
				this.height = window.innerHeight * 0.8;
				this.largerChartWidth = window.innerWidth * 0.8;
				this.windowWidth = window.innerWidth;
				this.checkWidthForWarning();
			}
		},
		checkWidthForWarning: function () {
			if (window.innerWidth < 600) {
				this.showMobileNudge = true;
			} else {
				this.showMobileNudge = false;
			}
		},
		visibilityChanged(isVisible, entry, section) {
			this.isVisible = isVisible;
			// console.log(entry);
			// console.log(section);
			if (entry.isIntersecting) {
				this.section = section;
			}
		},
	},
	computed: {},
	created() {
		window.addEventListener("resize", debounce(this.watchResize, 500)); // this.watchResize
	},
	destroyed() {
		window.removeEventListener("resize", debounce(this.watchResize, 500)); // this.watchResize
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

html {
	font-family: $font-stack;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	color: $white-alt;
	background-color: $background;
}

#app {
	font-family: $font-stack;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	color: $white-alt;
	background-color: $background;
}

text {
	font-family: $font-stack;
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
	padding: 2%;
	min-width: 300px;
	width: 60%;
	margin: 30rem auto; // 0 auto 50%
	background-color: $white-alt;
	border: 1px solid #cecece;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	color: #cecece;
	text-align: center;
	line-height: 1.5;
	z-index: 1000;
	opacity: 0.85;
	// border-radius: 3px;

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
		opacity: 1;

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

.font-alt {
	font-family: $font-alt;
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
}
</style>
