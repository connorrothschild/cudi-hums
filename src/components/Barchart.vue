<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<div slot="graphic" class="graphic" id="barchart"></div>
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
		containerHeight: Number,
		containerWidth: Number,
	},
	mounted() {
		this.setupChart();
		// this.transitionBars();
	},
	components: {
		Scrollama,
	},
	data() {
		return {
			bars: null,
			xScale: null,
			yScale: null,
			colorScale: null,
			height: null,
			width: null,
			currStep: null,
		};
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.currStep = index;
			console.log(element, index, direction);
			// THE VERY FIRST TIME (AND ONLY GOING DOWN), TRANSITION
			if (index == 0 && direction == "down") {
				this.transitionBars();
			}
			if (index == 0 && direction == "up") {
				this.regularBars();
			}
			if (index == 1) {
				this.highlightBars();
			}
			if (index == 2) {
				this.regularBars();
			}
		},
		transitionBars: function () {
			const { bars, xScale, yScale, colorScale } = this;

			bars
				.attr("width", xScale.bandwidth())
				.attr("x", (d) => xScale(d.album_name))
				.attr("y", yScale(0))
				.attr("height", 0)
				.attr("fill", (d) => colorScale(d.album_name)) // plum?
				.transition()
				.duration(500)
				.attr("y", (d) => yScale(d.percent_hums))
				.attr("height", (d) => this.height - yScale(d.percent_hums));
		},
		regularBars: function () {
			const { bars, xScale, yScale, colorScale } = this;

			bars
				.attr("width", xScale.bandwidth())
				.attr("x", (d) => xScale(d.album_name))
				.attr("y", this.height)
				.attr("y", (d) => yScale(d.percent_hums))
				.attr("height", (d) => this.height - yScale(d.percent_hums))
				.transition()
				.duration(1000)
				.attr("fill", (d) => colorScale(d.album_name)); // plum?
		},
		highlightBars: function () {
			const { bars } = this;
			bars.transition().duration(1000).attr("fill", "black");
		},
		setupChart: function () {
			const margin = { top: 10, right: 30, bottom: 100, left: 60 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			let data = this.data;

			this.height = height;
			this.width = width;

			// Append the svg object to the div
			var svg = d3
				.select("#barchart")
				.append("svg")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			this.xScale = d3
				.scaleBand()
				.domain(data.map((d) => d.album_name))
				.range([0, width])
				.padding(0.1);

			this.yScale = d3
				.scaleLinear()
				.domain([0, d3.max(data, (d) => d.percent_hums)])
				.range([height, 0])
				.nice();

			this.colorScale = d3
				.scaleOrdinal()
				.domain(data.map((d) => d.album_name))
				.range(d3.schemeSet3);

			// //https://bl.ocks.org/mbostock/7555321#index.html
			// function wrap(text, width) {
			// 	text.each(function () {
			// 		var text = d3.select(this),
			// 			words = text.text().split(/\s+/).reverse(),
			// 			word,
			// 			line = [],
			// 			lineNumber = 0,
			// 			lineHeight = 1.1, // ems
			// 			y = text.attr("y"),
			// 			dy = parseFloat(text.attr("dy")),
			// 			tspan = text
			// 				.text(null)
			// 				.append("tspan")
			// 				.attr("x", 0)
			// 				.attr("y", y)
			// 				.attr("dy", dy + "em");
			// 		while ((word = words.pop())) {
			// 			line.push(word);
			// 			tspan.text(line.join(" "));
			// 			if (tspan.node().getComputedTextLength() > width) {
			// 				line.pop();
			// 				tspan.text(line.join(" "));
			// 				line = [word];
			// 				tspan = text
			// 					.append("tspan")
			// 					.attr("x", 0)
			// 					.attr("y", y)
			// 					.attr("dy", ++lineNumber * lineHeight + dy + "em")
			// 					.text(word);
			// 			}
			// 		}
			// 	});
			// }

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.xScale).tickSizeOuter(0))
				.attr("class", "x axis no-line no-ticks");

			// svg.selectAll(".x.axis g text").call(wrap, this.xScale.bandwidth());

			// Y axis
			svg
				.append("g")
				.call(
					d3
						.axisLeft(this.yScale)
						.tickSize(0)
						.tickFormat(d3.format(".0%"))
						.ticks(4)
						.tickSizeOuter(0)
				)
				.attr("class", "y axis");

			// * OPTION: Add album covers instead of titles

			// Select whichever is smaller; the chart width / data.length (so each square fits perfectly)
			// Or the bottom margin (rect size should never be greater than margin.bottom lest overflow)
			const album_cover_size = Math.min(width / data.length, margin.bottom);

			svg.select(".x.axis").selectAll("text").remove();
			svg
				.select(".x.axis")
				.selectAll(".tick")
				.data(data)
				.append("svg:image")
				.attr("xlink:href", function (d) {
					return d.album_cover_art_url;
				})
				.attr("width", album_cover_size)
				.attr("height", album_cover_size)
				.attr("x", -album_cover_size / 2)
				.attr("y", 0);
			// }

			// Add dots
			const bars = svg
				.append("g")
				.selectAll("rect")
				.data(data)
				.enter()
				.append("rect")
				.attr("class", "bar");

			this.bars = bars;
		},
		watchResize: function () {
			d3.select("#barchart > svg").remove();
			this.setupChart();
			// this.regularBars();
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
<style></style>
