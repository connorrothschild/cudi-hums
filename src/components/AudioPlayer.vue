<template>
	<span class="audio-clicker" @click="playAudio(src)"
		><span class="highlight-text-static"
			>{{ song }}
			<svg
				xmlns="http://www.w3.org/2000/svg"
				xmlns:xlink="http://www.w3.org/1999/xlink"
				width="14"
				height="14"
				viewBox="0 0 14 14"
				version="1.1"
			>
				<g id="audio-player">
					<path
						class="speaker"
						:class="{ active: this.playing }"
						d="M 39.383371 13.769531 L 22.244699 28.606306 L 6.005859 28.606306 L 6.005859 47.691127 L 21.993583 47.691127 L 39.383371 62.758092 Z M 39.383371 13.769531 "
						transform="matrix(0.186667,0,0,0.186667,0,0)"
					/>
					<path
						class="lines"
						:class="{ active: this.playing }"
						d="M 48.005022 27.601842 C 52.273996 34.089007 52.273996 42.501395 48.005022 49.009487 M 55.099051 20.507812 C 62.904576 31.075614 62.904576 45.514788 55.099051 56.103516 M 61.607143 13.999721 C 73.011998 28.187779 73.011998 48.402623 61.607143 62.590681 "
						transform="matrix(0.186667,0,0,0.186667,0,0)"
					/>
				</g>
			</svg>
		</span>
	</span>
</template>

<script>
export default {
	name: "AudioPlayer",
	props: {
		src: String,
		song: String,
	},
	data() {
		return { audio: null, playing: false };
	},
	methods: {
		playAudio(url) {
			if (!this.audio || this.audio.paused) {
				this.audio = new Audio(url);
				this.audio.play();
				this.playing = true;
			} else {
				this.audio.pause();
				this.playing = false;
			}
		},
	},
};
</script>

<style lang="scss">
.audio-clicker {
	cursor: pointer;
}

.speaker {
	fill-rule: nonzero;
	fill: white;
	fill-opacity: 1;
	stroke-width: 5;
	stroke-linecap: butt;
	stroke-linejoin: round;
	stroke: white;
	stroke-opacity: 1;
	stroke-miterlimit: 4;

	&.active {
		fill: black;
		stroke: black;
	}
}

.lines {
	fill: none;
	stroke-width: 5;
	stroke-linecap: round;
	stroke-linejoin: miter;
	stroke: white;
	stroke-opacity: 1;
	stroke-miterlimit: 4;

	&.active {
		stroke: black;
	}
}
</style>
