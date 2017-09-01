<template lang="html">
    <div>
        <h1>{{title}}</h1>

		<form class="select" action="/show_user_actions" name="select_a_user" method="get">
			<select name="selected_user" >
			  <option v-for="user in users" :value="user.login">
				{{ user.name_last_first}}
			  </option>
			</select>
			<br><br>
			<button class="btn-medium" type="submit">Edit Actions</button>
		</form>
		
		
		
		<br><br>
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

