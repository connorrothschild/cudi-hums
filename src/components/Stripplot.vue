<template>
	<Scrollama
		@step-enter="stepEnterHandler"
		:debug="false"
		:offset="responsiveOffset"
	>
		<!-- SCROLLAMA GRAPHIC -->
		<div slot="graphic" class="graphic" id="stripplot">
			<p
				class="mt-2 is-size-2 is-size-3-mobile has-text-weight-light has-text-centered"
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
				In this view, every line
				<svg
					style="vertical-align: middle; display: inline-block"
					width="8"
					height="1em"
					viewBox="0 0 8 20"
					xmlns="http://www.w3.org/2000/svg"
				>
					<line
						x1="2"
						y1="16"
						x2="2"
						y2="2"
						stroke="#4c6dbc"
						stroke-width="3"
						stroke-linecap="round"
					/></svg
				>represents a lyric from
				<span class="has-text-weight-semibold">Man on the Moon III</span>.
				<span class="highlight-text blue">Blue lines</span>
				represent "regular" lyrics while
				<span class="highlight-text">pink lines</span> represent hums and
				similar sounds, such as as 'oooh' and 'nah.'
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
				In this way, Kid Cudi uses the hum like any other artist would use an
				instrument. He utilizes hums to harmonize, to sing, and to ad-lib; the
				hum's exact usage depends on the demands of the song.
			</p>
		</div>

		<div class="step" :class="{ active: 7 == currStep }" data-step-no="7">
			<p class="content">
				A final way to analyze the placement of Cudi hums is to look at their
				position within
				<span class="has-text-weight-semibold">song sections</span>.
				<br />Because songs differ in length, this method allows us to search
				for hums' locations in a standardized and consistent way.
			</p>
		</div>

		<div class="step" :class="{ active: 8 == currStep }" data-step-no="8">
			<p class="content">
				Here, the height of each bar corresponds to the count of
				<span class="highlight-text">hums</span> and
				<span class="highlight-text blue">regular lyrics</span> within each song
				section throughout Cudi's most recent album.
			</p>
			<p class="content">
				Notice how lyrics are much more common in Kid Cudi's
				<span class="has-text-weight-semibold">verses</span> and
				<span class="has-text-weight-semibold">choruses</span>.
			</p>
		</div>

		<div class="step" :class="{ active: 9 == currStep }" data-step-no="9">
			<p class="content">
				Rather than raw counts, which inflate lyrics in verses and choruses, we
				can look at
				<span class="has-text-weight-semibold">proportions</span>.
			</p>
			<p class="content">
				Here, the two bars in each section will sum up to 100%. This allows us
				to see how often Cudi hums in a section
				<em>relative to how much time he spends in that section.</em>
			</p>
		</div>

		<div class="step" :class="{ active: 10 == currStep }" data-step-no="10">
			<p class="content">
				This view makes it clear that Kid Cudi has a clear preference for
				humming at the beginnings and ends of each song.
			</p>
			<p class="content">
				In the outros on his most recent album,
				<span class="has-text-weight-semibold"
					>Cudi <span class="highlight-text">hummed</span> more often than he
					used <span class="highlight-text blue">regular words</span>.
				</span>
			</p>
		</div>
	</Scrollama>
</template>

