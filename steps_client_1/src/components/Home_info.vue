<template lang="html">
    <div>
        <h1>{{ msg }}</h1>
		<h1>{{ localvar }}</h1>


		<form class="logout" @submit.prevent="logout">
				<button class="btn-medium" type="submit">Log Out</button>
			</form>
			
		</div>
		
</template>

<script>
import {globalStore} from '../main.js'

export default {
    data: function() {
        return {
            username: '',
			msg: 'Welcome to STEPS Reports',
		    localvar: globalStore.globalvar
        }
    },
  computed: {
    computedvar: function () {
      return globalStore.globalvar
    }
	},
	
/*(	created() {
		this.$eventHub.$on('logged-in', this.getCurrentUser );
	},
	beforeDestroy() {
		this.$eventHub.$off('logged-in');
	},
*/	  methods: {
    getCurrentUser(login) 
            {
			  console.log (login);
         // name will be automatically transported to the parameter.
                this.username = login;
            },
			
	logout () {
      console.log(this.username)
      this.$http.get('/user_logout?login=' + this.username)
	  .then(request => this.logoutSuccessful(request))
        .catch(() => this.logoutFailed())
    },

    logoutSuccessful (req) {
      console.log(req.data)
      globalStore.globalvar = this.username
      this.$router.replace(this.$route.query.redirect || '/')
    },

    logoutFailed () {
      this.error = 'Logout failed!'
      delete localStorage.token
    }
  }
  
}
</script>

<style lang="css">
</style>
