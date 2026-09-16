<script>
    import { onDestroy, onMount } from 'svelte';
    import ToggleThemeBtn from './ToggleThemeBtn.svelte';

	const { userInfo } = $props();
</script>

<div class="relative w-full bg-gray-50 dark:bg-black text-black dark:text-white border border-gray-300 dark:border-white rounded-lg shadow-sm shadow-black/80 dark:shadow-white/80 p-4">
	{#if userInfo}
			<div class="flex items-center gap-4">
				<div class="rounded bg-green-300 dark:bg-green-300 w-10 h-10 p-1">
					<img  src="{userInfo.profilePic || "https://media.istockphoto.com/id/2151669184/vector/vector-flat-illustration-in-grayscale-avatar-user-profile-person-icon-gender-neutral.jpg?s=612x612&w=0&k=20&c=UEa7oHoOL30ynvmJzSCIPrwwopJdfqzBs0q69ezQoM8="}" alt="profilePic" >
				</div>
				<div>
					<p class="text-gray-700 dark:text-gray-300">Name: {userInfo.name}</p>
					<p class="text-gray-700 dark:text-gray-300">Money: {userInfo.money}</p>
				</div>
			</div>
		{/if}
		<ToggleThemeBtn themeData={"dark"} />
</div>
