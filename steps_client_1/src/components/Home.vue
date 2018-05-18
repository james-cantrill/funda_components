<template lang="html">
    <div>
        <h1>{{wlcm_msg}}</h1>

        <div style="width:900px; margin: 0 auto; ">
            <div style="width:69%; display:inline-block; vertical-align: top; ">
                <p style="text-align:left">{{hm_msg}}</p>
                <v-jstree :data="report_json" @item-click="itemClick" style="width:620px; height:400px; overflow:auto; overflow-x:auto; overflow-y:auto;" ></v-jstree>
            </div>
            <div style="width:30%; display:inline-block;">
                <textarea v-model="itemDescription" style="height:300px; width:100%;">
                </textarea>

                  <form  class="loadReport" @submit.prevent="loadReport">
                    <button v-if="reportSelected" class="btn-medium" type="submit">{{runMsg}}  </button>
                  </form>

            </div>
        </div>

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
      wlcm_msg: 'Welcome ' + globalStore.userFullName,
      itemDescription: 'Description appears here',
      reportSelected: 'FALSE',
      reportId: '',
      reportName: '',
      runMsg: '',
      report_json: [],
      localvar: globalStore.userLogin
    }
  },

  components: { 
      VJstree
    },

  beforeCreate() {
    //console.log('global login = ' + globalStore.userLogin)
    //console.log('global userFullName = ' + globalStore.userFullName)
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
      //this.hm_msg = req.data.message;
       this.report_json = JSON.parse(JSON.stringify (req.data.data));
     },
     
    itemClick (node) {
      console.log('node.model.icon = ' + node.model.icon)
      this.reportSelected = 'FALSE'
      this.reportName = ''
      this.editingNode = node
      this.editingItem = node.model
      this.itemDescription = node.model.value
      this.reportName = node.model.text
	  this.reportId = node.model.text
      console.log('report selected = ' + this.reportSelected)
      console.log('report name = ' + this.reportName)
      if (node.model.icon == 'folder') {
        this.reportSelected = 'FALSE'
        this.runMsg = ''
      } else {
        if (node.model.icon == 'report') {
          this.reportSelected = 'TRUE'
          this.runMsg = 'Open ' + this.reportName
        }
      }
      console.log('report selected = ' + this.reportSelected)
      console.log('report name = ' + this.runMsg)
    },

     loadReport () {      
      console.log('in loadReport')    
      this.axios.get('http://localhost::4000/report_manager/load_selected_report?login=' + globalStore.userLogin + 'report_id=' + this.reportId)
        .then(request => this.reportLoaded(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },

     reportLoaded (req) {
        this.msg = req.data.message;
        console.log(JSON.stringify (req));
       // this.$router.replace(this.$route.query.redirect || '/');
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
        //console.log(JSON.stringify (req));
        this.$router.replace(this.$route.query.redirect || '/');
    } 
  } 
}
</script>

<style lang="css">

</style>
