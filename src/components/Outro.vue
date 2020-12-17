<template>
	<div class="is-gradient-reverse">
		<section class="hero is-fullheight has-text-centered">
			<div class="hero-body">
				<div class="container">
					<!-- Image -->
					<div class="is-inline-flex place-items-center">
						<!-- Intro image -->
						<figure class="image is-inline-block is-96x132">
							<img class="is-inline-block shake" src="../assets/cudi.png" />
						</figure>
						<!-- Big intro title -->
						<h1 class="title has-text-weight-light ml-3 has-text-white">
							Hmmmmm
						</h1>
					</div>
					<!-- Big outro text -->
					<!-- <h1 class="title has-text-weight-light mt-5 has-text-black">
						Awesome outro content goes here.
					</h1> -->
					<!-- Outro subtitle -->
					<div class="mt-6 max-width-600-container has-text-left">
						<h2 class="mb-3 is-size-6 has-text-weight-semibold">
							Notes and methodology
						</h2>
						<p class="content has-text-weight-light">
							Lorem ipsum, dolor sit amet consectetur adipisicing elit.
							Similique nobis debitis dolor quidem eligendi, dignissimos iste!
							Quae consequatur iure incidunt exercitationem quidem? Repellendus
							officia quaerat nisi, officiis iste atque! Suscipit?
						</p>
					</div>
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

<style lang="scss">
.is-gradient-reverse {
	background-image: linear-gradient($background, $cudi-pink);
}

.max-width-600-container {
	max-width: 600px;
	margin: 0 auto;
}

.shake {
	animation: shake 1.5s infinite;
	&:hover {
		animation: none;
	}
}

@keyframes shake {
	0% {
		transform: rotate(0deg);
	}
	80% {
		transform: rotate(0deg);
	}
	85% {
		transform: rotate(5deg);
	}
	95% {
		transform: rotate(-5deg);
	}
	100% {
		transform: rotate(0deg);
	}
}

.place-items-center {
	place-items: center;
}

.is-96x132 {
	width: 92px;
	height: 136px;
}
</style>
