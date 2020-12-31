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
							<h2 class="mb-3 is-size-6 has-text-weight-semibold">
								Methodology
							</h2>
							<p class="content">
								Lyric data came from the
								<a
									href="https://docs.genius.com/"
									target="_blank"
									rel="noopener"
									>Genius API</a
								>. To calculate the proportion of hums per song, I flagged all
								lyrics from Genius that were 'hum-like' in nature. (An exact
								list of qualifying lyrics can be found
								<a
									href="https://github.com/connorrothschild/cudi-hums/blob/master/process/hums_list.R"
									target="_blank"
									rel="noopener"
									>here</a
								>.) I manually verified my list of hums with a random selection
								of songs. This was not scientific; I simply listened to Kid
								Cudi's music, flagged hum-like sounds, and found their
								corresponding lyrics on Genius.
							</p>
							<h2 class="mb-3 is-size-6 has-text-weight-semibold">
								Limitations
							</h2>
							<p class="content">
								In certain cases, my method may lead to overcounts (if Kid Cudi
								actually says 'oh' rather than hums in a way that a transcriber
								records as 'oh'). The only solution to this would be a more
								selective list of 'hum-like' sounds (which would then undercount
								hums), or a manual coding of hums, which would be
								time-intensive. There may also be instances where I
								<em>miss</em> hums, in particular when Kid Cudi uses them to
								accompany the melody of his song. In these instances, hums are
								not recorded on Genius and therefore omitted by my methodology.
							</p>
							<h2 class="mb-3 is-size-6 has-text-weight-semibold">
								Tech & Code
							</h2>
							<p class="content">
								Data retrieval and pre-processing was done in R; code is
								available
								<a
									href="https://github.com/connorrothschild/cudi-hums/tree/master/process"
									target="_blank"
									rel="noopener"
									>here</a
								>. The story and visualizations were composed using Vue and
								D3.js. Scrollytelling was made possible thanks to
								<a
									href="https://github.com/vgshenoy/vue-scrollama"
									target="_blank"
									rel="noopener"
									>vue-scrollama</a
								>, a library built on top of Russell Goldenberg's
								<a
									href="https://github.com/russellgoldenberg/scrollama"
									target="_blank"
									rel="noopener"
									>Scrollama</a
								>.
							</p>
							<p class="content">
								The code for this project is available on
								<a
									href="https://github.com/connorrothschild/cudi-hums"
									target="_blank"
									rel="noopener"
									>GitHub</a
								>. You can find me on Twitter
								<a
									href="https://twitter.com/CL_Rothschild"
									target="_blank"
									rel="noopener"
									>@CL_Rothschild</a
								>, or email
								<a href="mailto:me@connorrothschild.com"
									>me@connorrothschild.com</a
								>.
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
	name: "Footer",
};
</script>

<style lang="scss">
.is-gradient-reverse {
	background-image: linear-gradient($background, #0a0a0a);
}

.max-width-600-container {
	max-width: 600px;
	margin: 0 auto;
}

.is-96x132 {
	width: 92px;
	height: 136px;
}

// .methodology-section {
// 	a {
// 		color: white !important;
// 		background-color: transparent;
// 		padding: 0;
// 		text-decoration: underline;
// 	}
// }
</style>
