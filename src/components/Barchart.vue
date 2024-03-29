<template>
  <Scrollama
    @step-enter="stepEnterHandler"
    :debug="false"
    :offset="responsiveOffset"
  >
    <!-- SCROLLAMA GRAPHIC -->
    <div slot="graphic" class="graphic" id="barchart">
      <p
        class="mt-2 is-size-2 is-size-3-mobile has-text-weight-light has-text-centered"
      >
        Hums by album
      </p>
    </div>
    <!-- SCROLLAMA STEPS -->
    <div class="step" :class="{ active: 0 == currStep }" data-step-no="0">
      <p class="content">The first way to analyze Cudi hums is by album.</p>
      <p class="content">
        Kid Cudi has an extensive discography, having recorded seven studio
        albums and one mixtape since 2008.
      </p>
    </div>
    <div class="step" :class="{ active: 1 == currStep }" data-step-no="1">
      <p class="content">
        Kid Cudi recently came out with his 7th studio album,
        <span class="highlight-text">Man on the Moon III: The Chosen</span>.
      </p>
      <p class="content">
        Not only is this album one of Cudi's best, it also has the greatest
        proportion of hums.
      </p>
    </div>
    <div class="step" :class="{ active: 2 == currStep }" data-step-no="2">
      <p class="content">
        When we organize these albums by their release year, it becomes evident
        that Kid Cudi has been humming more and more as his discography has
        developed.
      </p>
      <p class="content">
        With the exceptions of his
        <span class="highlight-text blue">middle three albums</span>,
        Cudi's albums have become progressively more hum-centric over time.
      </p>
    </div>
    <div class="step" :class="{ active: 3 == currStep }" data-step-no="3">
      <p class="content">
        Although revealing, an album-by-album breakdown doesn't fully answer the
        question of how often Kid Cudi hums. Sure, we know that Kid Cudi has
        been humming more in recent years, and that Man on the Moon III was
        composed of 8% hums.
      </p>
      <p class="content">
        But there's much more complexity to our question, which can be
        understood in part by an analysis of Kid Cudi's
        <span class="has-text-weight-semibold">songs.</span>
      </p>
    </div>
  </Scrollama>
</template>

<script>
import * as d3 from "d3";
import "intersection-observer";
import Scrollama from "vue-scrollama";

export default {
  name: "Barchart",
  props: {
    data: Array,
    containerHeight: Number,
    containerWidth: Number,
    windowWidth: Number,
    responsiveOffset: Number,
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
  computed: {},
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
          "Indicud",
          "KiD CuDi presents SATELLITE FLIGHT: The journey to Mother Moon"
        );
      }
      if (index == 3) {
        this.sortBarsByYear();
        this.unhighlightBars();
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
        .attr("fill", 'url(#linear-gradient)')
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
      const labels = yearData.map((d) => d.percent_hums);

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
          .text((d, i) => this.percentFormat(labels[i]))
          .attr("x", (d) => yearScale(d.year) + yearScale.bandwidth() / 2)
          .attr("y", 0)
          .attr("dy", "-.5em")
          .attr('font-size', 12)
          .transition("textFallsFromTop")
          .duration(1000)
          .attr("y", (d) => yScale(d.percent_hums))
          .attr("fill", "white")
          .attr("stroke", "none");
      }
    },
    highlightBars: function (album1, album2, album3, album4) {
      const { bars } = this;

      bars
        .transition("highlightBars")
        .duration(1000)
        .attr("fill", function (d) {
          if (d.album_name == album1) {
            return "#ce496a";
          } else if (album2 && album3 && album4 && [album2, album3, album4].includes(d.album_name)) {
            return "#4C6DBC";
          } else {
            return "url(#linear-gradient)";
          }
        })
        .attr('opacity', function (d) {
          if (d.album_name == album1) {
            return 1;
          } else if (album2 && album3 && album4 && [album2, album3, album4].includes(d.album_name)) {
            return 1;
          } else {
            return 0.5;
          }
        });
    },
    unhighlightBars: function () {
      const { bars } = this;

      bars.transition("unhighlightBars").duration(1000)
        .attr("fill", "url(#linear-gradient)")
        .attr('opacity', 1);
    },
    setupChart: function () {
      const margin = { top: 30, right: 0, bottom: 100, left: 30 };
      const width = this.containerWidth - margin.left - margin.right;
      const height = this.containerHeight - margin.top - margin.bottom;

      let data = this.data.sort((a, b) =>
        d3.descending(a.percent_hums, b.percent_hums)
      );

      this.height = height;
      this.width = width;

      // Append the svg object to the div
      const svg = d3
        .select("#barchart")
        .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      const defs = svg.append("defs");
        // Linear gradient for bars
      defs.append("linearGradient")
        .attr("id", "linear-gradient")
        .attr("gradientUnits", "userSpaceOnUse")
        .attr("x1", 0)
        .attr("y1", 0)
        .attr("x2", 0)
        .attr("y2", height)

      defs.select("linearGradient")
        .append("stop")
        .attr("offset", "0%")
        .attr("stop-color", "#ce496a");

      defs.select("linearGradient")
        .append("stop")
        .attr("offset", "100%")
        .attr("stop-color", "#4C6DBC");

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
        .range(["url(#linear-gradient)"]); // #4C6DBC // d3.schemeSet3

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
        .attr("fill", 'url(#linear-gradient)')
        .attr('opacity', 1)
        .attr("class", "barchart-bars");

      const self = this;
      bars
        .on("mouseover", function (event, d) {
          tip.transition(300).style("opacity", 1);
          tip.html(`<p class='heading'> ${d.album_name} </p>
					  <p> ${self.percentFormat(d.percent_hums)} hums</p>`);

          const largeScreen = self.windowWidth > 968;
          const xPos = largeScreen
            ? event.clientX - width / 2 - margin.left
            : event.clientX;
          tip.style("left", xPos + "px").style("top", event.clientY + "px");
        })
        .on("mousemove", function (event, d) {
          const largeScreen = self.windowWidth > 968;
          const xPos = largeScreen
            ? event.clientX - width / 2 - margin.left
            : event.clientX;
          tip.style("left", xPos + "px").style("top", event.clientY + "px");
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
    containerHeight: function () {
      this.watchResize();
    },
  },
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
  text-anchor: start;
  font-family: $font-sans;
  font-size: 14px;
  pointer-events: none;
  color: $white-alt;
  background: #242424;
  padding: 5px 10px;
  border-radius: 3px;
  z-index: 100;
  width: auto;
  border: 1px solid grey;

  // @media screen and (max-width:480px) {
  // 	display: none;
  // }
}
</style>
