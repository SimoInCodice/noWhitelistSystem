<script lang="ts">
	import './app.css';
	import hero from './assets/svelte.svg';
    import { onDestroy, onMount } from 'svelte';
    import JobCard from './lib/JobCard.svelte';
    import Menu from './lib/Menu.svelte';
    import TasksList from './lib/TasksList.svelte';
    import type { Task } from './lib/TasksList.svelte';

	let visible = $state(true);
	let extraJobInfo = $state(true);
	let inputValue = '';
	let selectedJob = $state("taxi");
	let userInfo = $state({
		name: "test",
		money: 0,
		profilePic: ""
	});

	let jobs = $state([
		{
			name: "taxi",
			label: "Taxi",
			title: "Taxi JOB",
			description: "Take around NPSs",
			picPath: "",
			tasks: [
				{
					id: 1,
					name: "Test",
					description: "Do this!",
					active: false,
					completed: true,
				},
				{
					id: 2,
					name: "Test1",
					description: "Do that!",
					active: true,
					completed: false,
				},
				{
					id: 2,
					name: "Test1",
					description: "Do that!",
					active: false,
					completed: false,
				}
			]
		}
	]);

	let tasks: Task[] | undefined = $state([]);

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
		} else if (event.key.toLowerCase() === "b" && selectedJob) {
			extraJobInfo = !extraJobInfo;
		} else if (event.key === "ArrowDown") {
			if (tasks) {
				const activeTask = tasks.find(t => t.active);
				if (activeTask) {
					const currentTaskIndex = tasks.indexOf(activeTask);
					if (currentTaskIndex !== -1) {
						const nextTask = tasks[(currentTaskIndex + 1)];
						console.log(nextTask);
						activeTask.active = false;
						activeTask.completed = true
						if (nextTask) nextTask.active = true;
					}
				}
			}
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
		tasks = jobs.find(j => j.name === selectedJob)?.tasks;
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
<div class="h-screen w-screen overflow-hidden flex items-center-safe justify-center bg-trasparent">
	<div class="z-998 h-[calc(100%-10rem)] w-[calc(100%-10rem)] overflow-hidden px-4 py-8 bg-white dark:bg-gray-900 text-black dark:text-white rounded-lg shadow-md border border-gray-300 dark:border-gray-700">
		<Menu {userInfo} />
		<div class="my-5"></div>
		<div class="grid grid-cols-4 gap-4 overflow-y-auto h-[calc(100%-5rem)]">
			{#each jobs as job (job)}
				<JobCard job={job.name} bind:selectedJob={selectedJob} previewImage={job.picPath} title={job.title} description={job.description} />
			{/each}
		</div>
	</div>
</div>
{/if}

<div class="z-1 absolute top-5 left-5 transition-all duration-1000 text-white text-xl text-shadow-lg {selectedJob ? 'opacity-100' : 'opacity-0'}">
	<span class="w-2 h-2 px-2 bg-white text-black text-2xl rounded-sm shadow-2xl">B</span> per espandere le istruzioni
	<h3>Istruzioni Job: {selectedJob.toUpperCase()}</h3>
	<div class="space-y-2"></div>
	<ul class="">
		<TasksList {tasks} extraInfo={extraJobInfo}/>
	</ul>
</div>