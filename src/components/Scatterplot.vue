<template>
	<div id="scatterplot"></div>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";

export default {
	name: "Scatterplot",
	props: {
		data: Array,
		major_albums: Array,
		album_data: Array,
		width: Number,
		height: Number,
	},
	mounted() {
		this.drawChart();
	},
	methods: {
		drawChart: function () {
			const margin = { top: 10, right: 30, bottom: 30, left: 60 };
			const width = this.width - margin.left - margin.right;
			const height = this.height - margin.top - margin.bottom;

			// Append the svg object to the div
			var svg = d3
				.select("#scatterplot")
				.append("svg")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			let data = this.data;

			const xScale = d3
				.scaleLinear()
				.domain([-1, d3.max(data, (d) => d.n_hums)])
				.range([0, width]);
			const yScale = d3
				.scaleLinear()
				.domain(d3.extent(data, (d) => d.n_regulars))
				.range([height, 0])
				.nice();

			const colorScale = d3
				.scaleOrdinal()
				.domain(this.major_albums)
				.range(d3.schemeSet3);

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(
					d3
						.axisBottom(xScale)
						.tickFormat(d3.format(","))
						.ticks(6)
						.tickSizeOuter(0)
				)
				.attr("class", "x axis transparent-axis");

			// Y axis
			svg
				.append("g")
				.call(
					d3.axisLeft(yScale).tickSize(0).tickFormat(d3.format(",")).ticks(6)
				)
				.attr("class", "y axis");

			// Add dots
			svg
				.append("g")
				.selectAll("dot")
				.data(data)
				.enter()
				.append("circle")
				.attr("cx", (d) =>
					// Here, add random jitter if number of hums is 0
					d.n_hums == 0 ? xScale(d.n_hums + Math.random()) : xScale(d.n_hums)
				)
				.attr("cy", (d) => yScale(d.n_regulars))
				.style("fill", (d) => colorScale(d.album_name))
				.attr("r", 7.5)
				.attr("stroke", "black")
				.attr("opacity", 0.8);
		},
		watchResize: function () {
			d3.select("#scatterplot > svg").remove();
			this.drawChart();
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

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
