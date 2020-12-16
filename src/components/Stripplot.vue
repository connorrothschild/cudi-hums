<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<!-- SCROLLAMA GRAPHIC -->
		<div slot="graphic" class="graphic" id="stripplot"></div>
		<!-- SCROLLAMA STEPS -->
		<div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
			<p class="content">
				But where are Cudi's hums located? <br />Are they mostly concentrated at
				the beginnings and ends of each song, or somewhere in the middle?
			</p>
			<p class="content">
				In this view, every line represents a lyric from
				<span class="has-text-weight-semibold">Man on the Moon III</span>.
				<span class="highlight-text blue">Blue lines</span>
				represent "regular" lyrics, such as normal words, while
				<span class="highlight-text">pink lines</span> represent "hums" and
				other sounds, such as as 'oooh' and 'nahh.'
			</p>
			<p class="content">
				The songs are different durations (<span
					class="has-text-weight-semibold"
					>The Void</span
				>
				tops off the album at 5 minutes and 25 seconds), which is why the
				lengths of each bar are different.
			</p>
		</div>
		<div class="step" :class="{ active: 1 == currStep }" data-step-no="1">
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
		<div class="step" :class="{ active: 2 == currStep }" data-step-no="2">
			<p class="content">
				By focusing only on hum-type sounds, we can isolate the noises that Cudi
				makes most frequently, and at what points in each song he makes them.
			</p>
			<div class="is-flex is-flex-direction-column">
				<button
					class="button"
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
		<div class="step" :class="{ active: 3 == currStep }" data-step-no="3">
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
		<div class="step" :class="{ active: 4 == currStep }" data-step-no="4">
			<p class="content">
				While in other songs like
				<span class="highlight-text">She Knows This</span>, Cudi is much more
				rhythmic in his hums.
			</p>

			<iframe
				src="https://open.spotify.com/embed/track/1xzUQMiCoY5pdego0pHMeV"
				width="300"
				height="80"
				frameborder="0"
				allowtransparency="true"
				allow="encrypted-media"
			></iframe>
			<p class="content after-embed">
				In that song, the hums
				<em>define the structure of the song</em>, with the chorus being marked
				by Cudi's alternations between the phrase "She Knows This" and hums.
			</p>
		</div>
		<div class="step" :class="{ active: 5 == currStep }" data-step-no="5">
			<p class="content">
				Finally, group by song category: Intro, Chorus, Bridge, Outro, etc.
				<i>some cool transition goes here for sure.</i>
			</p>
		</div>
		<div class="step" :class="{ active: 6 == currStep }" data-step-no="6">
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
			positionScale: null,
			normalizedPositionScale: null,
			yScale: null,
			colorScale: null,
			svg: null,
			lines: null,
			unclicked: true,
			onlyHumsToggled: false,
			alreadyTriggered: false,
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
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.currStep = index;
			if (index == 0 && direction == "down" && this.alreadyTriggered == false) {
				this.transitionStrip(this.positionScale);
				this.stripByPosition();

				this.alreadyTriggered = true;
			}
			if (index == 0 && direction == "down" && this.alreadyTriggered == true) {
				// this.transitionStrip(this.positionScale);
				this.stripByPosition();

				// this.alreadyTriggered = true;
			}
			if (index == 0 && direction == "up") {
				this.stripByPosition();
			}
			if (index == 1) {
				// * Highlight hums only
				this.stripByNormalizedPosition();
			}
			if (index == 2 && direction == "down") {
				// * Highlight hums only
				this.filterHums();
			}
			if (index == 2 && direction == "up") {
				this.defaultHeight();
				this.defaultOpacity();
			}
			if (index == 3) {
				// ! Highlight a few hums...
				this.filterHums();
				this.highlightSong("The Void");
			}
			if (index == 4) {
				this.filterHums();
				this.highlightSong("She Knows This");
			}
			if (index == 5) {
				// ! When does Cudi hum? Intro, chorus, bridge, outro
				this.defaultHeight();
				this.stripByNormalizedPosition();
				// this.filterHums();
				this.groupBySection();
			}
		},
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
			lines
				.attr("opacity", 1)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.filter((d) => d.category == "Regular")
				.transition("filterHums")
				.duration(1000)
				.attr("x1", this.normalizedPositionScale(1.05))
				.attr("x2", this.normalizedPositionScale(1.05));

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
		transitionStrip: function (xAxisScale) {
			const { lines, svg, data } = this;

			lines
				.attr("opacity", 1)
				.attr("x1", xAxisScale(1.05))
				.attr("x2", xAxisScale(1.05))
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.attr("stroke", (d) => this.colorScale(d.category))
				.transition("transitionStrip")
				.duration(1000)
				.attr("x1", (d) => xAxisScale(d.normalized_position))
				.attr("x2", (d) => xAxisScale(d.normalized_position));
		},
		stripByNormalizedPosition: function () {
			const { lines, svg, data, height } = this;

			lines
				.attr("opacity", 1)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.transition("stripByNormalizedPosition")
				.duration(1000)
				.attr("x1", (d) => this.normalizedPositionScale(d.normalized_position))
				.attr("x2", (d) => this.normalizedPositionScale(d.normalized_position))
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
						.axisBottom(this.normalizedPositionScale)
						.ticks(1)
						.tickFormat((d, i) => xAxisLabels[i])
						.tickSizeOuter(0)
				)
				.attr("class", "x axis no-line stripplot");
		},
		stripByPosition: function () {
			const { lines, svg, data, width, height } = this;

			lines
				.attr("opacity", 1)
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.transition("stripByPosition")
				.duration(1000)
				.attr("x1", (d) => this.positionScale(d.position))
				.attr("x2", (d) => this.positionScale(d.position))
				.attr("stroke", (d) => this.colorScale(d.category));
			this.onlyHumsToggled = false;

			d3.select(".x.axis.stripplot").remove();
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(this.positionScale).ticks(0).tickSizeOuter(0))
				.attr("class", "x axis stripplot");
		},
		setupChart: function () {
			const { data, computedStrokeWidth } = this;
			const computedStrokeWidthReg = computedStrokeWidth.toString();
			console.log(computedStrokeWidthReg);
			const computedStrokeWidthBig = (computedStrokeWidth * 5).toString();

			// Margin conventions
			const margin = { top: 30, right: 10, bottom: 30, left: 100 };
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

			//Creates the normalizedPositionScale
			this.normalizedPositionScale = d3
				.scaleLinear()
				.domain([0, 1])
				.range([0, width]);

			this.positionScale = d3
				.scaleLinear()
				.domain([0, d3.max(data, (d) => d.position)])
				.range([0, width]);

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
				.style("stroke-width", computedStrokeWidthReg);

			lines
				.on("mouseover", function (event, d) {
					d3.select(this)
						.transition("mouseover")
						.duration(100)
						.style("stroke-width", computedStrokeWidthBig);

					tip.transition(300).style("opacity", 1);
					tip.html(
						d.category == "Hum"
							? "<span class='highlight-text-static'>" + d.bigram + "</span>"
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
						.transition("mouseout")
						.duration(100)
						.style("stroke-width", computedStrokeWidthReg);

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

<style lang="scss">
.y.axis.stripplot {
	path {
		stroke: transparent;
	}
	g.tick line {
		stroke: grey;
		opacity: 0.25;
	}
	text {
		font-size: 12px;
		font-weight: 200;
	}
}

.x.axis.stripplot text {
	font-weight: 300;
	font-size: 12px;
	text-transform: uppercase;

	@media screen and (max-width: 768px) {
		font-size: 8px;
	}
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
	font-weight: 500;

	&:hover {
		color: white;
	}
}

.x.axis.stripplot g.tick:nth-child(2) text {
	text-anchor: start !important;
}
.x.axis.stripplot g.tick:nth-child(3) text {
	text-anchor: end !important;
}
</style>
