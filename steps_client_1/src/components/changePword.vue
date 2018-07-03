<template lang="html">
    <div>
      <div style="width:900px; height:150px; margin: 0 auto;  horizontal-align: left">
        <b-navbar toggleable="md" type="light" variant="light">

          <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

          <b-navbar-brand href="#">Navigation</b-navbar-brand>

          <b-collapse is-nav id="nav_collapse">

            <b-navbar-nav>
              <b-nav-item to="home" variant="primary">Home</b-nav-item>
            </b-navbar-nav>

            <!-- Right aligned nav items -->
            <b-navbar-nav class="ml-auto">

              <b-nav-item-dropdown right>
                <!-- Using button-content slot -->
                <template slot="button-content">
                  <em>User</em>
                </template>
                <b-dropdown-item v-bind:to="'changePword'" href="#" >Change Password</b-dropdown-item>
                <b-dropdown-item href="#" v-on:click="logout ()">Signout</b-dropdown-item>
              </b-nav-item-dropdown>
            </b-navbar-nav>

          </b-collapse>
        </b-navbar>

      </div>
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
        this.username = globalStore.userLogin
        console.log ('username = ' + this.username)
        var sent_url = 'http://localhost:3000/system_user_manager/change_password?login=' + this.username + '&password=' + this.password + '&changing_user_login=' + this.username 
        console.log (sent_url)
        this.axios.get(sent_url)
          .then(request => this.changePwordSuccessful(request))
          .catch(function (error) {
            console.log('in error')
            console.log(JSON.stringify(error))
          })

      }
    },

    changePwordSuccessful (req) {
      console.log ('Returned data = ' + req.data)
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
