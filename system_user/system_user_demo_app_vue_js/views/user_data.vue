<template lang="html">
    <div>
        <h1>{{title}}</h1>
	

		
			<form class="save_person" action="/system_user_manager/add_one_user" method="get">
				<label>First Name</label>
				<input type="text" id="firstname" value="" name="firstname">
				<br><br>
				<label>Last Name</label>
				<input type="text" id="lastname" value="" name="lastname">
				<br><br>
				<label>User Login </label>
				<input type="text" id="login" value="" name="login">
				<br><br>
				<label>Password</label>
				<input type="text" id="password" name="password">
				<br><br><br><br>
				<button class="btn-small" type="submit">Save</button><br><br>
			</form>
			
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
