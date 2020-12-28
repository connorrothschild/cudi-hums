<template>
	<Scrollama
		@step-enter="stepEnterHandler"
		:debug="false"
		:offset="responsiveOffset"
	>
		<!-- SCROLLAMA GRAPHIC -->
		<div slot="graphic" class="graphic" id="barchart">
			<p
				class="font-alt mt-2 is-size-2 is-size-4-mobile has-text-weight-light has-text-centered"
			>
				Hums by album
			</p>
		</div>
		<!-- SCROLLAMA STEPS -->
		<div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
			<p class="content">
				The first way to analyze Cudi hums is by album. <br />Kid Cudi has an
				extensive discography, having recorded seven studio albums and one
				mixtape since 2008.
			</p>
		</div>
		<div class="step" :class="{ active: 1 == currStep }" data-step-no="1">
			<p class="content">
				Most recently, Kid Cudi came out with his 7th studio album,
				<span class="highlight-text">Man on the Moon III: The Chosen</span>.
				<br />Not only is this album Cudi's most recent, it also has the
				greatest proportion of hums.
			</p>
		</div>
		<!-- Last step should remain active even when .step.empty enters viewport -->
		<div
			class="step"
			:class="{ active: (2 == currStep) | (3 == currStep) }"
			data-step-no="2"
		>
			<p class="content">
				When we organize these albums by their release year, it becomes evident
				that Kid Cudi has been humming more and more as his discography has
				developed.
			</p>
			<p class="content">
				With the exceptions of
				<span class="highlight-text blue">Indicud</span> and
				<span class="highlight-text blue">Speedin' Bullet 2 Heaven</span>,
				Cudi's albums have become progressively more hum-centric over time.
			</p>
		</div>
		<!-- BUFFER CLASS -->
		<div class="step empty"></div>
	</Scrollama>
</template>

<script>
import * as d3 from "d3";
import debounce from "lodash/debounce";
import "intersection-observer";
import Scrollama from "vue-scrollama";

