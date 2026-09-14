<script lang="ts">
    import { Sun, Moon } from '@lucide/svelte'
    const { themeData } = $props();
    let theme = $state(themeData);
    function setTheme(t: string) {
        theme = t;
        console.log("ciao");
        document.querySelector("html")?.setAttribute("data-theme", theme);
    }
    function toggle() {
        if (theme === "light") {
            setTheme("dark");
        } else if (theme === "dark") {
            setTheme("light");
        }
    }
</script>

<button class="absolute m-2 top-0 right-0" onclick={toggle}>
    {#if theme === "light"}
        <Moon />
    {:else if theme === "dark"}
        <Sun />
    {/if}
</button>