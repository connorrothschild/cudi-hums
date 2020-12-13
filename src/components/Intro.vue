<template>
	<div class="is-gradient">
		<section class="hero is-fullheight has-text-centered">
			<div class="hero-body">
				<div class="container">
					<div class="is-inline-flex place-items-center">
						<figure class="image is-inline-block is-96x132">
							<img class="is-inline-block shake" src="../assets/cudi.png" />
						</figure>
						<h1 class="title has-text-weight-light ml-3 has-text-black">
							hmmmmmmmm
						</h1>
					</div>
					<h2 class="heading is-size-3 has-text-weight-semibold">
						How Much Does Kid Cudi Hum?
					</h2>
					<p class="mt-6">First bit of intro text here...</p>
				</div>
			</div>
		</section>
		<div class="section">
			<div class="container is-max-desktop">
				<p class="content my-3">
					Kid Cudi dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
				<p class="content my-3">
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
				<p class="content my-3">
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
				<p class="content my-3">
					Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam est
					ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
					repellat quo tenetur molestias inventore, dolorum corporis, unde,
					nobis nisi officia quos!
				</p>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	name: "Intro",
};
</script>

<style scoped>
.shake {
	animation: shake 2.5s infinite;
}

.shake:hover {
	animation: none;
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

p:first-child:first-letter {
	float: left;
	font-family: Georgia;
	font-size: 55px;
	line-height: 40px;
	padding-top: 4px;
	padding-right: 8px;
	padding-left: 3px;
}

.is-gradient {
	background-image: linear-gradient(#4c6dbc, #f5f5f5);
}
</style>
