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

                <div class="row" style="horizontal-align: center">
                    <button type="submit" class="btn btn-large btn-primary">Sign in </button>
                </div>
            </form>

        </div>
</template>

<script>
/* eslint-disable */
import {globalStore} from '../main.js'

export default {
  name: 'Login',
  data () {
    return {
      username: '',
      password: '',
      error: false,
      msg: 'Please Log In',
      localvar: globalStore.userLogin
    }
  },
  
  computed: {
    computedvar: function () {
      return globalStore.userLogin
    }
  },

methods: {
    login () {      
      this.axios.get('http://localhost:3000/system_user_manager/user_login?login=' + this.username + '&password=' + this.password)
        .then(request => this.loginSuccessful(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },

    loginSuccessful (req) {
      globalStore.userLogin = this.username
      globalStore.userFullName = req.data.firstname + ' ' + req.data.lastname
      //console.log ('changed global: ' + globalStore.userLogin)
      if (req.data.result_indicator == 'Failure'){
        this.msg = req.data.message;
        this.$router.replace(this.$route.query.redirect || '/');
      } else {
       this.$router.replace(this.$route.query.redirect || '/home')
      }
    }

    
  } 
  
}
</script>

<style lang="css">
</style>
