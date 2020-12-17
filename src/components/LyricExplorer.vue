<template>
	<div class="section">
		<div class="flex-button-container">
			<!-- Each of the sections provided by SongSelector (all sections in the user-selected song)
            are printed here as buttons -->
			<button
				v-for="section in sections"
				:key="section"
				class="button no-border ml-1"
				:class="{ toggled: selectedSections.includes(section) }"
				@click="addSection(section)"
			>
				{{ section }}
			</button>
		</div>
		<!-- Here, I am doing v-for="(section, index) in sections" and then a v-if to show, 
        rather than  v-for="(section, index) in selectedSections." 
        This is because I want to maintain ordering of sections (Intro -> Verse -> Chorus etc.)-->
		<div v-for="(section, index) in sections" :key="index">
			<div v-if="selectedSections.includes(section)" class="box m-5">
				<p
					class="heading mb-4 is-size-5 has-text-weight-light has-text-centered has-text-underlined"
				>
					{{ section }}
				</p>
				<!-- This reactively filters and then renders each word (bigram) from the dataset that matches the user-specified section -->
				<div class="content has-text-centered">
					<span
						v-for="(val, index) in songData.filter(
							(d) => d.section_name == section
						)"
						:key="index"
						:class="{ 'highlight-text-static pr-0': val.category == 'Hum' }"
					>
						{{ val.bigram }}
					</span>
				</div>
			</div>
		</div>

		<div v-if="selectedSections.length == 0">
			<div class="is-flex is-justify-content-center is-align-items-center m-5">
				<div style="max-width: 50px">
					<!-- Intro image -->
					<!-- <figure class="image is-3by4"> -->
					<img src="../assets/cudi.png" />
				</div>

				<p class="speech-bubble">
					<span class="has-text-centered"
						>Why don't you select something above?
					</span>
				</p>
			</div>
		</div>
	</div>
</template>

<script>
import * as d3 from "d3";

export default {
	name: "LyricExplorer",
	props: {
		songData: Array,
		sections: Array,
	},
	mounted() {
		// On mount, select all buttons (default view)
		this.selectedSections = [...this.sections];
	},
	components: {},
	data() {
		return { selectedSections: [] };
	},
	computed: {},
	methods: {
		addSection: function (section) {
			const { selectedSections } = this;
			// Is the section in selected already? If so, remove : else, add it
			selectedSections.includes(section)
				? selectedSections.splice(selectedSections.indexOf(section), 1)
				: selectedSections.push(section);
		},
	},
	created() {},
	destroyed() {},
	watch: {
		// On reset of the prop sections (defined in SongSelector), select all buttons (default view)
		sections: function () {
			this.selectedSections = [...this.sections];
		},
	},
};
</script>

<style lang="scss">
.has-text-underlined {
	text-decoration: underline;
}

.flex-button-container {
	display: flex;
	justify-content: center;
	place-items: center;
	align-content: center;
	flex-wrap: wrap;
}

.button {
	font-weight: 400;

	&.no-border {
		border: none;
	}

	&.toggled {
		background-color: $cudi-pink;
		color: $white-alt;

		&:hover {
			color: $white-alt;
		}
	}
}

.speech-bubble {
	position: relative;
	background: $cudi-blue;
	border-radius: 0.4em;
	// height: 100px;
	display: flex;
	place-items: center;
	padding: 0.5rem 1rem;
}

.speech-bubble:after {
	content: "";
	position: absolute;
	left: 0;
	top: 50%;
	width: 0;
	height: 0;
	border: 20px solid transparent;
	border-right-color: $cudi-blue;
	border-left: 0;
	border-bottom: 0;
	margin-top: -10px;
	margin-left: -10px;
}
</style>
