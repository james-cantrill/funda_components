<template lang="html">
    <div>
        <h1>{{title}}</h1>

			<form class="logout" action="/save_user_actions" method="get">
			
				<div  v-for="action in user_actions">
				<section_label>{{action.service}}: {{action.action_display_name}}</section_label>
				<input v-if="action.action_allowed" type="radio" id="one" value="true" checked :name="action.action">
				<input v-else type="radio" id="one" value="true"  :name="action.action">
				<label2 class="radio_label">Allow</label2>
				<input v-if="action.action_allowed" type="radio" id="two" value="false" :name="action.action">
				<input v-else type="radio" id="two" value="false" checked :name="action.action">
				<label2 class="radio_label">Don't Allow</label2>
				

				</div>
				<br>
				<button class="btn-medium" type="submit">Save User Actions</button>
			</form>
			<br>
			
			<br>
			<form class="logout" action="/system_user_manager/user_logout" method="get">
				<button class="btn-medium" type="submit">Log Out</button>
			</form>
			
		</div>
		
</template>

<script>
export default {
    data: function() {
        return {
        }
    }
}
</script>

<style lang="css">
</style>
