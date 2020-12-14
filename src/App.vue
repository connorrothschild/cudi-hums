<template>
	<div id="app">
		<Intro />
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

import Intro from "./components/Intro.vue";
import Outro from "./components/Outro.vue";

export default {
	name: "App",
	components: {
		Stripplot,
		Beeswarm,
		Barchart,
		Intro,
		Outro,
	},
	data() {
		return {
			song_hums: [],
			album_hums: [],
			motm_tokenized: [],
			major_albums: [],
			width: null,
			largerChartWidth: null,
			height: null,
		};
	},
	async mounted() {
		this.width =
			window.innerWidth < 1000
				? window.innerWidth * 0.9
				: window.innerWidth * 0.5;
		this.largerChartWidth = window.innerWidth * 0.8;
		this.height = window.innerHeight * 0.9;
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
			d.song_rank = +d.song_rank;
		});
		motm_tokenized.sort((a, b) => d3.descending(a.song_rank, b.song_rank));
		motm_tokenized = motm_tokenized.filter(
			(d) => d.song_name != "Beautiful Trip"
		);

		this.motm_tokenized = motm_tokenized;

		let major_albums = album_hums.map((d) => d.album_name);
		this.major_albums = major_albums;

		console.log(album_hums);
		console.log(song_hums);
		console.log(motm_tokenized);
	},
	methods: {
		watchResize: function () {
			this.width =
				window.innerWidth < 1000
					? window.innerWidth * 0.9
					: window.innerWidth * 0.5;
			this.height = window.innerHeight * 0.9;

			// alert("You might want to refresh your browser");
		},
	},
	created() {
		window.addEventListener("resize", debounce(this.watchResize, 500));
	},
	destroyed() {
		window.removeEventListener("resize", debounce(this.watchResize, 500));
	},
};
</script>

<style>
#app {
	font-family: BlinkMacSystemFont, -apple-system, "Segoe UI", "Roboto", "Oxygen",
		"Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue",
		"Helvetica", "Arial", sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	color: black;
	background-color: whitesmoke; /* Should be same as graphic background-color */
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
	background-color: whitesmoke; /* Should be same as #app background-color
	/* font-size: 10rem; */
	display: flex;
	align-items: center;
	justify-content: center;
}

@media screen and (max-width: 768px) {
	.graphic {
		flex-direction: column-reverse;
	}
}

.step {
	padding: 2.5%;
	min-width: 300px;
	width: 60%;
	margin: 0 auto 50vh;
	background-color: whitesmoke;
	border: 1px solid #ccc;
	/* border-radius: 3px; */
	box-shadow: 1px 1px 1px 1px #ccc;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	color: #ccc;
	text-align: center;
	/* opacity: 0.9; */
	line-height: 1.6;
}

.step.active {
	color: black;
	border-left: 2px solid #d96481;
}

.scrollama-steps {
	pointer-events: none;
}

.highlight-text {
	background: #d96481;
	font-weight: 600;
	padding: 3px;
	border-radius: 3px;
	color: white;
	/* white-space: nowrap; */
}

.blue {
	background: #4c6dbc;
}

rect {
	stroke: black;
}
</style>
