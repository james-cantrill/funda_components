<template lang="html">
    <div>
        <h1>{{title}}</h1>

			<form class="logout" action="/enter_user_data" method="get">
				<button class="btn-medium" type="submit">Enter a New User</button>
			</form>
			<br>
			<form class="logout" action="/system_user_manager/list_users" method="get">
				<button class="btn-medium" type="submit">Edit Allowed Actions</button>
			</form>
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
