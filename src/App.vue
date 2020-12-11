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
			<Scatterplot
				:data="song_hums"
				:major_albums="major_albums"
				:album_data="album_hums"
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
			<Barchart
				:data="album_hums"
				:containerWidth="width"
				:containerHeight="height"
			/>
		</div>
		<Outro />
	</div>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";

import Scatterplot from "./components/Scatterplot.vue";
import Beeswarm from "./components/Beeswarm.vue";
import Barchart from "./components/Barchart.vue";

import Intro from "./components/Intro.vue";
import Outro from "./components/Outro.vue";

export default {
	name: "App",
	components: {
		Scatterplot,
		Beeswarm,
		Barchart,
		Intro,
		Outro,
	},
	data() {
		return {
			song_hums: [],
			album_hums: [],
			major_albums: [],
			width: null,
			height: null,
		};
	},
	async mounted() {
		this.width = window.innerWidth * 0.9;
		this.height = window.innerHeight * 0.75;
		const song_hums = await d3.csv("./data/song_hums.csv");
		song_hums.forEach((d) => {
			d.n_hums = +d.n_hums;
			d.n_regulars = +d.n_regulars;
			d.percent_hums = +d.percent_hums;
		});
		this.song_hums = song_hums;

		const album_hums = await d3.csv("./data/album_hums.csv");
		album_hums.forEach((d) => {
			d.sum_hums = +d.sum_hums;
			d.sum_regulars = +d.sum_regulars;
			d.percent_hums = +d.percent_hums;
		});
		album_hums.sort((a, b) => d3.descending(a.percent_hums, b.percent_hums));
		this.album_hums = album_hums;

		const major_albums = album_hums.map((d) => d.album_name);
		this.major_albums = major_albums;
	},
	methods: {
		watchResize: function () {
			this.width = window.innerWidth * 0.9;
			this.height = window.innerHeight * 0.75;
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
	height: 100vh;
	border: none;
	background-color: whitesmoke;
	font-size: 10rem;
	display: flex;
	align-items: center;
	justify-content: center;
}

.step {
	padding: 15vh 5vh;
	min-width: 300px;
	width: 50%;
	margin: 0 auto 50vh;
	background-color: whitesmoke;
	border: 1px solid #ccc;
	border-radius: 5px;
	box-shadow: 1px solid black;
	display: flex;
	align-items: center;
	justify-content: center;
	color: #ccc;
}

.step.active {
	color: black;
}
</style>
