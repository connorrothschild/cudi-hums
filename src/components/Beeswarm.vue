<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<div slot="graphic" class="graphic" id="beeswarm"></div>
		<div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
			Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus quia
			deserunt fuga ipsam doloribus laboriosam fugit voluptatem incidunt ducimus
			sequi, corrupti eius ullam repellat temporibus id quibusdam maxime
			molestias libero?
		</div>
		<div class="step" :class="{ active: 1 == currStep }" data-step-no="1">
			Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus quia
			deserunt fuga ipsam doloribus laboriosam fugit voluptatem incidunt ducimus
			sequi, corrupti eius ullam repellat temporibus id quibusdam maxime
			molestias libero?
		</div>
		<div class="step" :class="{ active: 2 == currStep }" data-step-no="2">
			Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus quia
			deserunt fuga ipsam doloribus laboriosam fugit voluptatem incidunt ducimus
			sequi, corrupti eius ullam repellat temporibus id quibusdam maxime
			molestias libero?
		</div>
	</Scrollama>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";
import "intersection-observer";
import Scrollama from "vue-scrollama";

export default {
	name: "Scatterplot",
	props: {
		data: Array,
		major_albums: Array,
		album_data: Array,
		containerWidth: Number,
		containerHeight: Number,
	},
	mounted() {
		this.setupChart();
		this.regularCircles();
	},
	components: {
		Scrollama,
	},
	data() {
		return {
			circles: null,
			xScale: null,
			yScale: null,
			colorScale: null,
			jitterWidth: null,
			width: null,
			height: null,
			currStep: null,
		};
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.currStep = index;
			console.log(element, index, direction);
			if (index == 0) {
				this.regularCircles();
			}
			if (index == 1) {
				this.highlightCircles();
			}
			if (index == 2) {
				this.regularCircles();
			}
		},
		regularCircles: function () {
			const { circles, xScale, yScale, colorScale, jitterWidth } = this;

			circles
				.transition()
				.duration(1000)
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
		highlightCircles: function () {
			const { circles } = this;
			circles.transition().duration(1000).attr("fill", "black");
		},
		setupChart: function () {
			const margin = { top: 10, right: 30, bottom: 30, left: 60 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			this.width = width;
			this.height = height;

			const album_cover_size = height / this.major_albums.length;
			this.jitterWidth = 0; //*Optional: remove jitter by making this 0

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
			// console.log(data);

			this.xScale = d3
				.scaleLinear()
				.domain([-0.003, d3.max(filteredData, (d) => d.percent_hums)])
				.range([0, width]);

			this.yScale = d3
				.scalePoint()
				.domain(filteredData.map((d) => d.album_name))
				.range([height, 0])
				.padding(0.7); // Padding around bounds

			console.log(this.major_albums);
			this.colorScale = d3
				.scaleOrdinal()
				.domain(filteredData.map((d) => d.album_name))
				.range(d3.schemeSet3);

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(
					d3
						.axisBottom(this.xScale)
						.tickFormat(d3.format(".0%"))
						.ticks(4)
						.tickSizeOuter(0)
				)
				.attr("class", "x axis transparent-axis");

			// Y axis
			svg
				.append("g")
				.call(d3.axisLeft(this.yScale).tickSize(0))
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

			// Add dots
			const circles = svg
				.append("g")
				.selectAll("circle")
				.data(filteredData)
				.enter()
				.append("circle");

			this.circles = circles;
		},
		watchResize: function () {
			d3.select("#beeswarm > svg").remove();
			this.setupChart();
			this.regularCircles();
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

<style src="vue-scrollama/dist/vue-scrollama.css"></style>
<style>
.transparent-axis g.tick line {
	stroke: transparent;
}

g.tick text {
	font-size: 1rem;
}

.graphic {
	height: 100vh;
	border: 1px solid #ccc;
	background-color: white;
	font-size: 10rem;
	display: flex;
	align-items: center;
	justify-content: center;
}

.step {
	padding: 15vh 0;
	min-width: 300px;
	width: 50vw;
	margin: 0 auto 30vh;
	background-color: whitesmoke;
	border: 1px solid #ccc;
	border-radius: 5px;
	box-shadow: 1px solid black;
	display: flex;
	align-items: center;
	justify-content: center;
}
</style>
