<template>
	<div class="section">
		<div class="flex-button-container">
			<!-- Each of the sections provided by SongSelector (all sections in the user-selected song)
            are printed here as buttons -->
			<button
				v-for="section in sections"
				:key="section"
				class="button"
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

<style>
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
</style>
