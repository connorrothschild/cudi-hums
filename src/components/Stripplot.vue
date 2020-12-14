<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<div slot="graphic" class="graphic">
			<div id="stripplot"></div>
		</div>
		<div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
			<p class="content">
				But where are Cudi's hums located? <br />Are they mostly concentrated at
				the beginnings and ends of each song, or somewhere in the middle?
			</p>
			<p class="content">
				In this view, every line represents a lyric.
				<span class="highlight-text blue">Blue lines</span>
				<!-- <svg
					width="10"
					height="15"
					viewBox="0 0 10 15"
					xmlns="http://www.w3.org/2000/svg"
				>
					<line
						x1="5"
						y1="0"
						x2="5"
						y2="15"
						style="stroke: #4c6dbc; stroke-width: 3; stroke-linecap: round"
					/>
				</svg>
				represent "regular" lyrics, such as normal words, while pink lines
				<svg
					width="10"
					height="15"
					viewBox="0 0 10 15"
					xmlns="http://www.w3.org/2000/svg"
				>
					<line
						x1="5"
						y1="0"
						x2="5"
						y2="15"
						style="stroke: #d96481; stroke-width: 3; stroke-linecap: round"
					/>
				</svg> -->
				represent "regular" lyrics, such as normal words, while
				<span class="highlight-text">pink lines</span> represent "hums" and
				other sounds, such as as 'oooh' and 'nahh.'
			</p>
		</div>
		<div
			class="step"
			:class="{ active: 1 == currStep }"
			style="pointer-events: auto"
			data-step-no="1"
		>
			<p class="content">
				By focusing only on hum-type sounds, we can isolate the noises that Cudi
				makes most frequently, and where in each song he makes them.
			</p>

			<button
				class="button"
				@click="handleFilter()"
				:class="{ toggled: onlyHumsToggled }"
			>
				Only show hums
			</button>
		</div>
		<div class="step" :class="{ active: 2 == currStep }" data-step-no="2">
			<p class="content">
				<b>Some focus here.</b> focus on one range of oohs ahhs and nahs. Maybe
				in 'She Knows This,' highlight the pattern of 'mm mm mm' and how the
				rhythm of those mms define the song's structure.
			</p>
		</div>
		<div class="step" :class="{ active: 3 == currStep }" data-step-no="3">
			<p class="content">
				Finally, group by song category: Intro, Chorus, Bridge, Outro, etc.
				<i>some cool transition goes here for sure.</i>
			</p>
		</div>
		<div class="step" :class="{ active: 4 == currStep }" data-step-no="4">
			<p class="content">Conclude this section.</p>
		</div>
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
			xScale: null,
			yScale: null,
			colorScale: null,
			svg: null,
			lines: null,
			onlyHumsToggled: false,
			alreadyTriggered: false,
		};
	},
	computed: {
		strokeWidth: function () {
			// container width divided by the length of the longest song (most words aka most lines)
			// console.log(d3.rollup(
			// 	this.data,
			// 	(v) => v.length,
			// 	(d) => d.song_name
			// ))
			return this.containerWidth / 550;
		},
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.currStep = index;
			if (index == 0 && direction == "down" && this.alreadyTriggered == false) {
				this.transitionStrip();
				this.alreadyTriggered = true;
			}
			if (index == 0 && direction == "up") {
				this.regularStrip();
			}
			if (index == 1) {
				// * Highlight hums only
				this.filterHums();
			}
			if (index == 2) {
				// ! Highlight a few hums...
				this.regularStrip();
			}
			if (index == 3) {
				// ! When does Cudi hum? Intro, chorus, bridge, outro
				this.regularStrip();
			}
			if (index == 4) {
				// ! Sick transition of all of the lyrics into
				this.regularStrip();
			}
		},
		handleFilter: function () {
			this.onlyHumsToggled ? this.regularStrip() : this.filterHums();
		},
		filterHums: function () {
			const { lines } = this;
			lines
				.filter((d) => d.category == "Regular")
				.transition()
				.duration(1000)
				.attr("x1", this.xScale(1.01))
				.attr("x2", this.xScale(1.01));
			this.onlyHumsToggled = true;
		},
		transitionStrip: function () {
			const { lines, svg, data } = this;
			lines
				.attr("x1", this.xScale(1.01))
				.attr("x2", this.xScale(1.01))
				.attr("y1", (d) => this.yScale(d.song_name) + this.height / 100)
				.attr("y2", (d) => this.yScale(d.song_name) - this.height / 100)
				.attr("stroke", (d) => this.colorScale(d.category))
				.transition()
				.duration(1000)
				.attr("x1", (d) => this.xScale(d.normalized_position))
				.attr("x2", (d) => this.xScale(d.normalized_position));
		},
		regularStrip: function () {
			const { lines, svg, data } = this;
			lines
				.attr("y1", (d) => this.yScale(d.song_name) + this.height / 100)
				.attr("y2", (d) => this.yScale(d.song_name) - this.height / 100)
				.transition()
				.duration(1000)
				.attr("x1", (d) => this.xScale(d.normalized_position))
				.attr("x2", (d) => this.xScale(d.normalized_position))
				.attr("stroke", (d) => this.colorScale(d.category));
			this.onlyHumsToggled = false;
		},
		setupChart: function () {
			const { data, strokeWidth } = this;
			const strokeWidthReg = strokeWidth.toString();
			console.log(strokeWidthReg);
			const strokeWidthBig = (strokeWidth * 5).toString();

			// Margin conventions
			const margin = { top: 0, right: 0, bottom: 30, left: 100 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			this.width = width;
			this.height = height;

			// Appends the svg to the chart-container div
			var svg = d3
				.select("#stripplot")
				.append("svg")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			var tip = d3
				.select("#stripplot")
				.append("div")
				.attr("class", "tooltip")
				.style("opacity", 0);

			//Creates the xScale
			this.xScale = d3.scaleLinear().domain([0, 1]).range([0, width]);

			//Creates the yScale
			this.yScale = d3
				.scalePoint()
				.domain(data.map((d) => d.song_name))
				.range([height, 0])
				.padding(0.5); // Padding around bounds

			this.colorScale = d3
				.scaleOrdinal()
				.domain(data.map((d) => d.category))
				.range(["#4C6DBC", "#D96481"]);

			// X axis
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
				.attr("class", "x axis no-line stripplot");

			const wrap = function (text, width) {
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
			};

			// Y axis
			svg
				.append("g")
				.call(d3.axisLeft(this.yScale).tickSizeOuter(0).tickSize(-width))
				.attr("class", "y axis stripplot")
				.selectAll(".tick text")
				.call(wrap, margin.left * 0.9);

			//Binds data to strips
			const lines = svg
				.selectAll("line.percent")
				.data(data)
				.enter()
				.append("line")
				.attr("class", "percentline");

			lines
				.attr("stroke", (d) => this.colorScale(d.category))
				.attr("fill", "white")
				.attr("stroke-linecap", "round")
				.style("stroke-width", strokeWidthReg);

			lines
				.on("mouseover", function (event, d) {
					d3.select(this)
						.transition()
						.duration(100)
						.style("stroke-width", strokeWidthBig)
						.style("opacity", "1");

					tip.transition(300).style("opacity", 1);
					tip.html(
						d.category == "Hum"
							? "<span class='highlight-text'>" + d.bigram + "</span>"
							: d.bigram
					);

					const right = event.clientX > window.innerWidth / 2;
					const offset = right ? tip.node().offsetWidth + 15 : -15;
					tip
						.style("left", event.clientX - offset + "px")
						.style("top", event.clientY + "px");
				})
				.on("mouseout", function (d) {
					d3.select(this)
						.transition()
						.duration(100)
						.style("stroke-width", strokeWidthReg);

					tip.transition(300).style("opacity", 0);
				});

			this.lines = lines;
			this.svg = svg;
		},
		watchResize: function () {
			d3.select("#stripplot > svg").remove();
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
<style>
.y.axis text {
	font-size: 12px;
}

.bolded {
	font-weight: 700;
}

div.tooltip {
	position: absolute;
	text-align: left;
	font-family: sans-serif;
	font-size: 14px;
	pointer-events: none;
	color: black;
	z-index: 1000;
	background: whitesmoke;
	padding: 5px;
	border-radius: 3px;
	border: 1px solid black;
}

.button.toggled {
	background-color: #d96481;
	color: white;
}

.x.axis.stripplot g.tick:nth-child(2) text {
	text-anchor: start !important;
}
.x.axis.stripplot g.tick:nth-child(3) text {
	text-anchor: end !important;
}
</style>
