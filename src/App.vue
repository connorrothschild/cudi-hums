<template>
	<div id="app">
		<Header />
		<div
			class="hero is-fullheight"
			v-if="(song_hums.length > 0) & (major_albums.length > 0)"
		>
			<Scatterplot
				:data="song_hums"
				:major_albums="major_albums"
				:album_data="album_hums"
				:width="width"
				:height="height"
			/>
			<Beeswarm
				:data="song_hums"
				:major_albums="major_albums"
				:album_data="album_hums"
				:width="width"
				:height="height"
			/>
		</div>
		<div v-if="album_hums.length > 0">
			<!-- <Barplot :data="album_hums" /> -->
		</div>
	</div>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";

import Scatterplot from "./components/Scatterplot.vue";
import Beeswarm from "./components/Beeswarm.vue";
import Header from "./components/Header.vue";

export default {
	name: "App",
	components: {
		Scatterplot,
		Beeswarm,
		Header,
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
		this.height = window.innerHeight * 0.5;
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
		this.album_hums = album_hums;

		const major_albums = album_hums.map((d) => d.album_name);
		this.major_albums = major_albums;
	},
	methods: {
		watchResize: function () {
			this.width = window.innerWidth * 0.9;
			this.height = window.innerHeight * 0.5;
			// console.log("Width is now ", this.width);
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
	font-family: Avenir, Helvetica, Arial, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	text-align: center;
	color: #2c3e50;
}
</style>
