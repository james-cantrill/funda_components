<template lang="html">
    <div>
        <h1>Change Password for {{localvar}}</h1>

        <div v-if="changePwordFailed" class="loadError">
            <p>{{resultMsg}}</p>
        </div>

            <form class="form-change-pword"  @submit.prevent="changePword">

                <div>
                    <label>Enter New Password</label>
                    <br>
                    <input type="password" v-model="password" placeholder="" class="input-block-level">
                    <br><br>
                </div>

                <div>
                    <label>Enter New Password Again</label>
                    <br>
                    <input type="password" v-model="repeatPassword" placeholder="" class="input-block-level">
                    <br><br>
                </div>

                <div class="row" style="horizontal-align: center">
                    <button type="submit" class="btn btn-large btn-primary">Change Password </button>
                </div>
            </form>

            <div style="width:32%; display:inline-block; vertical-align: top; ">
              <form class="cancel" @submit.prevent="cancel">
                <button class="btn-large" type="submit">Cancel</button>
              </form>
            </div>
        </div>
</template>

<script>
/* eslint-disable */
import {globalStore} from '../main.js'

export default {
  name: 'changePword',
  data () {
    return {
      username: '',
      password: '',
      repeatPassword: '',
      changePwordFailed: false,
      resultMsg: '',
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
    changePword () {
      if (this.password != this.repeatPassword) {
        this.resultMsg = 'Entered Passwords Do Not Match. Please Try Again'
        this.changePwordFailed = true
      } else {
        this.axios.get('http://localhost:3000/system_user_manager/user_login?login=' + this.username + '&password=' + this.password)
          .then(request => this.changePwordSuccessful(request))
          .catch(function (error) {
            console.log('in error')
            console.log(JSON.stringify(error))
          })

      }
    },

    changePwordSuccessful (req) {
      if (req.data.result_indicator == 'Failure'){
        this.resultMsg = req.data.message;
        this.changePwordFailed = true;
        this.$router.replace(this.$route.query.redirect || '/changePword');
      } else {
       this.$router.replace(this.$route.query.redirect || '/home');
      }
    }

    
  } 
  
}
</script>

<style lang="css">
</style>
