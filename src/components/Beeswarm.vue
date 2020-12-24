<template>
	<Scrollama @step-enter="stepEnterHandler" :debug="false" :offset="0.5">
		<!-- SCROLLAMA GRAPHIC -->
		<div slot="graphic" class="graphic" id="beeswarm">
			<p
				class="mt-2 is-size-2 is-size-4-mobile has-text-weight-light has-text-centered"
			>
				Hums by track
			</p>
		</div>
		<!-- SCROLLAMA STEPS -->
		<div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
			<p class="content">
				By breaking down each album into its constituent songs, we can start to
				see which tracks contribute the most to Cudi's hum-heavy albums.
			</p>
		</div>
		<div class="step" :class="{ active: 1 == currStep }" data-step-no="1">
			<p>
				For example, we can take a look at Kid Cudi's most recent album,
				<span class="highlight-text">Man on the Moon III: The Chosen</span>.
			</p>
		</div>
		<div class="step" :class="{ active: 2 == currStep }" data-step-no="2">
			<p class="content">
				This is the album's introduction, titled
				<span class="highlight-text">Beautiful Trip</span>. In this track, a
				remarkable 43% of the lyrics are hums.
			</p>
			<iframe
				src="https://open.spotify.com/embed/track/4IIuCotvqijraSdnVLaFnM"
				width="300"
				height="80"
				frameborder="0"
				allowtransparency="true"
				allow="encrypted-media"
			></iframe>
			<p class="content after-embed">
				But this intro track lasts a mere 37 seconds, and around half of that
				duration is spent humming. Clearly, this is a poor example for our
				purposes.
			</p>
		</div>
		<div class="step" :class="{ active: 3 == currStep }" data-step-no="3">
			<p class="content">
				<span class="highlight-text">Sept. 16</span> is a better example of
				Cudi's famous hums.
			</p>
			<iframe
				src="https://open.spotify.com/embed/track/3Uw2se3aQU1UFrpRBvBnB4"
				width="300"
				height="80"
				frameborder="0"
				allowtransparency="true"
				allow="encrypted-media"
			></iframe>
			<p class="content after-embed">
				Near the middle of this song, Kid Cudi alternates between various
				ad-libs such as 'na-na-na', 'hmmm', and 'ooh.' <br /><span
					class="has-text-weight-semibold"
					>In total, the track includes 84 hums (out of 324 total words).</span
				>
			</p>
		</div>

		<div class="step" :class="{ active: 4 == currStep }" data-step-no="4">
			<p class="content">
				Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatibus
				quia deserunt fuga ipsam doloribus laboriosam fugit voluptatem incidunt
				ducimus sequi, corrupti eius ullam repellat temporibus id quibusdam
				maxime molestias libero?
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
		// this.transitionCircles();
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
			alreadyTriggered: false,
			defaultCircleRadius: 7.5,
			response: {},
		};
	},
	methods: {
		stepEnterHandler({ element, index, direction }) {
			this.response = { element, index, direction };
			this.currStep = index;
			// THE VERY FIRST TIME (AND ONLY GOING DOWN), TRANSITION
			if (index == 0 && direction == "down" && this.alreadyTriggered == false) {
				this.transitionCircles();
			}
			if (index == 0 && direction == "down" && this.alreadyTriggered == true) {
				this.regularCircles();
			}
			if (index == 0 && direction == "up") {
				this.regularCircles();
			}
			if (index == 1) {
				this.highlightAlbum("Man on the Moon III: The Chosen");
			}
			if (index == 2) {
				this.highlightSong("Beautiful Trip");
			}
			if (index == 3) {
				this.highlightSong("Sept. 16");
			}
		},
		percentFormat: d3.format(".1%"),
		transitionCircles: function () {
			const { circles, xScale, yScale, colorScale, jitterWidth } = this;

			circles
				.attr("cx", 0)
				.attr("cy", (d) =>
					Math.random() >= 0.5 // Randomly put half of dots above line, half below
						? yScale(d.album_name) - Math.random() * jitterWidth
						: yScale(d.album_name) + Math.random() * jitterWidth
				)
				.attr("r", this.defaultCircleRadius)
				.attr("stroke", "white")
				.attr("opacity", 0.8)
				.attr("fill", (d) => colorScale(d.album_name))
				.transition("transitionCircles")
				.duration(1000)
				.attr("cx", (d) => xScale(d.percent_hums));

			this.alreadyTriggered = true;
		},
		regularCircles: function () {
			const { circles, xScale, yScale, colorScale, jitterWidth } = this;

			circles
				.transition("regularCircles")
				.duration(1000)
				.attr("cx", (d) => xScale(d.percent_hums))
				.attr("cy", (d) =>
					Math.random() >= 0.5 // Randomly put half of dots above line, half below
						? yScale(d.album_name) - Math.random() * jitterWidth
						: yScale(d.album_name) + Math.random() * jitterWidth
				)
				.attr("r", this.defaultCircleRadius)
				.attr("stroke", "white")
				.attr("opacity", 0.8)
				.attr("fill", (d) => colorScale(d.album_name));
		},
		highlightAlbum: function (album) {
			const { circles } = this;
			circles
				.transition("highlightAlbum")
				.duration(1000)
				.attr("fill", (d) => (d.album_name == album ? "#ce496a" : "#4C6DBC"))
				.attr("stroke", (d) => (d.album_name == album ? "white" : "black"))
				.attr("opacity", (d) => (d.album_name == album ? 1 : 0.3))
				.attr("r", this.defaultCircleRadius);
		},
		highlightSong: function (song) {
			const { circles } = this;
			circles
				.transition("highlightSong")
				.duration(2000)
				.attr("stroke", (d) => (d.song_name == song ? "white" : "black"))
				.attr("opacity", (d) => (d.song_name == song ? 1 : 0.3))
				.attr("fill", (d) => (d.song_name == song ? "#ce496a" : "#4C6DBC"))
				.attr("r", (d) =>
					d.song_name == song
						? this.defaultCircleRadius * 2
						: this.defaultCircleRadius
				);
		},
		setupChart: function () {
			const margin = { top: 30, right: 30, bottom: 30, left: 60 };
			const width = this.containerWidth - margin.left - margin.right;
			const height = this.containerHeight - margin.top - margin.bottom;

			this.width = width;
			this.height = height;

			// Select whichever is smaller; the chart width / data.length (so each square fits perfectly)
			// Or the left margin (rect size should never be greater than margin.left lest overflow)
			const albumCoverSize = Math.min(
				height / this.major_albums.length,
				margin.left
			);
			this.jitterWidth = 0; // *Optional: remove jitter by making this 0

			// Append the svg object to the div
			const svg = d3
				.select("#beeswarm")
				.append("svg")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");

			let data = this.data.filter((d) =>
				this.major_albums.includes(d.album_name)
			);

			this.xScale = d3.scaleLinear().domain([-0.005, 0.5]).range([0, width]);

			this.yScale = d3
				.scalePoint()
				.domain(
					this.album_data
						.sort((a, b) => d3.ascending(a.percent_hums, b.percent_hums))
						.map((d) => d.album_name)
				)
				.range([height, 0])
				.padding(0.5); // Padding around bounds

			this.colorScale = d3
				.scaleOrdinal()
				.domain(data.map((d) => d.album_name))
				.range(["#cecece"]);

			// X axis
			svg
				.append("g")
				.attr("transform", "translate(0," + height + ")")
				.call(
					d3
						.axisBottom(this.xScale)
						.tickFormat(d3.format(".0%"))
						.ticks(6)
						.tickSizeOuter(0)
				)
				.attr("class", "x axis beeswarm");

			// Y axis
			svg
				.append("g")
				.call(d3.axisLeft(this.yScale).tickSize(-width).tickSizeOuter(0))
				.attr("class", "y axis beeswarm");

			svg.select(".y.axis").selectAll("text").remove();

			svg
				.select(".y.axis")
				.selectAll(".tick")
				.data([
					...this.album_data.sort((a, b) =>
						d3.ascending(a.percent_hums, b.percent_hums)
					),
				])
				.append("svg:image")
				.attr("xlink:href", function (d) {
					return d.album_cover_art_url;
				})
				.attr("width", albumCoverSize)
				.attr("height", albumCoverSize)
				.attr("x", -albumCoverSize)
				.attr("y", -albumCoverSize / 2);

			// Tooltip
			const tip = d3
				.select("#beeswarm")
				.append("div")
				.attr("class", "tooltip")
				.style("opacity", 0);

			// Add dots
			const circles = svg
				.append("g")
				.selectAll("circle")
				.data(data)
				.enter()
				.append("circle")
				.attr("class", "beeswarm-circles");

			const self = this;
			circles
				.on("mouseover", function (event, d) {
					tip.transition(300).style("opacity", 1);
					tip.html(`<p class='heading'> ${d.song_name} </p>
							  <p> ${self.percentFormat(d.percent_hums)} hums</p>`);

					const right = event.clientX > window.innerWidth / 2;
					const offset = right ? tip.node().offsetWidth + 15 : -15;

					tip
						.style("left", event.clientX - offset + "px")
						.style("top", event.clientY + "px");
				})
				.on("mouseout", function (d) {
					tip.transition(300).style("opacity", 0);
				});

			this.circles = circles;
		},
		watchResize: function () {
			d3.select("#beeswarm > svg").remove();
			this.setupChart();

			// * My hacky workaround:
			// On step enter (above), we saved the response which included index, direction, and element
			// Now, we rereference those and pass them back into stepEnterHandler (to mimic the most recent method)

			// But because the methods only transition certain elements (fill, x position, etc.)
			// we first run the initializing method, transition bars
			this.transitionCircles();
			this.stepEnterHandler(this.response);
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
<style lang="scss">
.x.axis.beeswarm {
	// Axis ticks
	g.tick line {
		stroke: transparent;
	}
	// Axis text
	text {
		font-size: 12px;
		font-weight: 200;
	}
}

.y.axis.beeswarm {
	// Axis gridlines
	g.tick line {
		stroke: $white-alt;
		stroke-width: 10px;
		opacity: 0.2;
	}
}

.axis.beeswarm {
	// Axis lines
	path {
		stroke: $white-alt;
		opacity: 0.35;
	}
}

.after-embed {
	margin-top: 1rem;
}

#beeswarm div.tooltip {
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