<script>
import * as d3 from "d3";
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
		windowWidth: Number,
		responsiveOffset: Number,
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
			currentXLabels: [],
			yScale: null,
			colorScale: null,
			svg: null,
			lines: null,
			bars: null,
			barData: null,
			groupKey: null,
			keys: null,
			humColorScale: null,
			x0Bar: null,
			x1Bar: null,
			yBar: null,
			groupedSectionData: null,
			groupedXScale: null,
			groupedXAxisBuffer: null,
			unclicked: true,
			onlyHumsToggled: false,
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
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.response = { element, index, direction };
			this.currStep = index;

			// * Direction-agnostic handling of transitions
			// * Only trigger transition if elements don't yet have positions on chart (proxy: x1)
			if (index == 0) {
				// Remove bars if they exist bc of super quick scrolling
				this.undoBars();

				if (!d3.select(".stripplot-lines").node().hasAttribute("x1")) {
					this.transitionStrips();
					this.stripByPosition();
				} else {
					this.stripByPosition();
				}
			}

			if (index == 1) {
				this.undoBars();
				this.stripByPosition();
			}
			if (index == 2) {
				this.undoBars();

				// * Normalize
				this.stripByNormalizedPosition();
			}
			if (index == 3 && direction == "down") {
				this.undoBars();

				// * Highlight hums only
				this.stripByNormalizedPosition();
				this.filterHums();
			}
			if (index == 3 && direction == "up") {
				this.undoBars();

				this.defaultHeight();
				this.defaultOpacity();
			}
			if (index == 4) {
				this.undoBars();

				// Highlight a few hums...
				this.filterHums();
				this.highlightSong("The Void");
			}
			if (index == 5) {
				this.undoBars();

				// Highlight a few hums...
				if (direction == "up") {
					this.filterHums();
				}
				this.highlightSong("She Knows This");
			}
			if (index == 6) {
				this.undoBars();

				this.stripByNormalizedPosition();
				this.defaultHeight();
			}
			if (index == 7) {
				// When does Cudi hum? Intro, chorus, bridge, outro
				if (direction == "up") {
					this.undoBarsAndGroup();
				}
				if (direction == "down") {
					this.groupBySection();
				}
			}
			if (index == 8) {
				if (this.windowWidth > 600) {
					this.dropLines();
				} else {
					// Handle mobile differently
					this.lines
						.transition("mobileTransitionLines")
						.attr("opacity", 0)
						.end()
						.then(() => {
							this.rawCountBars();
						});
				}
			}
			if (index == 9) {
				this.proportionBars();
			}
			if (index == 10) {
				this.highlightBars("Outro");
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
		// EDITS
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

			let xAxisLabels = ["Beginning of song", "End of song"];
			const xAxis = d3
				.axisBottom(this.xScale)
				.tickValues([0, 1])
				.tickFormat((d, i) => xAxisLabels[i])
				.tickSizeOuter(0);

			d3.select(".x.axis.stripplot").call(xAxis);
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

			let xAxisLabels = ["0:00", "5:25"];

			const xAxis = d3
				.axisBottom(this.xScale)
				.tickValues([0, d3.max(data, (d) => d.position)])
				.tickFormat((d, i) => xAxisLabels[i])
				.tickSizeOuter(0);

			d3.select(".x.axis.stripplot").call(xAxis);
		},
		groupBySection: function () {
			const {
				lines,
				svg,
				data,
				width,
				height,
				yScale,
				x0Bar,
				groupedSectionData,
				groupedXScale,
				groupedXAxisBuffer,
			} = this;

			// X Axis
			d3.select(".x.axis.stripplot").remove();
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(d3.axisBottom(x0Bar).ticks(0).tickSizeOuter(0))
				.attr("class", "x axis stripplot barchart");

			// Only run this if the lines exist
			// if (d3.select(".stripplot-lines").node().hasAttribute("x1")) {
			lines
				.transition("groupBySection")
				.duration(1000)
				.attr("x1", (d) =>
					groupedSectionData.includes(d.section_name)
						? d.category == "Hum"
							? groupedXScale(d.section_name)
							: groupedXScale(d.section_name) + groupedXAxisBuffer
						: width * 1.1
				)
				.attr("x2", (d) =>
					groupedSectionData.includes(d.section_name)
						? d.category == "Hum"
							? groupedXScale(d.section_name) - groupedXAxisBuffer
							: groupedXScale(d.section_name)
						: width * 1.1
				)
				.attr("y1", (d) => yScale(d.song_name))
				.attr("y2", (d) => yScale(d.song_name))
				.attr("opacity", 1);
			// }
		},
		dropLines: function () {
			const { lines, svg, height, x0Bar, yScale } = this;

			lines
				.transition("dropLines")
				.duration(1000)
				.attr("y1", height)
				.attr("y2", height)
				.attr("opacity", 0)
				.end()
				.then(() => {
					this.rawCountBars();
				})
				.catch((e) => {
					console.log(e);
				});
		},
		rawCountBars: function () {
			// Grouped bar chart: https://observablehq.com/@d3/grouped-bar-chart
			const { svg, width } = this;

			// Y Axis
			const yAxisBar = d3.axisLeft(this.yBar).ticks(4).tickSize(-width);

			svg
				.select(".y.axis.stripplot")
				.transition("y-axis-in")
				.duration(1000)
				.call(yAxisBar)
				.end()
				.then(() => {
					this.bars
						.data((d) => this.keys.map((key) => ({ key, value: d[key] })))
						.join("rect")
						.transition("rawCountBars")
						.duration(1000)
						.attr("height", (d) => this.yBar(0) - this.yBar(d.value))
						.attr("y", (d) => this.yBar(d.value))
						.attr("opacity", 1);
				})
				.catch((e) => {
					console.log(e);
				});
		},
		proportionBars: function (type) {
			// Grouped bar chart: https://observablehq.com/@d3/grouped-bar-chart
			const { svg, height, width, barData, groupKey } = this;

			const keys = ["Hum_pct", "Regular_pct"];

			// Define scales
			const humColorScale = d3
				.scaleOrdinal()
				.domain(this.keys)
				.range(["#CE496A", "#4C6DBC"]);

			// Subgroups
			const x1Bar = d3
				.scaleBand()
				.domain(this.keys)
				.rangeRound([0, this.x0Bar.bandwidth()]);

			// Y scale
			const yBar = d3
				.scaleLinear()
				.domain([0, d3.max(barData, (d) => d3.max(keys, (key) => d[key]))])
				.nice()
				.rangeRound([height, 0]);

			// Y Axis
			const yAxisBar = d3.axisLeft(yBar).ticks(3, "%").tickSize(-width);

			svg
				.select(".y.axis.stripplot")
				.transition("y-axis-in")
				.duration(1000)
				.call(yAxisBar)
				.end()
				.then(() => {
					this.bars
						.data((d) => keys.map((key) => ({ key, value: d[key] })))
						.join("rect")
						.transition("proportionBars")
						.duration(1000)
						.attr("height", (d) => yBar(0) - yBar(d.value))
						.attr("y", (d) => yBar(d.value))
						.attr("opacity", 1);
				})
				.catch((e) => {
					console.log(e);
				});
		},
		highlightBars: function (section) {
			// if (this.keys != ["Hum_pct", "Regular_pct"]) {
			// 	this.proportionBars();
			// }
			// The way that I processed data means I can't access d => d.section_name from the data
			// Here, I manually define the sections and reverse lookup the index from domain
			const sections = ["Intro", "Verse", "Chorus", "Outro"];
			const sectionIndex = sections.indexOf(section);

			// There are two bars per index,
			const section1 = sectionIndex * 2;
			const section2 = section1 + 1;

			const val1 = this.bars.data()[section1].value;
			const val2 = this.bars.data()[section2].value;

			this.bars
				.transition("highlightBars")
				.duration(1000)
				.attr("opacity", function (d) {
					if ((d.value == val1) | (d.value == val2)) {
						return 1;
					} else {
						return 0.5;
					}
				});
		},
		undoBars: function () {
			d3.select(".x.axis.stripplot").classed("barchart", false);
			d3.selectAll(".stripplot-bars")
				.transition("undoBars")
				.attr("y", this.yBar(0))
				.attr("height", 0)
				.end()
				.then(() => {
					d3.select(".y.axis.stripplot")
						.transition("y-axis-in")
						.duration(1000)
						.call(
							d3.axisLeft(this.yScale).tickSizeOuter(0).tickSize(-this.width)
						);
				});
		},
		undoBarsAndGroup: function () {
			const { svg, width, margin, lines, data } = this;

			d3.select(".y.axis.stripplot")
				.transition("y-axis-in")
				.duration(1000)
				.call(d3.axisLeft(this.yScale).tickSizeOuter(0).tickSize(-width))
				.end()
				.then(() => {
					d3.selectAll(".stripplot-bars")
						.transition("undoBarsAndGroup")
						.attr("y", this.yBar(0))
						.attr("height", 0)
						// .attr("opacity", 0)
						.end()
						.then(() => {
							this.groupBySection();
						})
						.catch((e) => {
							console.log(e);
						});
				})
				.catch((e) => {
					console.log(e);
				});
		},
		setupChart: function () {
			const { data, computedStrokeWidth } = this;
			const computedStrokeWidthReg = computedStrokeWidth.toString();
			const computedStrokeWidthBig = (computedStrokeWidth * 5).toString();

			// Margin conventions
			const margin = { top: 30, right: 10, bottom: 30, left: 120 };
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
				.call(this.wrapYLabel, margin.left * 0.95);

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
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
				.attr("y1", (d) => this.yScale(d.song_name) + this.computedHeightBuffer)
				.attr("y2", (d) => this.yScale(d.song_name) - this.computedHeightBuffer)
				.attr("x1", 0)
				.attr("x2", 0);

			const tip = d3
				.select("#stripplot")
				.append("div")
				.attr("class", "tooltip")
				.style("opacity", 0);

			// Only enable tooltip and touch interactions on non-mobile devices
			if (this.windowWidth > 480) {
				const self = this;
				lines
					.on("mouseover", function (event, d) {
						d3.select(this)
							.style("stroke-width", computedStrokeWidthBig)
							.attr(
								"y1",
								(d) => self.yScale(d.song_name) + self.computedHeightBuffer * 3
							)
							.attr(
								"y2",
								(d) => self.yScale(d.song_name) - self.computedHeightBuffer * 3
							);

						tip.transition(100).style("opacity", 1);
						tip.html(
							d.category == "Hum"
								? "<span class='has-text-pink'>" + d.bigram + "</span>"
								: d.bigram
						);

						const largeScreen = self.windowWidth > 968;
						const xPos = largeScreen
							? event.clientX - width / 2 - margin.left - 25
							: event.clientX;
						tip.style("left", xPos + "px").style("top", event.clientY + "px");
					})
					.on("mousemove", function (event, d) {
						const largeScreen = self.windowWidth > 968;
						const xPos = largeScreen
							? event.clientX - width / 2 - margin.left - 25
							: event.clientX;
						tip.style("left", xPos + "px").style("top", event.clientY + "px");
					})

					.on("mouseout", function (d) {
						d3.select(this)
							.style("stroke-width", computedStrokeWidthReg)
							.attr(
								"y1",
								(d) => self.yScale(d.song_name) + self.computedHeightBuffer
							)
							.attr(
								"y2",
								(d) => self.yScale(d.song_name) - self.computedHeightBuffer
							);

						tip.transition(100).style("opacity", 0);
					});
			}

			this.lines = lines;
			this.svg = svg;

			// SECTION GROUPING INFO
			this.groupedSectionData = this.sections_data
				.filter(
					(d) =>
						(d.section_name != "Pre-Chorus") &
						(d.section_name != "Post-Chorus") &
						(d.section_name != "Bridge") &
						(d.section_name != "Interlude")
				)
				.map((d) => d.section_name);

			this.groupedXScale = d3
				.scalePoint()
				.domain(this.groupedSectionData)
				.range([0, width])
				.padding(0.5);

			// Width divided by 8 bars, plus padding between three of them
			const groupedBarWidth = width / 8;
			const groupedBarWidthPadding = groupedBarWidth * 0.3;
			this.groupedXAxisBuffer = groupedBarWidth - groupedBarWidthPadding;

			// BARCHART
			this.barData = this.sections_data.filter(
				(d) =>
					(d.section_name != "Pre-Chorus") &
					(d.section_name != "Post-Chorus") &
					(d.section_name != "Bridge") &
					(d.section_name != "Interlude")
			);
			// Define grouping column (section) and keys (category)
			this.groupKey = "section_name";
			this.keys = ["Hum", "Regular"];

			// Define scales
			this.humColorScale = d3
				.scaleOrdinal()
				.domain(this.keys)
				.range(["#CE496A", "#4C6DBC"]);

			// Main x axis
			this.x0Bar = d3
				.scaleBand()
				.domain(this.barData.map((d) => d[this.groupKey]))
				.rangeRound([0, width])
				.padding(0.1);

			// Subgroups
			this.x1Bar = d3
				.scaleBand()
				.domain(this.keys)
				.rangeRound([0, this.x0Bar.bandwidth()]);
			// Y scale
			this.yBar = d3
				.scaleLinear()
				.domain([
					0,
					d3.max(this.barData, (d) => d3.max(this.keys, (key) => d[key])),
				])
				.nice()
				.rangeRound([height, 0]);

			const bars = svg
				.append("g")
				.selectAll("g")
				.data(this.barData)
				.join("g")
				.attr(
					"transform",
					(d) => `translate(${this.x0Bar(d[this.groupKey])},0)`
				)
				.selectAll("rect")
				.data((d) => this.keys.map((key) => ({ key, value: d[key] })))
				.join("rect")
				.attr("y", this.yBar(0))
				.attr("x", (d) => this.x1Bar(d.key))
				.attr("width", this.x1Bar.bandwidth())
				.attr("fill", (d) => this.humColorScale(d.key))
				.attr("opacity", 1)
				.attr("height", 0)
				.attr("class", "stripplot-bars");

			this.bars = bars;
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
			} else if (this.response.index > 6) {
				this.rawCountBars();
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
		containerHeight: function () {
			this.watchResize();
		},
	},
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
		text {
			font-size: 8px;
		}
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
			font-size: 9px;
		}

		@media screen and (max-width: 420px) {
			font-size: 7px;
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
	font-family: $font-sans;
	font-size: 14px;
	pointer-events: none;
	color: $white-alt;
	z-index: 100;
	background: #242424;
	padding: 5px;
	border-radius: 3px;
	// border: 1px solid $white-alt
}

.x.axis.stripplot:not(.barchart) g.tick:nth-child(2) text {
	text-anchor: start !important;
}
.x.axis.stripplot:not(.barchart) g.tick:nth-child(3) text {
	text-anchor: end !important;
}

.has-text-pink {
	color: $cudi-pink;
}

.stripplot-lines {
	stroke-linecap: round;
}
</style>
