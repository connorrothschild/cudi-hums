<template>
	<div id="beeswarm"></div>
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
			const margin = { top: 10, right: 30, bottom: 30, left: 50 };
			const width = this.width - margin.left - margin.right;
			const height = this.height - margin.top - margin.bottom;

			const album_cover_size = height / this.major_albums.length;

			// Append the svg object to the div
			var svg = d3
				.select("#beeswarm")
				.append("svg")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			let data = this.data;

			// data.sort((a,b) => d3.descending(a.percent_hums, b.percent_hums))
			let filteredData = data.filter((d) =>
				this.major_albums.includes(d.album_name)
			);
			console.log(data);

			const xScale = d3
				.scaleLinear()
				.domain([-0.01, d3.max(filteredData, (d) => d.percent_hums)])
				.range([0, width]);

			const yScale = d3
				.scalePoint()
				.domain(filteredData.map((d) => d.album_name))
				.range([height, 0])
				.padding(0.7); // Padding around bounds

			console.log(this.major_albums);
			const colorScale = d3
				.scaleOrdinal()
				.domain(filteredData.map((d) => d.album_name))
				.range(d3.schemeSet3);

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(
					d3
						.axisBottom(xScale)
						.tickFormat(d3.format(".0%"))
						.ticks(4)
						.tickSizeOuter(0)
				)
				.attr("class", "x axis transparent-axis");

			// Y axis
			svg
				.append("g")
				.call(d3.axisLeft(yScale).tickSize(0))
				.attr("class", "y axis");

			svg.select(".y.axis").selectAll("text").remove();

			svg
				.select(".y.axis")
				.selectAll(".tick")
				.data(this.album_data)
				.append("svg:image")
				.attr("xlink:href", function (d) {
					return d.album_cover_art_url;
				})
				.attr("width", album_cover_size)
				.attr("height", album_cover_size)
				.attr("x", -album_cover_size)
				.attr("y", -album_cover_size / 2);

			// * OPTION: Add jitter by uncommenting code:
			// const jitterWidth = height / 50;
			const jitterWidth = 0;

			// Add dots
			svg
				.append("g")
				.selectAll("dot")
				.data(filteredData)
				.enter()
				.append("circle")
				.attr("class", "dot")
				.attr("cx", (d) => xScale(d.percent_hums))
				.attr("cy", (d) =>
					Math.random() >= 0.5 // Randomly put half of dots above line, half below
						? yScale(d.album_name) - Math.random() * jitterWidth
						: yScale(d.album_name) + Math.random() * jitterWidth
				)
				.attr("r", 7.5)
				.attr("stroke", "black")
				.attr("opacity", 0.8)
				.attr("fill", (d) => colorScale(d.album_name));
		},
		watchResize: function () {
			d3.select("#beeswarm > svg").remove();
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

<style>
.transparent-axis g.tick line {
	stroke: transparent;
}

g.tick text {
	font-size: 1rem;
}
</style>
