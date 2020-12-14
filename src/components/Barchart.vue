<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<div slot="graphic" class="graphic" id="barchart"></div>
		<div class="step" :class="{ active: 0 == currentStep }" data-step-no="0">
			<p class="content">The first way to analyze Cudi hums is by album...</p>
		</div>
		<div class="step" :class="{ active: 1 == currentStep }" data-step-no="1">
			<p class="content">
				Most recently, Kid Cudi came out with his __th studio album,
				<span class="highlight-text">Man on the Moon III: The Chosen</span>.
				<br />Not only is this album Cudi's most recent, it also has the
				greatest proportion of hums.
			</p>
		</div>
		<div class="step" :class="{ active: 2 == currentStep }" data-step-no="2">
			<p class="content">
				And by organizing the albums by their release year, it becomes evident
				that Kid Cudi has been humming more and more as his discography has
				developed.
				<br />
				With the notable exception of
				<span class="highlight-text blue"
					>SATELLITE FLIGHT: The Journey to Mother Moon</span
				>, Cudi's albums have become progressively more hum-centric.
			</p>
		</div>
		<div class="step" :class="{ active: 3 == currentStep }" data-step-no="3">
			<p class="content">
				Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus
				quia deserunt fuga ipsam doloribus laboriosam fugit voluptatem incidunt
				ducimus sequi, corrupti eius ullam repellat temporibus id quibusdam
				maxime molestias libero?
			</p>
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
			svg: null,
			xScale: null,
			yScale: null,
			colorScale: null,
			height: null,
			width: null,
			currentStep: null,
			album_cover_size: null,
			alreadyTriggeredBars: false,
		};
	},
	methods: {
		stepEnterHandler: function ({ element, index, direction }) {
			this.currentStep = index;
			// THE VERY FIRST TIME (AND ONLY GOING DOWN), TRANSITION
			if (index == 0 && direction == "down") {
				if (this.alreadyTriggeredBars == false) {
					this.transitionBars();
					// this.alreadyTriggeredBars = true;
				}
			}
			if (index == 0 && direction == "up") {
				this.sortBarsByPopularity();
				this.unhighlightBars();
			}
			if (index == 1) {
				this.sortBarsByPopularity();
				this.highlightBars("Man on the Moon III: The Chosen", null);
			}
			if (index == 2) {
				this.sortBarsByYear();
				this.highlightBars(
					"Man on the Moon III: The Chosen",
					"KiD CuDi presents SATELLITE FLIGHT: The journey to Mother Moon"
				);
			}
			if (index == 3) {
				this.sortBarsByPopularity();
				this.unhighlightBars();
			}
		},
		transitionBars: function () {
			const { bars, xScale, yScale, colorScale } = this;

			bars
				.attr("width", xScale.bandwidth())
				.attr("x", (d) => xScale(d.album_name))
				.attr("y", yScale(0))
				.attr("height", 0)
				.attr("fill", (d) => colorScale(d.album_name))
				.transition("transition")
				.duration(500)
				.attr("y", (d) => yScale(d.percent_hums))
				.attr("height", (d) => this.height - yScale(d.percent_hums));

			this.alreadyTriggeredBars = true;
		},
		sortBarsByPopularity: function () {
			const { bars, svg, data, xScale, yScale, colorScale } = this;

			bars
				.transition("sortBarsByPopularity")
				.duration(1000)
				.attr("width", xScale.bandwidth())
				.attr("x", (d) => xScale(d.album_name));

			svg.select(".x.axis").call(d3.axisBottom(xScale).tickSizeOuter(0));
			svg.select(".x.axis").selectAll("text").remove();

			svg
				.select(".x.axis")
				.selectAll(".tick")
				.data([
					...data.sort((a, b) => d3.descending(a.percent_hums, b.percent_hums)),
				])
				.append("svg:image")
				.attr("xlink:href", (d) => d.album_cover_art_url)
				.attr("width", this.album_cover_size)
				.attr("height", this.album_cover_size)
				.attr("x", -this.album_cover_size / 2)
				.attr("y", 1);
		},
		sortBarsByYear: function () {
			const { bars, svg, data, yScale, colorScale, width } = this;

			const yearData = [...data.sort((a, b) => d3.ascending(a.year, b.year))];

			const yearScale = d3
				.scaleBand()
				.domain(yearData.map((d) => d.year))
				.range([0, width])
				.padding(0.1);

			bars
				.transition("sortBarsByYear")
				.duration(1000)
				.attr("x", (d) => yearScale(d.year));

			svg.select(".x.axis").call(d3.axisBottom(yearScale).tickSizeOuter(0));
			svg.select(".x.axis").selectAll("text").remove();

			svg
				.select(".x.axis")
				.selectAll(".tick")
				.data(yearData.sort((a, b) => d3.ascending(a.year, b.year)))
				.append("svg:image")
				.attr("xlink:href", (d) => d.album_cover_art_url)
				.attr("width", this.album_cover_size)
				.attr("height", this.album_cover_size)
				.attr("x", -this.album_cover_size / 2)
				.attr("y", 1);
		},
		highlightBars: function (album1, album2) {
			const { bars } = this;

			bars
				.transition("highlightBars")
				.duration(1000)
				.attr("fill", function (d) {
					if (d.album_name == album1) {
						return "#D96481";
					} else if (d.album_name == album2) {
						return "#4C6DBC";
					} else {
						return "#cecece";
					}
				});
		},
		unhighlightBars: function () {
			const { bars } = this;

			bars.transition("unhighlightBars").duration(1000).attr("fill", "grey");
		},
		setupChart: function () {
			const margin = { top: 10, right: 30, bottom: 100, left: 60 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			let data = this.data.sort((a, b) =>
				d3.descending(a.percent_hums, b.percent_hums)
			);

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
				.range(["grey"]); // #4C6DBC // d3.schemeSet3

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.xScale).tickSizeOuter(0))
				.attr("class", "x axis"); // no-line no-ticks

			// Y axis
			svg
				.append("g")
				.call(
					d3
						.axisLeft(this.yScale)
						.ticks(4)
						.tickSize(-width)
						.tickFormat(d3.format(".0%"))
						.tickSizeOuter(0)
				)
				.attr("class", "y axis");

			// Select whichever is smaller; the chart width / data.length (so each square fits perfectly)
			// Or the bottom margin (rect size should never be greater than margin.bottom lest overflow)
			this.album_cover_size = Math.min(width / data.length, margin.bottom);

			svg.select(".x.axis").selectAll("text").remove();

			svg
				.select(".x.axis")
				.selectAll(".tick")
				.data([
					...data.sort((a, b) => d3.descending(a.percent_hums, b.percent_hums)),
				])
				.append("svg:image")
				.attr("xlink:href", (d) => d.album_cover_art_url)
				.attr("width", this.album_cover_size)
				.attr("height", this.album_cover_size)
				.attr("x", -this.album_cover_size / 2)
				.attr("y", 1);

			// Add dots
			const bars = svg
				.append("g")
				.selectAll("rect")
				.data(data)
				.enter()
				.append("rect");

			this.bars = bars;
			this.svg = svg;
		},
		watchResize: function () {
			d3.select("#barchart > svg").remove();
			this.setupChart();
			this.transitionBars();
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
.y.axis line {
	stroke: grey;
	opacity: 0.25;
}
</style>
