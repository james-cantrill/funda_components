<template lang="html">
    <div>
        <h1>{{wlcm_msg}}</h1>
        <div v-if="reportsLoadFailed" class="loadError">
            <p>{{resultMsg}}</p>
        </div>
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
      resultMsg: '',
      reportsLoadFailed: false,
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
      if (req.data.result_indicator == 'Failure'){
        this.resultMsg = req.data.message;
        this.reportsLoadFailed = true
      } else {
       this.report_json = JSON.parse(JSON.stringify (req.data.data));
      }
     },
     
    itemClick (node) {
      console.log('node.model.icon = ' + node.model.icon)
      this.reportSelected = 'FALSE'
      this.reportName = ''
      this.editingNode = node
      this.editingItem = node.model
      this.itemDescription = node.model.value
      this.reportName = node.model.text
      this.reportId = node.model.id
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
      var rptUrl = 'http://localhost:4000/report_manager/load_selected_report?login=' + globalStore.userLogin + '&report_id=' + this.reportId
      console.log ('rptUrl = ' + rptUrl)  
      this.axios.get(rptUrl)
        .then(request => this.reportLoaded(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },

     reportLoaded (req) {
        console.log('In reportLoaded');
        this.resetShowParams ();
        globalStore.reportName = req.data.report_name;
        globalStore.reportUrl = req.data.url;
        globalStore.reportParams = req.data.parameters;
        globalStore.reportParams.forEach(function(parameter){
            console.log(parameter.parameter_name);
            switch (parameter.parameter_name) {
                case 'ReportStartDate':
                  console.log ('In case ReportStartDate');
                  globalStore.showReportStartDate = 1;
                  globalStore.descriptionReportStartDate = parameter.parameter_description;
                  break;
                case 'ReportEndDate':
                  console.log ('In case ReportEndDate');
                  globalStore.showReportEndDate = 1;
                  globalStore.descriptionReportEndDate = parameter.parameter_description;
                  break;
                case 'MonthStart':
                  console.log ('In case MonthStart');
                  globalStore.showMonthStart = 1;
                  globalStore.descriptionMonthStart = parameter.parameter_description;
                  break;
                case 'ProgramIds':
                  console.log ('In case ProgramIds');
                  console.log ('showProgramIds = ' + globalStore.showProgramIds);
                  globalStore.showProgramIds = 1;
                  globalStore.descriptionProgramIds = parameter.parameter_description;
                  console.log ('Reset ProgramIds');
                  console.log (globalStore.showProgramIds);
                  break;
                case 'CocName':
                  console.log ('In case CocName');
                  globalStore.showCocName = 1;
                  globalStore.descriptionCocName = parameter.parameter_description;
                  break;
              };
        });
        this.$router.replace(this.$route.query.redirect || '/runReport');
    },

    resetShowParams () {
         console.log ('In resetShowParams');
         globalStore.showReportStartDate = 0;
         globalStore.showReportEndDate = 0;
         globalStore.showMonthStart = 0;
         globalStore.showProgramIds = 0;
         globalStore.showCocName = 0;
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
  .loadError {
    color: red
  }
</style>
