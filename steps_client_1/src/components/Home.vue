<template lang="html">
    <div>
        <h1>{{hm_msg}}</h1>
        <v-jstree :data="report_json"  ></v-jstree>
            <form class="logout" @submit.prevent="logout">
                <button class="btn-medium" type="submit">Log Out</button>
            </form>
        </div>

</template>

<script>
/* eslint-disable */

import {globalStore} from '../main.js'
import VJstree from 'vue-jstree'

export default {
  name: 'Home',
  data () {
    return {
      hm_msg: 'Please Select a Report',
      report_json: [],
      localvar: globalStore.userLogin
    }
  },

  components: { 
      VJstree
    },

  beforeCreate() {
    console.log('global login = ' + globalStore.userLogin)
    this.axios.get('http://localhost:4000/report_manager/load_report_list?login=' + globalStore.userLogin)
      .then(request => this.reportsReturned(request))
          .catch(function (error) {
            console.log(error);
          });
  },

  
  computed: {
    computedvar: function () {
      return globalStore.userLogin
    }
  },

  methods: {  
  reportsReturned (req) {
       this.hm_msg = req.data.message;
       this.report_json = JSON.parse(JSON.stringify (req.data.data));
     },
     
    logout () {      
      this.axios.get('http://localhost:3000/system_user_manager/user_logout?login=' + globalStore.userLogin)
        .then(request => this.logoutSuccessful(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },
     
    logoutSuccessful (req) {
        this.msg = req.data.message;
        console.log(JSON.stringify (req));
        this.$router.replace(this.$route.query.redirect || '/');
    } 
  } 
}
</script>

<style lang="css">
</style>
