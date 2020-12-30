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
		<div class="section is-gradient">
			<!-- Intro prose, with dropcap on first letter -->
			<div class="container better-container">
				<p class="content has-dropcap">
					Scott Ramon Seguro Mescudi is an international phenomenon. He's sold
					16 million million records in the US and won two Grammys. Although his
					primary genre is hip hop, he's also debuted an album at the top of
					Billboard's Rock charts. His most listened to song has amassed nearly
					<em>500 million</em> listens on Spotify.
				</p>
				<div class="content">
					Don't recognize the name Scott Ramon Seguro Mescudi? You might know
					him as
					<a
						href="https://en.wikipedia.org/wiki/Kid_Cudi"
						target="_blank"
						rel="noopener"
						>Kid Cudi.</a
					>
					And if you don't know Kid Cudi, you at least recognize his hums—his
					most defining musical feature. Perhaps you've heard his song
					<AudioPlayer
						src="https://p.scdn.co/mp3-preview/37adec4ab0523c1807ecd241624e168ab3501139?cid=774b29d4f13844c495f206cafdad9c86"
						song="Surfin'"
					/>
					where he raps:
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
				</div>
				<p class="content">
					Maybe you're one of the 2 million people who have watched this YouTube
					video of Cudi humming for 9 minutes:
				</p>
				<div class="has-text-centered mb-4 mt-2">
					<iframe
						:width="properWidth"
						height="450"
						src="https://www.youtube.com/embed/X08tO_jxmyk?fs=0&disablekb=1&modestbranding=1"
						frameborder="0"
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
						allowfullscreen
					></iframe>
				</div>
				<div>
					<p class="content">
						Or maybe you've read this Reddit post from an unsuspecting fan:
					</p>
					<div style="max-width: 600px; margin: 0 auto; background: whitesmoke">
						<blockquote class="reddit-card" data-card-created="1608866419">
							<a
								href="https://www.reddit.com/r/KidCudi/comments/946pml/how_does_kid_cudi_just_hum_on_a_song_and_its_the/"
								>HOW DOES KID CUDI JUST HUM ON A SONG AND ITS THE MOST FIRE
								THING IVE HEARD?!?</a
							>
							from <a href="http://www.reddit.com/r/KidCudi">r/KidCudi</a>
						</blockquote>
					</div>
				</div>
				<p class="content after-embed">
					Chances are, you've heard Kid Cudi hum, or at least heard that he hums
					<span class="has-text-weight-semibold">a lot</span>. But just how
					much? Despite the buzz, no one has analyzed the prevalence of hums in
					Kid Cudi's discography. Given his most recent album's release, it's
					the best time to ask:
					<span class="has-text-weight-semibold"
						>how much does Kid Cudi hum?</span
					>
				</p>
				<!-- <div class="has-text-centered">
					<p class="highlight-text-static heading is-size-4">
						How much does Kid Cudi really hum?
					</p>
				</div> -->
				<hr
					style="
						height: 1px;
						border-width: 0;
						color: #cecece;
						width: 30%;
						margin: 1.5rem auto;
					"
				/>
				<p class="content">
					In the writing that follows, I go to great lengths to explore this
					question at a variety of levels of granularity. First, I look at each
					of Kid Cudi's <span class="has-text-weight-bold">albums</span>, then
					at each of those albums'
					<span class="has-text-weight-bold">songs</span>, until I finally look
					at each individual song and analyze its
					<span class="has-text-weight-bold">lyrics</span>.
				</p>
				<p class="content">
					To measure hums, I used lyrics data from
					<a href="https://genius.com/" target="_blank" rel="noopener"
						>Genius</a
					>
					and flagged each hum-like sound from Kid Cudi's discography. I
					analyzed which songs had the most hums, which songs had the least, and
					even where in the song hums most frequently occured.
				</p>
				<p class="content">
					Technically, a hum is defined as any noise that Kid Cudi makes that is
					not a 'normal' word. For the purposes of this analysis, that could
					include noises ranging from 'hmmm' to 'meh' to 'nah.' I have to be
					inclusive of all of these hums (rather than just 'hum') because my
					data source,
					<a href="https://genius.com/" target="_blank" rel="noopener">Genius</a
					>, is composed of
					<span class="has-text-weight-bold"
						>community members' contributions</span
					>, and different transcribers have different ways of recording hums.
					More complete methodology can be found at the bottom of this site.
				</p>
			</div>
		</div>
	</section>
</template>

<script>
import AudioPlayer from "@/components/AudioPlayer.vue";

export default {
	name: "Intro",
	props: { width: Number },
	components: { AudioPlayer },
	computed: {
		properWidth() {
			return Math.min(700, this.width) - 50;
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
	created() {
		let redditEmbed = document.createElement("script");
		redditEmbed.setAttribute(
			"src",
			"//embed.redditmedia.com/widgets/platform.js"
		);
		document.head.appendChild(redditEmbed);
	},
};
</script>

<style lang="scss">
.is-gradient {
	background-image: linear-gradient(#0a0a0a, $background);
}

.has-dropcap {
	&:first-child:first-letter {
		float: left;
		font-family: Georgia;
		font-size: 120px;
		line-height: 120px;
		padding-top: 4px;
		padding-right: 8px;
		padding-left: 3px;
	}
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
</style>
