<template>
	<section class="container is-max-desktop p-3" style="overflow-x: hidden">
		<p
			class="title mb-2 is-size-2 is-size-3-mobile has-text-weight-light has-text-centered"
		>
			Hums by track
		</p>
		<h2
			class="subtitle mt-2 has-text-centered has-text-white has-text-weight-light"
		>
			Here, you can look at each of Kid Cudi's songs and their proportions of
			hums. <br />Feel free to search for a specific song or album, or view a
			song's lyrics by clicking on its name!
		</h2>
		<div style="max-width: 1000px; margin: 0 auto">
			<div
				class="is-flex responsive-flex-direction is-justify-content-space-between"
			>
				<b-switch v-model="majorAlbumsOnly">Show major albums only</b-switch>
				<b-input
					v-model="search"
					placeholder="Search for a song or album"
					class="my-3"
					rounded
				></b-input>
			</div>
			<b-table
				:data="tableData"
				:sticky-header="true"
				:mobile-cards="false"
				height="500px"
				sort-icon="chevron-up"
				class="myTable"
				default-sort="tableData.percent_hums"
			>
				<b-table-column
					field="album_name"
					label="Album"
					v-slot="tableData"
					:width="albumColumnWidth"
				>
					<div class="is-flex">
						<img
							style="max-width: 50px; max-height: 50px"
							:src="tableData.row.song_art_image_url"
							:alt="tableData.row.album_name"
						/>
						<p class="ml-3" v-if="containerWidth > 1000">
							{{
								tableData.row.album_name == "NA"
									? "Single"
									: tableData.row.album_name
							}}
						</p>
					</div>
				</b-table-column>

				<b-table-column
					field="song_name"
					label="Song"
					v-slot="tableData"
					:width="songColumnWidth"
					><a
						:href="tableData.row.song_lyrics_url"
						class="table-links"
						target="_blank"
						rel="noopener"
						>{{ tableData.row.song_name }}</a
					>
				</b-table-column>

				<b-table-column
					field="percent_hums"
					label="Percent hums"
					width="10%"
					sortable
					v-slot="tableData"
				>
					<span class="highlight-text-static">
						{{ percentFormat(tableData.row.percent_hums) }}
					</span>
				</b-table-column>
			</b-table>
		</div>
	</section>
</template>

<script>
import * as d3 from "d3";

export default {
	name: "Table",
	props: {
		data: Array,
		major_albums: Array,
		containerWidth: Number,
	},
	data() {
		return {
			search: null,
			majorAlbumsOnly: false,
		};
	},
	computed: {
		// Make the song column have a fixed width on large screens, to prevent jumpiness on album toggle
		songColumnWidth() {
			return this.containerWidth > 1000 ? "50%" : "80%";
		},
		// If album column contains text, don't specify width; if only image, make it size of image
		albumColumnWidth() {
			return this.containerWidth > 1000 ? null : "50";
		},
		goodData() {
			return this.data.map(function (d) {
				return {
					song_name: d.song_name,
					album_name: d.album_name,
					percent_hums: d.percent_hums,
					song_art_image_url: d.song_art_image_url,
					song_lyrics_url: d.song_lyrics_url,
				};
			});
		},
		tableData() {
			const { search, goodData, majorAlbumsOnly, major_albums } = this;
			// If search is empty, show all; otherwise filter
			const searchedData = search
				? goodData.filter(
						(d) =>
							d.song_name.toUpperCase().includes(search.toUpperCase()) |
							d.album_name.toUpperCase().includes(search.toUpperCase())
				  )
				: goodData;

			const finalData = majorAlbumsOnly
				? searchedData.filter((d) => major_albums.includes(d.album_name))
				: searchedData;

			return finalData;
		},
	},
	methods: {
		percentFormat: d3.format(".1%"),
	},
	watch: {},
};
</script>

<style lang="scss">
.myTable {
	table {
		&.table,
		thead,
		th {
			background-color: $background !important;
			color: white;
		}
	}
	.table-wrapper {
		max-height: 60vh;
		// On large screens, don't allow horizontal scroll
		@media screen and (min-width: 468px) {
			overflow-x: hidden;
		}
	}
}

.switch input[type="checkbox"]:checked + .check {
	background: $cudi-pink !important;
}

.table-links {
	background-color: transparent;
	color: white !important;

	&::after {
		content: "\f35d";
		font-family: "Font Awesome 5 Free";
		font-weight: 600;
		font-size: 12px;
		font-style: normal;
		text-decoration: inherit;
		margin-left: 5px;
		color: $cudi-pink;
	}
}
</style>
