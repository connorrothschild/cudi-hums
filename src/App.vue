<template>
  <div id="app">
    <Header />
    <div v-if="hums.length > 0">
      <Scatterplot :data="hums"/>
    </div>
  </div>
</template>

<script>
import * as d3 from "d3";
import Scatterplot from './components/Scatterplot.vue'
import Header from './components/Header.vue'

export default {
  name: 'App',
  components: {
    Scatterplot,
    Header,
  },
  data() {
    return {
      hums: [],
    }
  },
  async mounted() {
    const hums = await d3.csv("./data/song_hums.csv");
    hums.forEach(d => {
      d.n_hums = +d.n_hums;
      d.n_regulars = +d.n_regulars;
      d.percent_hums = +d.percent_hums;
    });
    
    this.hums = hums;
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
</style>
