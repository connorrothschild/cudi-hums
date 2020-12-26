<template>
	<Scrollama
		@step-enter="stepEnterHandler"
		:debug="false"
		:offset="responsiveOffset"
	>
		<!-- SCROLLAMA GRAPHIC -->
		<div slot="graphic" class="graphic" id="stripplot">
			<p
				class="font-alt mt-2 is-size-2 is-size-4-mobile has-text-weight-light has-text-centered"
			>
				Hums by lyric position
			</p>
		</div>
		<!-- SCROLLAMA STEPS -->
		<div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
			<p class="content">
				But where are Cudi's hums located? <br />Are they mostly concentrated at
				the beginnings and ends of each song, or somewhere in the middle?
			</p>
		</div>
		<div class="step" :class="{ active: 1 == currStep }" data-step-no="1">
			<p class="content">
				In this view, every line represents a lyric from
				<span class="has-text-weight-semibold">Man on the Moon III</span>.
				<span class="highlight-text blue">Blue lines</span>
				represent "regular" lyrics while
				<span class="highlight-text">pink lines</span> represent "hums" and
				other sounds, such as as 'oooh' and 'nah.'
			</p>
			<p class="content">
				The songs are different durations (notice how short
				<span class="has-text-weight-semibold">Beautiful Trip</span>
				is?), which is why the lengths of each bar are different.
			</p>
		</div>
		<div class="step" :class="{ active: 2 == currStep }" data-step-no="2">
			<p class="content">
				For better reference, we can normalize the position of each lyric. Here,
				each song is forced to the same bounds, so you're looking at where
				lyrics fall relative to the song's structure (<span
					class="has-text-weight-semibold"
					>e.g. middle of the song</span
				>), rather than their exact minute-second placement (<span
					class="has-text-weight-semibold"
					>e.g. 3:22</span
				>).
			</p>
		</div>
		<div class="step" :class="{ active: 3 == currStep }" data-step-no="3">
			<p class="content">
				By focusing only on hum-type sounds, we can isolate the noises that Cudi
				makes most frequently, and at what points in each song he makes them.
			</p>
			<div class="is-flex is-flex-direction-column">
				<button
					class="button font-alt"
					@click="
						handleFilter();
						unclicked = false;
					"
					:class="{ toggled: onlyHumsToggled }"
				>
					Only show hums
				</button>
				<p v-if="unclicked" class="mb-0 mt-3 heading is-size-7 has-text-grey">
					👆 Click me!
				</p>
			</div>
		</div>
		<div class="step" :class="{ active: 4 == currStep }" data-step-no="4">
			<p class="content">
				Different songs utilize hums in different ways. For example,
				<span class="highlight-text">The Void</span>
				captures Cudi's hums intermittently sprinkled throughout the song.
			</p>
			<iframe
				src="https://open.spotify.com/embed/track/2yg7MXp8nSPaf61HVkhEr3"
				width="300"
				height="80"
				frameborder="0"
				allowtransparency="true"
				allow="encrypted-media"
			></iframe>
		</div>
		<div class="step" :class="{ active: 5 == currStep }" data-step-no="5">
			<p class="content">
				While in other songs like
				<span class="highlight-text">She Knows This</span>, Cudi is much more
				rhythmic. In this song, Cudi spends the chorus alternating between the
				phrase 'she knows this' and a flurry of hums.
			</p>

			<iframe
				src="https://open.spotify.com/embed/track/1xzUQMiCoY5pdego0pHMeV"
				width="300"
				height="80"
				frameborder="0"
				allowtransparency="true"
				allow="encrypted-media"
			></iframe>
		</div>
		<div class="step" :class="{ active: 6 == currStep }" data-step-no="6">
			<p class="content">
				And so, in some songs, Cudi interlaces hums alongside the rest of his
				lyrics. But in others, the hums
				<em>define the structure of the song</em>.
			</p>
			<p class="content">
				Kid Cudi uses hums like any other artist would use an instrument. MORE
				HERE
			</p>
		</div>
		<!-- Last step should remain active even when .step.empty enters viewport -->
		<div
			class="step"
			:class="{ active: (7 == currStep) | (8 == currStep) }"
			data-step-no="7"
		>
			<p class="content">
				Finally, group by song category: Intro, Chorus, Bridge, Outro, etc.
				<i>some cool transition goes here for sure.</i>
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
	name: "Stripplot",
	props: {
		data: Array,
		major_albums: Array,
		album_data: Array,
		sections_data: Array,
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
			margin: null,
			currStep: null,
			xScale: null,
			yScale: null,
			colorScale: null,
			svg: null,
			lines: null,
			unclicked: true,
			onlyHumsToggled: false,
			alreadyTriggered: false,
			response: {},
		};
	},
	computed: {
		computedStrokeWidth: function () {
			// container width divided by the length of the longest song (most words aka most lines)
			// console.log(d3.rollup(
			// 	this.data,
			// 	(v) => v.length,
			// 	(d) => d.song_name
			// ))
			return this.containerWidth / 550;
		},
		computedHeightBuffer: function () {
			return this.height / 100;
		},
		responsiveOffset() {
			return window.innerWidth > 600 ? 0.5 : 0.85;
		},
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.response = { element, index, direction };
			this.currStep = index;

			if (index == 0 && direction == "down" && this.alreadyTriggered == false) {
				this.transitionStrips();
				this.stripByPosition();

				this.alreadyTriggered = true;
			}
			if (index == 0 && direction == "down" && this.alreadyTriggered == true) {
				this.stripByPosition();
			}
			if (index == 0 && direction == "up") {
				this.stripByPosition();
			}
			if (index == 1) {
				this.stripByPosition();
			}
			if (index == 2) {
				// * Normalize
				this.stripByNormalizedPosition();
			}
			if (index == 3 && direction == "down") {
				// * Highlight hums only
				this.stripByNormalizedPosition();
				this.filterHums();
			}
			if (index == 3 && direction == "up") {
				this.defaultHeight();
				this.defaultOpacity();
			}
			if (index == 4) {
				// ! Highlight a few hums...

				this.filterHums();
				this.highlightSong("The Void");
			}
			if (index == 5) {
				// ! Highlight a few hums...

				this.filterHums();
				this.highlightSong("She Knows This");
			}
			if (index == 6) {
				this.defaultHeight();
				this.stripByNormalizedPosition();
				this.filterHums();
			}
			if (index == 6 && direction == "up") {
				this.undoBars();
				this.stripByNormalizedPosition();
			}
			if (index == 7 && direction == "down") {
				// ! When does Cudi hum? Intro, chorus, bridge, outro
				this.groupBySection();
				this.createBars();
				// this.defaultHeight();
				// this.stripByNormalizedPosition();
				// this.filterHums();
				// this.groupBySection();
			}
		},
		// TEXT WRAPPING
		wrapYLabel: function (text, width) {
			text.each(function () {
				var text = d3.select(this),
					words = text.text().split(/\s+/).reverse(),
					word,
					line = [],
					lineNumber = 0,
					lineHeight = 1, // ems
					x = text.attr("x"),
					dy = parseFloat(text.attr("dy")),
					tspan = text
						.text(null)
						.append("tspan")
						.attr("x", x)
						.attr("y", 0)
						.attr("dy", dy + "em");
				while ((word = words.pop())) {
					line.push(word);
					tspan.text(line.join(" "));
					if (tspan.node().getComputedTextLength() > width) {
						line.pop();
						tspan.text(line.join(" "));
						line = [word];
						tspan = text
							.append("tspan")
							.attr("x", x)
							.attr("y", 0)
							.attr("dy", ++lineNumber * lineHeight + dy + "em")
							.text(word);
					}
				}
			});
		},
		// wrapXLabel: function (text, width) {
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
		// },
		handleFilter: function () {
			this.onlyHumsToggled
				? this.stripByNormalizedPosition()
				: this.filterHums();
		},
		// DEFAULTS:
		defaultHeight: function () {
			const { lines } = this;
			lines
				.transition("defaultHeight")
				.duration(1000)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr(
					"y2",
					(d) => this.yScale(d.song_name) - this.computedHeightBuffer
				);
		},
		defaultColor: function () {
			const { lines } = this;
			lines
				.transition("defaultColor")
				.duration(1000)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr(
					"y2",
					(d) => this.yScale(d.song_name) - this.computedHeightBuffer
				);
		},
		defaultOpacity: function () {
			const { lines } = this;
			lines.transition("defaultOpacity").duration(1000).attr("opacity", 1);
		},
		filterHums: function () {
			const { lines } = this;

			this.xScale = d3.scaleLinear().domain([0, 1]).range([0, this.width]);

			lines
				.attr("opacity", 1)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.filter((d) => d.category == "Regular")
				.transition("filterHums")
				.duration(1000)
				.attr("x1", this.xScale(1.1))
				.attr("x2", this.xScale(1.1));

			this.onlyHumsToggled = true;
		},
		highlightSong: function (song) {
			const { lines } = this;

			lines
				.attr("opacity", (d) => (d.song_name == song ? 1 : 0.3))
				.transition("highlightSong")
				.duration(1000)
				.attr("y1", (d) =>
					d.song_name == song
						? this.yScale(d.song_name) + this.computedHeightBuffer * 3
						: this.yScale(d.song_name) + this.computedHeightBuffer
				)
				.attr("y2", (d) =>
					d.song_name == song
						? this.yScale(d.song_name) - this.computedHeightBuffer * 3
						: this.yScale(d.song_name) - this.computedHeightBuffer
				);
		},
		transitionStrips: function () {
			const { lines, svg, data } = this;

			this.xScale = d3.scaleLinear().domain([0, 1]).range([0, this.width]);

			lines
				.attr("opacity", 1)
				.attr("x1", 0)
				.attr("x2", 0)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.attr("stroke", (d) => this.colorScale(d.category))
				.transition("transitionStrips")
				.duration(1000)
				.attr("x1", (d) => this.xScale(d.normalized_position))
				.attr("x2", (d) => this.xScale(d.normalized_position));
		},
		stripByNormalizedPosition: function () {
			const { lines, svg, data, height } = this;

			this.xScale = d3.scaleLinear().domain([0, 1]).range([0, this.width]);

			lines
				.attr("opacity", 1)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.transition("stripByNormalizedPosition")
				.duration(1000)
				.attr("x1", (d) => this.xScale(d.normalized_position))
				.attr("x2", (d) => this.xScale(d.normalized_position))
				.attr("stroke", (d) => this.colorScale(d.category));
			this.onlyHumsToggled = false;

			// X axis
			d3.select(".x.axis.stripplot").remove();

			let xAxisLabels = ["Beginning of song", "End of song"];
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(
					d3
						.axisBottom(this.xScale)
						.ticks(1)
						.tickFormat((d, i) => xAxisLabels[i])
						.tickSizeOuter(0)
				)
				.attr("class", "x axis stripplot text-on-bounds ");
		},
		stripByPosition: function () {
			const { lines, svg, data, width, height } = this;

			this.xScale = d3
				.scaleLinear()
				.domain([0, d3.max(data, (d) => d.position)])
				.range([0, this.width]);

			lines
				.attr("opacity", 1)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.transition("stripByPosition")
				.duration(1000)
				.attr("x1", (d) => this.xScale(d.position))
				.attr("x2", (d) => this.xScale(d.position))
				.attr("stroke", (d) => this.colorScale(d.category));
			this.onlyHumsToggled = false;

			d3.select(".x.axis.stripplot").remove();
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.xScale).ticks(0).tickSizeOuter(0))
				.attr("class", "x axis stripplot");
		},
		groupBySection: function () {
			const { lines, svg, data, width, height } = this;

			this.xScale = d3
				.scalePoint()
				.domain(this.sections_data.map((d) => d.section_name))
				.range([0, this.width])
				.padding(0.5);

			// Width divided by 8 bars, plus padding between three of them
			const barWidth = width / 8;
			const barWidthPadding = barWidth * 0.3;
			const xAxisBuffer = barWidth - barWidthPadding;

			lines
				// .attr("opacity", 1)
				// .attr("y1", (d, i) => this.yScale(d.song_name))
				// .attr("y2", (d, i) => this.yScale(d.song_name))
				.transition("groupBySection")
				.duration(1500)
				.attr(
					"x1",
					(d) =>
						d.category == "Hum"
							? this.xScale(d.section_name) - xAxisBuffer // - 50
							: this.xScale(d.section_name) - 0 // - 50
				)
				.attr(
					"x2",
					(d) =>
						d.category == "Hum"
							? this.xScale(d.section_name) - 0 // + 50
							: this.xScale(d.section_name) + xAxisBuffer // + 50
				)
				.transition("dropLines")
				.duration(1000)
				.attr("y1", height)
				.attr("y2", height)
				.attr("opacity", 0);

			lines.exit().remove();
		},
		createBars: function () {
			// Grouped bar chart: https://observablehq.com/@d3/grouped-bar-chart
			const { svg, height, width, colorScale, sections_data } = this;
			const data = sections_data;
			// Define grouping column (section) and keys (category)
			const groupKey = "section_name"; // sections_data.columns[0]; // Should be 'section_name'
			const keys = ["Hum", "Regular"]; // sections_data.columns.slice(1); // Should be ['Hum','Regular']

			// Define scales
			// Main x axis
			const x0 = d3
				.scaleBand()
				.domain(data.map((d) => d[groupKey]))
				.rangeRound([0, width])
				.padding(0.1);

			// Subgroups
			const x1 = d3.scaleBand().domain(keys).rangeRound([0, x0.bandwidth()]);
			// .padding(0.05);

			const y = d3
				.scaleLinear()
				.domain([0, d3.max(data, (d) => d3.max(keys, (key) => d[key]))])
				.nice()
				.rangeRound([height, 0]);

			d3.select(".x.axis.stripplot").remove();
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.xScale).ticks(0).tickSizeOuter(0))
				.attr("class", "x axis stripplot");

			d3.select(".y.axis.stripplot").remove();
			svg
				.append("g")
				.call(d3.axisLeft(y).ticks(null, "~s").ticks(4).tickSize(-width))
				.call((g) => g.select(".domain").remove())
				.call((g) =>
					g
						.select(".tick:last-of-type text")
						.clone()
						.attr("x", 3)
						.attr("text-anchor", "start")
						.attr("font-weight", "bold")
						.text(data.y)
				)
				.attr("class", "y axis stripplot");

			const bars = svg
				.append("g")
				.selectAll("g")
				.data(data)
				.join("g")
				.attr("transform", (d) => `translate(${x0(d[groupKey])},0)`)
				.selectAll("rect")
				.data((d) => keys.map((key) => ({ key, value: d[key] })))
				.join("rect");

			bars
				.attr("y", y(0))
				.attr("height", 0)
				.attr("x", (d) => x1(d.key))
				.attr("width", x1.bandwidth())
				.attr("fill", (d) => colorScale(d.key))
				.attr("opacity", 1)
				.transition("createBars")
				.delay(2500)
				.duration(1000)
				.attr("height", (d) => y(0) - y(d.value))
				.attr("y", (d) => y(d.value));
		},
		undoBars: function () {
			const { svg, width, margin } = this;
			d3.select(".y.axis.stripplot").remove();
			d3.selectAll("rect").remove().exit();

			// Y axis
			svg
				.append("g")
				.call(d3.axisLeft(this.yScale).tickSizeOuter(0).tickSize(-width))
				.attr("class", "y axis stripplot")
				.selectAll(".tick text")
				.call(this.wrapYLabel, margin.left * 0.9);
		},
		setupChart: function () {
			const { data, computedStrokeWidth } = this;
			const computedStrokeWidthReg = computedStrokeWidth.toString();
			const computedStrokeWidthBig = (computedStrokeWidth * 5).toString();

			// Margin conventions
			const margin = { top: 30, right: 10, bottom: 30, left: 100 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			this.margin = margin;
			this.width = width;
			this.height = height;

			// Appends the svg to the chart-container div
			const svg = d3
				.select("#stripplot")
				.append("svg")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			const tip = d3
				.select("#stripplot")
				.append("div")
				.attr("class", "tooltip")
				.style("opacity", 0);

			//Creates the xScale
			this.xScale = d3.scaleLinear().range([0, width]);

			//Creates the yScale
			this.yScale = d3
				.scalePoint()
				.domain(data.map((d) => d.song_name))
				.range([height, 0])
				.padding(0.5); // Padding around bounds

			this.colorScale = d3
				.scaleOrdinal()
				.domain(data.map((d) => d.category))
				.range(["#4C6DBC", "#ce496a"]);

			// Y axis
			svg
				.append("g")
				.call(d3.axisLeft(this.yScale).tickSizeOuter(0).tickSize(-width))
				.attr("class", "y axis stripplot")
				.selectAll(".tick text")
				.call(this.wrapYLabel, margin.left * 0.9);

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.xScale).ticks(0).tickSizeOuter(0))
				.attr("class", "x axis stripplot");

			//Binds data to strips
			const lines = svg
				.append("g")
				.selectAll("line")
				.data(data)
				.enter()
				.append("line")
				.attr("class", "stripplot-lines")
				.style("stroke-width", computedStrokeWidthReg);

			lines
				.on("mouseover", function (event, d) {
					// d3.select(this)
					// 	.transition("mouseover")
					// 	.duration(100)
					// 	.style("stroke-width", computedStrokeWidthBig)

					tip.transition(300).style("opacity", 1);
					tip.html(
						d.category == "Hum"
							? "<span class='has-text-pink'>" + d.bigram + "</span>"
							: d.bigram
					);

					const right = event.clientX > window.innerWidth / 2;
					const offset = right ? tip.node().offsetWidth + 15 : -15;
					tip
						.style("left", event.clientX - offset + "px")
						.style("top", event.clientY + "px");
				})
				.on("mouseout", function (d) {
					// d3.select(this)
					// 	.transition("mouseout")
					// 	.duration(100)
					// 	.style("stroke-width", computedStrokeWidthReg)

					tip.transition(300).style("opacity", 0);
				});

			this.lines = lines;
			this.svg = svg;
		},
		watchResize: function () {
			d3.select("#stripplot > svg").remove();
			this.setupChart();

			// * My hacky workaround:
			// On step enter (above), we saved the response which included index, direction, and element
			// Now, we rereference those and pass them back into stepEnterHandler (to mimic the most recent method)

			// But because the methods only transition certain elements (fill, x position, etc.)
			// we first run the initializing method, transition bars

			// * NOTE: Only the first view (index 0) has 'non-normalized' x-axis positioning.
			// Every other time, run stripByNormalizedPosition()
			if (this.response.index == 0) {
				this.stripByPosition();
			} else {
				this.stripByNormalizedPosition();
			}
			this.stepEnterHandler(this.response);
		},
	},
	watch: {
		containerWidth: function () {
			this.watchResize();
		},
	},
	// created() {
	// 	window.addEventListener("resize", debounce(this.watchResize, 500));
	// },
	// destroyed() {
	// 	window.removeEventListener("resize", debounce(this.watchResize, 500));
	// },
};
</script>

