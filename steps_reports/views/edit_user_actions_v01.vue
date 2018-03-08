<template lang="html">
    <div>
        <h1>{{title}}</h1>

			<form class="logout" action="/save_user_actions" method="get">
			
				<div  v-for="action in user_actions">
					<input v-if="action.action_allowed" type="checkbox" v-model="action.action_allowed" :value="action.action_allowed" :name="action.action" checked>
					<input v-else type="checkbox" :value="action.action_allowed" :name="action.action" >
					<label>{{action.action_display_name}}</label>
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
