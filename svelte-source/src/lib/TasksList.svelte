<script lang="ts">
    export type Task = {
        id: number,
        name: string,
        description: string,
        active: boolean,
        completed: boolean,
    }
    const { tasks = $bindable(), extraInfo }: { tasks: Task[] | undefined, extraInfo: boolean } = $props();
</script>

<ul>
    {#each tasks as task (task)}
        <li class="transition-all duration-1000 { task.active ? 'text-green-400' : extraInfo ? 'opacity-100' : 'hidden'} {task.completed ? 'text-gray-400 line-through' : ''}">{task.description}</li>
    {/each}
</ul>