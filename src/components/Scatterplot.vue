<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<div slot="graphic" class="graphic" id="scatterplot"></div>
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
	components: {
		Scrollama,
	},
	mounted() {
		this.setupChart();
	},
	data() {
		return {
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
		setupChart: function () {
			const margin = { top: 10, right: 30, bottom: 30, left: 60 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			this.width = width;
			this.height = height;

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
				.transition()
				.duration(1000)
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
			this.setupChart();
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
