<script>
	import './app.css';
	import hero from './assets/svelte.svg';
    import { onDestroy, onMount } from 'svelte';
    import JobCard from './lib/JobCard.svelte';
    import Menu from './lib/Menu.svelte';

	let visible = $state(true);
	let extraJobInfo = $state(false);
	let inputValue = '';
	let selectedJob = $state("taxi");
	let userInfo = $state({
		name: "test",
		money: 0,
		profilePic: ""
	});

	const containerStyle = "px-4 py-8 bg-white dark:bg-gray-900 text-black dark:text-white rounded-lg shadow-md border border-gray-300 dark:border-gray-700";

	function handleMessage(event) {
		const data = event.data;
		if (data.action === 'setVisible') {
			visible = data.status;
		} else if (data.action === 'setUserInfo') {
			userInfo = data.info;
		}
	}

	function handleKeys(event) {
		console.log('Key pressed:', event.key);
		if (event.key === 'Escape') {
			closeUI();
		} else if (event.key.toLowerCase() === "e" && selectedJob) {
			extraJobInfo = !extraJobInfo;
		}
	}

	onMount(() => {
		window.addEventListener('message', handleMessage);
		window.addEventListener('keydown', handleKeys);
	});

	onDestroy(() => {
		window.removeEventListener('message', handleMessage);
		window.removeEventListener('keydown', handleKeys);
	});

	$effect(() => {
	});

	function closeUI() {
		fetch(`https://${GetParentResourceName()}/closeUI`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({})
		});
	}

	function sendAction() {
		fetch(`https://${GetParentResourceName()}/actionButton`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ value: inputValue })
		});
	}
</script>

<div class="absolute top-5 left-5 transition-all duration-1000 text-white text-xl text-shadow-lg {selectedJob ? 'opacity-100' : 'opacity-0'}">
	<span class="bg-white p-2 text-2xl rounded-sm shadow-2xl">E</span> per espandere le istruzioni
	<h3>Istruzioni Job: {selectedJob.toUpperCase()}</h3>
	<ul class="transition-all duration-1000 {extraJobInfo ? 'opacity-100' : 'opacity-0'}">
		<li>1 ciao test</li>
		<li>2 test</li>
		<li>3 test test</li>
	</ul>
</div>

{#if visible}
<div class="h-screen w-screen overflow-hidden flex items-end-safe justify-center bg-[url('https://wallpaperaccess.com/full/3551518.jpg')]">
	<div class="h-[calc(100%-10rem)] w-[calc(100%-10rem)] overflow-hidden {containerStyle}">
		<Menu {userInfo} />
		<div class="my-5"></div>
		<div class="grid grid-cols-4 gap-4 overflow-y-auto h-[calc(100%-5rem)]">
			<JobCard job={"taxi"} bind:selectedJob={selectedJob} previewImage={hero} title="Svelte Job" description="This is a simple Svelte job card." />
			<JobCard job={"netturbino"} bind:selectedJob={selectedJob} previewImage={hero} title="Svelte Job" description="This is a simple Svelte job card." />
			<JobCard job={"pesca"} bind:selectedJob={selectedJob} previewImage={hero} title="Svelte Job" description="This is a simple Svelte job card." />
		</div>
	</div>
</div>
{/if}

