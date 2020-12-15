<template>
	<div class="is-gradient-reverse">
		<section class="hero is-fullheight has-text-centered">
			<div class="hero-body">
				<div class="container">
					<!-- Image -->
					<figure class="image is-inline-block is-96x96">
						<img class="is-inline-block" src="../assets/cudi.png" />
					</figure>
					<!-- Big outro text -->
					<h1 class="title has-text-weight-light mt-5 has-text-black">
						Awesome outro content goes here.
					</h1>
					<!-- Outro subtitle -->
					<h2 class="heading is-size-3 has-text-weight-semibold">
						Check out my outro!
					</h2>
				</div>
			</div>
		</section>
	</div>
</template>

<script>
export default {
	name: "Outro",
};
</script>

<style scoped lang="scss">
.is-gradient-reverse {
	background-image: linear-gradient(#f5f5f5, #4c6dbc);
}
</style>
