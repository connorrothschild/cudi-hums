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
						<h2 class="mb-3 is-size-5 has-text-weight-semibold">
							Notes and methodology
						</h2>
						<div class="has-text-weight-light methodology-section">
							<p class="content">Lyric data came from the Genius API.</p>
							<p class="content">
								To calculate the proportion of hums per song, I flagged all
								lyrics from Genius that were 'hum-like' in nature. (An exact
								list of qualifying lyrics can be found
								<a
									href="https://github.com/connorrothschild/cudi-hums/blob/master/process/hums_list.R"
									target="_blank"
									rel="noopener"
									>here</a
								>.) In certain cases, this may lead to overcounts (if Kid Cudi
								actually says 'oh' rather than hums in a way that sounds like
								'oh').
							</p>
							<p class="content">
								I manually verified my list of hums with a random selection of
								songs. This was not scientific; I simply listened to music,
								flagged hum-like sounds, and found their corresponding lyrics on
								Genius.
							</p>
							<p class="content">
								Data retrieval and pre-processing was done in R; code is
								available
								<a
									href="https://github.com/connorrothschild/cudi-hums/tree/master/process"
									target="_blank"
									rel="noopener"
									>here</a
								>. FINISH THIS: The story and visualizations were composed using
								Vue and D3.js. Scrollytelling capabilities were thanks to
								vue-scrollama, scrollama, etc.
							</p>
						</div>
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

.methodology-section {
	a {
		color: white !important;
		text-decoration: underline;
	}
}
</style>