<style src="vue-scrollama/dist/vue-scrollama.css"></style>
<style lang="scss">
.y.axis.stripplot {
	// Axis line
	path {
		stroke: transparent;
	}
	// Axis gridlines
	g.tick line {
		stroke: $white-alt;
		opacity: 0.25;
	}
	// Axis labels
	text {
		font-size: 12px;
		font-weight: 200;
	}

	@media screen and (max-width: 768px) {
		font-size: 8px;
	}
}

.x.axis.stripplot {
	// Axis text
	text {
		font-weight: 300;
		font-size: 12px;
		text-transform: uppercase;
		letter-spacing: 1px;

		@media screen and (max-width: 768px) {
			font-size: 8px;
		}
	}

	// Axis ticks
	g.tick line {
		stroke: transparent;
	}
}

#stripplot div.tooltip {
	position: absolute;
	text-align: left;
	font-family: $font-alt;
	font-size: 14px;
	pointer-events: none;
	color: $white-alt;
	z-index: 100;
	background: #242424;
	padding: 5px;
	border-radius: 3px;
	// border: 1px solid $white-alt

	@media screen and(max-width:480px) {
		display: none;
	}
}

.x.axis.stripplot.text-on-bounds g.tick:nth-child(2) text {
	text-anchor: start !important;
}
.x.axis.stripplot.text-on-bounds g.tick:nth-child(3) text {
	text-anchor: end !important;
}

.has-text-pink {
	color: $cudi-pink;
}
</style>
