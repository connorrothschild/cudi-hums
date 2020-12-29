<template>
	<section>
		<div style="max-width: 900px; padding: 1%; margin: 0 auto">
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
				class="myTable"
				default-sort="tableData.percent_hums"
			>
				<b-table-column
					field="song_name"
					label="Song"
					width="30%"
					v-slot="tableData"
					><a
						:href="tableData.row.song_lyrics_url"
						class="table-links"
						target="_blank"
						rel="noopener"
						>{{ tableData.row.song_name }}</a
					>
				</b-table-column>

				<b-table-column
					field="album_name"
					label="Album"
					width="30%"
					v-slot="tableData"
				>
					<div class="is-flex">
						<img
							style="max-width: 50px; max-height: 50px"
							:src="tableData.row.song_art_image_url"
							alt="hello"
						/>
						<p class="ml-3">
							{{ tableData.row.album_name }}
						</p>
					</div>
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
	},
	data() {
		return {
			search: null,
			majorAlbumsOnly: false,
		};
	},
	computed: {
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
	mounted() {
		console.log(this.data);
	},
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
}

.switch input[type="checkbox"]:checked + .check {
	background: $cudi-pink !important;
}

.table-links {
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
