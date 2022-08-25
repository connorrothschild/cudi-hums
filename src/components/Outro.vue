<template>
  <section>
    <div class="section">
      <!-- Intro prose, with dropcap on first letter -->
      <div class="container better-container">
        <p class="content has-dropcap">
          So, how much does Kid Cudi hum? Good question. The above shows that
          the answer to that question depends on how you ask it. In some songs,
          nearly half of Cudi's lyrics are hums or hum-like sounds. But most
          often, those hums are concentrated in the intros and outros of songs,
          not in their verses.
        </p>
        <p class="content">
          If one thing's clear, it's that Kid Cudi does hum a lot. Of the 226
          songs attributed to Kid Cudi on Genius, only 53 contained zero hums.
          The song that included the greatest number of Cudi hums was
          <AudioPlayer
            src="https://p.scdn.co/mp3-preview/168cc24ec737c08536d33d53215d511756d646dd?cid=774b29d4f13844c495f206cafdad9c86"
            song="The Rage"
          />, which featured 129 hums. The average Kid Cudi song had 11.5
          hums—leading to an average of 3.6% of total lyrics.
        </p>
        <p class="content">
          You've heard of Scott Ramon Seguro Mescudi—also known as Kid Cudi.
          You've heard his hums. And now you know how much he
          <em>actually</em> hums.
        </p>
        <hr
          style="
            height: 1px;
            border-width: 0;
            color: #cecece;
            width: 30%;
            margin: 1.5rem auto;
          "
        />
      </div>
    </div>
  </section>
</template>

<script>
import AudioPlayer from "@/components/AudioPlayer.vue";

export default {
  name: "Outro",
  components: { AudioPlayer },
  computed: {},
  methods: {},
};
</script>

<style lang="scss"></style>
