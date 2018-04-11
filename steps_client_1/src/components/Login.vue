<template lang="html">
    <div>
        <h1>{{msg}}</h1>

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
/* eslint-disable */
var _result_message = '';
export default {
  name: 'Login',
  data () {
    return {
      username: '',
      password: '',
      error: false,
      msg: 'Welcome to STEPS Reports'
    }
  },

  methods: {
    login () {
      
      this.axios.get('http://localhost:3000/system_user_manager/user_login?login=' + this.username + '&password=' + this.password)
        .then(request => this.loginSuccessful(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
          // if (error.response) {
          console.log(error.response.data);
          console.log(error.response.status);
          console.log(error.response.headers)
          //  }
        })
    },

    loginSuccessful (req) {
      if (req.data.result_indicator == 'Failure'){
        this.msg = req.data.message;
        this.$router.replace(this.$route.query.redirect || '/');
      } else {
	  this.axios.get('http://localhost:4000/report_manager/load_report_list?login=' + this.username)
          .then(request => this.reportsReturned(request))
          .catch(function (error) {
            console.log(error);
          });
      }
    },

     reportsReturned (req) {
       console.log('in response from load_report_list');
       console.log(JSON.stringify (req));
       this.msg = req.data.message;
	   console.log (this.msg);
	   hm_msg = req.data.message;
       this.$router.replace(this.$route.query.redirect || '/home')
	 
	 }

    
  }
}
</script>

<style lang="css">
</style>
