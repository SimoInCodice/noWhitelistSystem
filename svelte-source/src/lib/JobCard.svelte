<script>
    import { onDestroy, onMount } from 'svelte';
    let { job, selectedJob = $bindable(), previewImage, title, description } = $props();

    function applyBtn() {
        if (selectedJob === job) {
            selectedJob = "";
        } else {
            selectedJob = job;
        }
    }
</script>

<div class="card flex flex-col h-fit bg-linear-to-r from-cyan-500 to-blue-500 dark:bg-linear-to-r dark:from-blue-500 dark:to-purple-500 border border-gray-300 dark:border-white rounded-lg shadow-sm shadow-black/80 dark:shadow-white/80 p-4 space-y-2">
	<img class="w-32 h-32" src={previewImage} alt="Job Preview" />
	<h2>{title}</h2>
	<p>{description}</p>
    <button onclick={applyBtn} class="btn justify-center p-2 rounded-2xl bg-black dark:bg-white text-white dark:text-black">{selectedJob === job ? "RIMUOVI" : "APPLICA"}</button>
</div>
