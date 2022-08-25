<template>
  <div class="has-background-black">
    <section class="hero is-fullheight">
      <div class="hero-body">
        <div class="container">
          <div
            class="is-flex responsive-flex-direction place-items-center is-justify-content-center"
          >
            <h2
              class="big-title heading has-text-weight-light responsive-padding"
            >
              Loading Hums...
            </h2>
            <div style="width: 200px; padding: 12px">
              <img class="spin" src="../assets/cudi.png" />
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: "LoadingScreen",
};
</script>

<style lang="scss" scoped>
.spin {
  animation-name: spin;
  animation-duration: 4000ms;
  animation-iteration-count: infinite;
  animation-timing-function: linear;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.responsive-padding {
  padding-right: 3rem !important;

  @media screen and (max-width: 768px) {
    padding-right: 0;
    padding-bottom: 1rem !important;
  }
}
</style>
