<template>
	<div class="is-gradient">
		<section class="hero is-fullheight has-text-centered">
			<div class="hero-body">
				<div class="container">
					<div class="is-inline-flex place-items-center">
						<!-- Intro image -->
						<figure class="image is-inline-block is-96x132">
							<img class="is-inline-block shake" src="../assets/cudi.png" />
						</figure>
						<!-- Big intro title -->
						<!-- <h1 class="title has-text-weight-light ml-3 has-text-black">
							hmmmmmmmm
						</h1> -->
					</div>
					<!-- Intro subtitle -->
					<h2 class="heading is-size-1 has-text-weight-semibold has-text-white">
						How Much Does Kid Cudi Hum?
					</h2>
					<!-- Teaser for content below -->
					<p class="mt-6">First bit of intro text here...</p>
				</div>
			</div>
		</section>
		<div class="section">
			<!-- Intro prose, with dropcap on first letter -->
			<div class="container is-max-desktop">
				<p class="content">
					Kid Cudi dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
				<p class="content">
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
				<p class="content">
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
				<p class="content">
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	name: "Intro",
};
</script>

<style scoped lang="scss">
p:first-child:first-letter {
	float: left;
	font-family: Georgia;
	font-size: 55px;
	line-height: 40px;
	padding-top: 4px;
	padding-right: 8px;
	padding-left: 3px;
}

.is-gradient {
	background-image: linear-gradient(#4c6dbc, #f5f5f5);
}
</style>
