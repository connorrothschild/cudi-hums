<template>
	<section>
		<div class="has-background-black">
			<section class="hero is-fullheight">
				<div class="hero-body">
					<div class="container">
						<!-- Flex container direction responsive to screen size -->
						<div
							class="is-flex responsive-flex-direction place-items-center is-justify-content-space-evenly"
						>
							<!-- CUDI HEAD -->
							<div class="max-width-20">
								<img class="shake" src="../assets/cudi.png" />
							</div>
							<div class="is-flex is-flex-direction-column max-width-70">
								<!-- Title -->
								<h2 class="big-title heading has-text-weight-bold">
									How Much Does Kid Cudi Hum?
								</h2>
								<p
									class="big-subtitle has-text-weight-light has-text-danger mt-2"
								>
									<!-- Subtitle -->
									<span class="highlight-text-static mobile-toggle px-2 py-1"
										>An in-depth exploration of a question you never knew needed
										asking.</span
									>
								</p>
							</div>
						</div>
					</div>
				</div>
			</section>
		</div>
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
					Kid Cudi's 'claim to fame,' or his most defining musical feature, is
					his hum. As one illustration of this, a loop of Cudi humming for 10
					minutes has garnered over 2 million views.
				</p>
				<div class="has-text-centered mb-4 mt-2">
					<iframe
						:width="properWidth"
						height="315"
						src="https://www.youtube.com/embed/X08tO_jxmyk?fs=0&disablekb=1&modestbranding=1"
						frameborder="0"
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
						allowfullscreen
					></iframe>
				</div>
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
	</section>
</template>

<script>
export default {
	name: "Intro",
	props: { width: Number },
	computed: {
		properWidth() {
			return Math.min(500, this.width) - 50;
		},
	},
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

.big-title {
	font-size: 5vmax;
	line-height: 1.125;
	text-align: left;
	color: $white-alt;

	@media screen and (max-width: 768px) {
		font-size: 3rem;
		text-align: center;
	}
}

.big-subtitle {
	font-size: 1.7vw;
	text-align: left;
	color: $white-alt;

	@media screen and (max-width: 768px) {
		text-align: center;
		font-size: 1rem;
	}
}

.max-width-20 {
	max-width: 20%;
	@media screen and (max-width: 768px) {
		max-width: 30%;
	}
}

.max-width-70 {
	flex-basis: 70%;
}

.responsive-flex-direction {
	flex-direction: row;

	@media screen and (max-width: 768px) {
		flex-direction: column;
	}
}
</style>
