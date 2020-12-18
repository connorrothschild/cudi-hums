<template>
	<section>
		<div class="has-background-black">
			<section class="hero is-fullheight">
				<div class="hero-body">
					<div class="container">
						<div
							class="is-flex responsive-flex-direction place-items-center is-justify-content-space-evenly"
						>
							<div class="max-width-20">
								<!-- Intro image -->
								<!-- <figure class="image is-3by4"> -->
								<img class="shake" src="../assets/cudi.png" />
							</div>
							<div class="is-flex is-flex-direction-column max-width-70">
								<!-- Intro title -->
								<h2 class="big-title heading has-text-weight-bold">
									How Much Does Kid Cudi Hum?
								</h2>
								<!-- Intro subtitle -->
								<!-- <p class="big-subtitle has-text-weight-light has-text-danger">
									An in-depth exploration of a question you never knew needed
									asking.
								</p> -->
								<p
									class="big-subtitle has-text-weight-light has-text-danger mt-2"
								>
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
	</section>
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
