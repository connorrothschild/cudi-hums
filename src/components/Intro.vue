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
						><span class="highlight-text-static">Surfin'</span>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							xmlns:xlink="http://www.w3.org/1999/xlink"
							width="16"
							height="16"
							viewBox="0 0 16 16"
							version="1.1"
						>
							<g>
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
									d="M 39.385986 13.769531 L 22.229004 28.601074 L 6.005859 28.601074 L 6.005859 47.698975 L 21.990967 47.698975 L 39.385986 62.750244 Z M 39.385986 13.769531 "
									transform="matrix(0.213333,0,0,0.213333,0,0)"
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
									d="M 47.991943 27.593994 C 52.258301 34.094238 52.258301 42.498779 47.991943 48.999023 M 55.096436 20.507812 C 62.896729 31.091309 62.896729 45.52002 55.096436 56.103516 M 61.59668 14.007568 C 73.00415 28.198242 73.00415 48.413086 61.59668 62.60376 "
									transform="matrix(0.213333,0,0,0.213333,0,0)"
								/>
							</g></svg></span
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
					<span class="highlight-text-static"
						>how much does Kid Cudi really hum?</span
					>
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
	methods: {
		playAudio(url) {
			const audio = new Audio(url);
			audio.play();
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

.container.better-container {
	max-width: 700px !important;
}

.audio-clicker {
	cursor: pointer;
}
</style>
