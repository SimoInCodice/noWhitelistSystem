<script>
	import './app.css';
	import hero from './assets/svelte.svg';
    import { onDestroy, onMount } from 'svelte';
    import JobCard from './lib/JobCard.svelte';
    import Menu from './lib/Menu.svelte';

	let visible = $state(true);
	let inputValue = '';
	let selectedJob = $state("taxi");
	let userInfo = $state({
		name: "test",
		money: 0,
		profilePic: ""
	});

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

{#if visible}
<div class="h-screen w-screen overflow-hidden flex items-center justify-center">
	<div class="h-[calc(100%-10rem)] w-[calc(100%-10rem)] px-4 py-8 bg-white dark:bg-gray-900 text-black dark:text-white rounded-lg shadow-md border border-gray-300 dark:border-gray-700 overflow-hidden">
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

