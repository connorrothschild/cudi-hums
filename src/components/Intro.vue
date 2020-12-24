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
		<div class="has-dropcap section is-gradient">
			<!-- Intro prose, with dropcap on first letter -->
			<div class="container better-container">
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
					And Kid Cudi is aware of the impact his hums have had on his fans. In
					one song,
					<span
						class="audio-clicker"
						@click="
							playAudio(
								'https://p.scdn.co/mp3-preview/37adec4ab0523c1807ecd241624e168ab3501139?cid=774b29d4f13844c495f206cafdad9c86'
							)
						"
						><span class="highlight-text-static"
							>Surfin'
							<svg
								xmlns="http://www.w3.org/2000/svg"
								xmlns:xlink="http://www.w3.org/1999/xlink"
								width="12"
								height="12"
								viewBox="0 0 12 12"
								version="1.1"
							>
								<g id="surface1">
									<path
										style="
											fill-rule: nonzero;
											fill: white;
											fill-opacity: 1;
											stroke-width: 5;
											stroke-linecap: butt;
											stroke-linejoin: round;
											stroke: white;
											stroke-opacity: 1;
											stroke-miterlimit: 4;
										"
										d="M 39.379883 13.769531 L 22.241211 28.613281 L 6.005859 28.613281 L 6.005859 47.705078 L 21.99707 47.705078 L 39.379883 62.744141 Z M 39.379883 13.769531 "
										transform="matrix(0.16,0,0,0.16,0,0)"
									/>
									<path
										style="
											fill: none;
											stroke-width: 5;
											stroke-linecap: round;
											stroke-linejoin: miter;
											stroke: white;
											stroke-opacity: 1;
											stroke-miterlimit: 4;
										"
										d="M 47.998047 27.587891 C 52.270508 34.106445 52.270508 42.504883 47.998047 48.999023 M 55.102539 20.507812 C 62.890625 31.079102 62.890625 45.507812 55.102539 56.103516 M 61.59668 13.989258 C 72.998047 28.198242 72.998047 48.413086 61.59668 62.597656 "
										transform="matrix(0.16,0,0,0.16,0,0)"
									/>
								</g>
							</svg> </span></span
					>, he raps:
				</p>
				<div
					class="is-flex is-justify-content-center is-align-items-center m-5"
				>
					<div style="max-width: 50px">
						<!-- Intro image -->
						<!-- <figure class="image is-3by4"> -->
						<img src="../assets/cudi.png" />
					</div>

					<p class="speech-bubble">
						Make ‘em go dumb with them hums <br />Mhmm, mhmm, mhmm
					</p>
				</div>
				<p class="content">
					Despite the buzz, no one has analyzed the prevalence of hums in Kid
					Cudi's discography. Given his most recent album's release, it's the
					best time to ask:
				</p>
				<div class="has-text-centered">
					<p class="highlight-text-static heading is-size-4">
						How much does Kid Cudi really hum?
					</p>
				</div>
			</div>
		</div>
		<div class="section">
			<div class="container better-container">
				<p class="content">
					In the writing that follows, I go to painstaking lengths to explore
					this question at a variety of levels of granularity. First, I look at
					each of Kid Cudi's <span class="has-text-weight-bold">albums</span>,
					then at each of those albums'
					<span class="has-text-weight-bold">songs</span>, until I finally look
					at each individual song and analyze its
					<span class="has-text-weight-bold">lyrics</span>.
				</p>
				<p class="content">
					Technically, a hum is defined as any noise that Kid Cudi makes that is
					not a 'normal' word. For the purposes of this analysis, that could
					include noises ranging from 'hmmm' to 'meh' to 'nah.' I have to be
					inclusive of all of these hums (rather than just 'hum') because my
					data source,
					<a href="https://genius.com/" target="_blank" rel="noopener">Genius</a
					>, is comprised of
					<span class="has-text-weight-bold"
						>community members' contributions</span
					>, and different transcribers have different ways of recording hums.
				</p>
			</div>
		</div>
	</section>
</template>

<script>
export default {
	name: "Intro",
	props: { width: Number },
	data() {
		return { audio: null };
	},
	computed: {
		properWidth() {
			return Math.min(500, this.width) - 50;
		},
	},
	methods: {
		playAudio(url) {
			if (this.audio == null || this.audio.paused) {
				this.audio = new Audio(url);
				this.audio.play();
			} else {
				this.audio.pause();
			}
		},
	},
};
</script>

<style scoped lang="scss">
.is-gradient {
	background-image: linear-gradient(#0a0a0a, $background);
}

.has-dropcap p:first-child:first-letter {
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

.container.better-container {
	max-width: 700px !important;
}

.audio-clicker {
	cursor: pointer;
}
</style>
