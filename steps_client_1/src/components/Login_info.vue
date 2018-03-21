<template lang="html">
    <div class="Index">
    <h1>Please Log In</h1>
    <h1>{{ localvar }}</h1>
			<form class="form-signin"  @submit.prevent="login">

				<div> 
					<label>Username</label>
					<br>
					<input type="text" v-model="username" placeholder="" class="input-block-level">
					<br><br>
				</div>
				
				<div>
					<label>Password</label>
					<br>
					<input type="password" v-model="password" placeholder="" class="input-block-level">
					<br><br>
				</div>
				
				<div class="row">
					<button type="submit" class="btn btn-large btn-primary">Sign in </button>
				</div>
			</form>
		</div>
		
</template>

<script>
import {globalStore} from '../main.js'

export default {
    name: 'Login',
	data: function() {
        return {
		  username: '',
		  password: '',
		  error: false,
		  localvar: globalStore.globalvar
        }
	},

	
  computed: {
    computedvar: function () {
      return globalStore.globalvar
    }
	},
	
  methods: {
    login () {
      console.log(this.username)
      console.log(this.password)
      this.$http.get('/user_login?login=' + this.username + '&password=' + this.password)
	  .then(request => this.loginSuccessful(request))
        .catch(() => this.loginFailed())
    },

    loginSuccessful (req) {
      console.log(req.data)
	 // gLogin = this.username
      //this.$eventHub.$emit('logged-in', {login: this.username});
      this.$router.replace(this.$route.query.redirect || '/home')
    },

    loginFailed () {
      this.error = 'Login failed!'
      delete localStorage.token
    }
  }
  
}
</script>

<style scoped>
</style>