export default {
	name: "Barchart",
	props: {
		data: Array,
		containerHeight: Number,
		containerWidth: Number,
	},
	mounted() {
		this.setupChart();
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
			currStep: null,
			albumCoverSize: null,
			response: {},
		};
	},
	computed: {
		responsiveOffset() {
			return window.innerWidth > 600 ? 0.5 : 0.85;
		},
	},
	methods: {
		stepEnterHandler: function ({ index, direction, element }) {
			// Grab for resize, see below
			this.response = { index, direction, element };
			this.currStep = index;

			// * Direction-agnostic handling of transitions
			// * Only trigger transition if elements don't yet have positions on chart (proxy: x)
			if (index == 0) {
				if (!d3.select(".barchart-bars").node().hasAttribute("x")) {
					this.transitionBars();
				} else {
					this.sortBarsByHum();
					this.unhighlightBars();
				}
			}
			if (index == 1) {
				this.sortBarsByHum();
				this.highlightBars("Man on the Moon III: The Chosen", null);
				d3.selectAll(".year-text").remove().exit();
			}
			if (index == 2) {
				this.sortBarsByYear();
				this.highlightBars(
					"Man on the Moon III: The Chosen",
					"Speedin’ Bullet 2 Heaven",
					"Indicud"
				);
			}
			if (index == 3) {
				d3.selectAll(".year-text").remove().exit();
				// this.sortBarsByYear();
				// this.highlightBars(
				// 	"Man on the Moon III: The Chosen",
				// 	"Speedin’ Bullet 2 Heaven",
				// 	"Indicud"
				// );
			}
		},
		percentFormat: d3.format(".1%"),
		transitionBars: function () {
			const { bars, xScale, width, yScale, colorScale } = this;

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
		},
		sortBarsByHum: function () {
			const { bars, svg, data, xScale, yScale, colorScale } = this;

			bars
				.transition("sortBarsByHum")
				.duration(1000)
				.attr("width", xScale.bandwidth())
				.attr("x", (d) => xScale(d.album_name));

			svg
				.select(".x.axis.barchart")
				.call(d3.axisBottom(xScale).tickSizeOuter(0));
			svg.select(".x.axis.barchart").selectAll("text").remove();

			svg
				.select(".x.axis.barchart")
				.selectAll(".tick")
				.data([
					...data.sort((a, b) => d3.descending(a.percent_hums, b.percent_hums)),
				])
				.append("svg:image")
				.attr("xlink:href", (d) => d.album_cover_art_url)
				.attr("width", this.albumCoverSize)
				.attr("height", this.albumCoverSize)
				.attr("x", -this.albumCoverSize / 2)
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
				.attr("width", yearScale.bandwidth())
				.attr("y", (d) => yScale(d.percent_hums))
				.attr("height", (d) => this.height - yScale(d.percent_hums))
				// .attr("fill", (d) => colorScale(d.album_name))
				.transition("sortBarsByYear")
				.duration(1000)
				.attr("x", (d) => yearScale(d.year));

			svg
				.select(".x.axis.barchart")
				.call(d3.axisBottom(yearScale).tickSizeOuter(0));
			svg.select(".x.axis.barchart").selectAll("text").remove();

			svg
				.select(".x.axis.barchart")
				.selectAll(".tick")
				.data(yearData.sort((a, b) => d3.ascending(a.year, b.year)))
				.append("svg:image")
				.attr("xlink:href", (d) => d.album_cover_art_url)
				.attr("width", this.albumCoverSize)
				.attr("height", this.albumCoverSize)
				.attr("x", -this.albumCoverSize / 2)
				.attr("y", 1);

			// Only append year text if its already empty
			if (d3.selectAll(".year-text").empty()) {
				svg
					.append("g")
					.attr("font-family", "sans-serif")
					.attr("font-size", 10)
					.attr("stroke-linecap", "round")
					.attr("stroke-linejoin", "round")
					.attr("text-anchor", "middle")
					.attr("class", "year-text")
					.selectAll("text")
					.data(yearData)
					.join("text")
					.text((d) => d.year)
					.attr("x", (d) => yearScale(d.year) + yearScale.bandwidth() / 2)
					.attr("y", 0)
					.attr("dy", "-.5em")
					.transition("textFallsFromTop")
					.duration(1000)
					.attr("y", (d) => yScale(d.percent_hums))
					.attr("fill", "white")
					.attr("stroke", "none");
			}
		},
		highlightBars: function (album1, album2, album3) {
			const { bars } = this;

			bars
				.transition("highlightBars")
				.duration(1000)
				.attr("fill", function (d) {
					if (d.album_name == album1) {
						return "#ce496a";
					} else if ((d.album_name == album2) | (d.album_name == album3)) {
						return "#4C6DBC";
					} else {
						return "#cecece";
					}
				});
		},
		unhighlightBars: function () {
			const { bars } = this;

			bars.transition("unhighlightBars").duration(1000).attr("fill", "#cecece");
		},
		setupChart: function () {
			const margin = { top: 30, right: 30, bottom: 100, left: 60 };
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
				.range(["#cecece"]); // #4C6DBC // d3.schemeSet3

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.xScale).tickSizeOuter(0))
				.attr("class", "x axis barchart");

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
				.attr("class", "y axis barchart");
			// Axis title
			svg
				.append("text")
				// .attr("transform", "rotate(-90)")
				.attr("y", 0 - margin.top / 1.5)
				.attr("x", 10)
				.attr("dy", "1em")
				.text("Percent of lyrics that are hums")
				.attr("class", "barchart-axis-title");

			// X axis album cover ticks
			// Select whichever is smaller; the chart width / data.length (so each square fits perfectly)
			// Or the bottom margin (rect size should never be greater than margin.bottom lest overflow)
			this.albumCoverSize = Math.min(width / data.length, margin.bottom);

			svg.select(".x.axis.barchart").selectAll("text").remove();

			svg
				.select(".x.axis.barchart")
				.selectAll(".tick")
				.data([
					...data.sort((a, b) => d3.descending(a.percent_hums, b.percent_hums)),
				])
				.append("svg:image")
				.attr("xlink:href", (d) => d.album_cover_art_url)
				.attr("width", this.albumCoverSize)
				.attr("height", this.albumCoverSize)
				.attr("x", -this.albumCoverSize / 2)
				.attr("y", 1);

			// Tooltip
			const tip = d3
				.select("#barchart")
				.append("div")
				.attr("class", "tooltip")
				.style("opacity", 0);

			// Add bars
			const bars = svg
				.append("g")
				.selectAll("rect")
				.data(data)
				.enter()
				.append("rect")
				.attr("class", "barchart-bars");

			const self = this;
			bars
				.on("mouseover", function (event, d) {
					tip.transition(300).style("opacity", 1);
					tip.html(`<p class='heading'> ${d.album_name} </p>
							  <p> ${self.percentFormat(d.percent_hums)} hums</p>`);

					const right = event.clientX > window.innerWidth / 2;
					const offset = right ? tip.node().offsetWidth + 15 : -15;

					tip
						.style("left", event.clientX - offset + "px")
						.style("top", event.clientY + "px");
				})
				.on("mousemove", function (event, d) {
					const right = event.clientX > window.innerWidth / 2;
					const offset = right ? tip.node().offsetWidth + 15 : -15;

					tip
						.style("left", event.clientX - offset + "px")
						.style("top", event.clientY + "px");
				})
				.on("mouseout", function (d) {
					tip.transition(300).style("opacity", 0);
				});

			this.bars = bars;
			this.svg = svg;
		},
		watchResize: function () {
			d3.select("#barchart > svg").remove();
			this.setupChart();

			// * My hacky workaround:
			// On step enter (above), we saved the response which included index, direction, and element
			// Now, we rereference those and pass them back into stepEnterHandler (to mimic the most recent method)

			// But because the methods only transition certain elements (fill, x position, etc.)
			// we first run the initializing method, transition bars
			this.transitionBars();
			this.stepEnterHandler(this.response);
		},
	},
	watch: {
		containerWidth: function () {
			this.watchResize();
		},
	},
	// created() {
	// 	window.addEventListener("resize", debounce(this.watchResize, 1000));
	// },
	// destroyed() {
	// 	window.removeEventListener("resize", debounce(this.watchResize, 1000));
	// },
};
</script>

<style src="vue-scrollama/dist/vue-scrollama.css"></style>
<style lang="scss">
.y.axis.barchart {
	// Axis ticks
	g.tick line {
		stroke: whitesmoke;
		opacity: 0.5;
	}
	// Axis labels
	text {
		font-size: 14px;
		font-weight: 200;
	}
}

.axis.barchart {
	// Axis lines
	path {
		stroke: transparent;
		// stroke: whitesmoke;
		// opacity: 0.35;
	}
}

.barchart-axis-title {
	font-size: 12px;
	font-weight: 300;
	text-anchor: start;
	fill: $white-alt;
}

#barchart div.tooltip {
	position: absolute;
	text-align: center;
	font-family: $font-alt;
	font-size: 14px;
	pointer-events: none;
	color: $white-alt;
	background: #242424;
	padding: 5px;
	border-radius: 3px;
	z-index: 100;
	border: 1px solid grey;
}
</style>
