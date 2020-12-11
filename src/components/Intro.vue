<template>
	<section class="hero is-black is-fullheight has-text-centered">
		<div class="hero-body">
			<div class="container">
				<div class="is-inline-flex place-items-center">
					<figure class="image is-inline-block is-96x132">
						<img class="is-inline-block shake" src="../assets/cudi.png" />
					</figure>
					<h1 class="title has-text-weight-light ml-3">
						CLEVER TITLE GOES HERE
					</h1>
				</div>
				<div class="container is-max-desktop">
					<p class="content my-3">
						Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam
						est ipsum vitae quasi voluptatem reiciendis facilis eligendi eveniet
						repellat quo tenetur molestias inventore, dolorum corporis, unde,
						nobis nisi officia quos!
					</p>
				</div>
				<h2 class="heading is-size-3 has-text-weight-semibold">
					How Much Does Kid Cudi Hum?
				</h2>
			</div>
		</div>
	</section>
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
</style>
