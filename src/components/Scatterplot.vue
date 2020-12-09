<template>
    <div id="scatterplot">
    </div>
</template>

<script>
import * as d3 from "d3";

export default {
  name: 'Scatterplot',
  props: {
    data: Array,
  },
  mounted() {
    const margin = {top: 10, right: 30, bottom: 30, left: 60};
    const width = 460 - margin.left - margin.right;
    const height = 400 - margin.top - margin.bottom;

    // Append the svg object to the div
    var svg = d3.select("#scatterplot")
      .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");

    let data = this.data;
    // data.sort((a,b) => d3.descending(a.percent_hums, b.percent_hums))
    console.log(data)
    const xScale = d3.scaleLinear().domain(d3.extent(data, d=>d.n_hums)).range([0, width])
    const yScale = d3.scaleLinear().domain(d3.extent(data, d=>d.n_regulars)).range([height, 0])

    // X axis
     svg.append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(xScale));
    // Y axis
      svg.append("g")
      .call(d3.axisLeft(yScale));

    // Add dots
    svg.append('g')
      .selectAll("dot")
      .data(data)
      .enter()
      .append("circle")
        .attr("cx", function (d) { return xScale(d.n_hums); } )
        .attr("cy", function (d) { return yScale(d.n_regulars); } )
        .attr("r", 1.5)
        .style("fill", "#69b3a2")
    }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
</style>
