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
                <textarea v-model="itemDescription" style="height:250px; width:100%; border: double green;">
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
      this.reportSelected = 'FALSE'
      this.reportName = ''
      this.editingNode = node
      this.editingItem = node.model
      this.itemDescription = node.model.value
      this.reportName = node.model.text
      this.reportId = node.model.id
      if (node.model.icon == 'folder') {
        this.reportSelected = 'FALSE'
        this.runMsg = ''
      } else {
        if (node.model.icon == 'report') {
          this.reportSelected = 'TRUE'
          this.runMsg = 'Open ' + this.reportName
        }
      }
    },

     loadReport () {      
       var rptUrl ='http://localhost:4000/report_manager/load_selected_report?login=' + globalStore.userLogin + '&report_id=' + this.reportId 
      this.axios.get(rptUrl)
        .then(request => this.reportLoaded(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },

     reportLoaded (req) {
        var numParams = req.data.parameters.length;
        var paramName;
        this.resetShowParams ();
        globalStore.reportName = req.data.report_name;
        globalStore.reportUrl = req.data.url;
        globalStore.reportParams = req.data.parameters;
        globalStore.reportParams.forEach(function(parameter){
            switch (parameter.parameter_name) {
                case 'ReportStartDate':
                  globalStore.showReportStartDate = 1;
                  globalStore.descriptionReportStartDate = parameter.parameter_description;
                  break;
                case 'ReportEndDate':
                  globalStore.showReportEndDate = 1;
                  globalStore.descriptionReportEndDate = parameter.parameter_description;
                  break;
                case 'MonthStart':
                  globalStore.showMonthStart = 1;
                  globalStore.descriptionMonthStart = parameter.parameter_description;
                  break;
                case 'ProgramIds':
                  globalStore.showProgramIds = 1;
                  globalStore.descriptionProgramIds = parameter.parameter_description;
                  break;
                case 'CocName':
                  globalStore.showCocName = 1;
                  globalStore.descriptionCocName = parameter.parameter_description;
                  break;
                case 'AgencyName':
                  globalStore.showAgencyName = 1;
                  globalStore.descriptionAgencyName = parameter.parameter_description;
                  break;
                case 'County':
                  globalStore.showCounty = 1;
                  globalStore.descriptionCounty = parameter.parameter_description;
                  break;
                case 'MonthStartDate':
                  globalStore.showMonthStartDate = 1;
                  globalStore.descriptionMonthStartDate = parameter.parameter_description;
                  break;
                case 'PIT_date':
                  globalStore.showPIT_date = 1;
                  globalStore.descriptionPIT_date = parameter.parameter_description;
                  break;
                case 'QuarterStart':
                  globalStore.showQuarterStart = 1;
                  globalStore.descriptionQuarterStart = parameter.parameter_description;
                  break;
                case 'YearStartDate':
                  globalStore.showYearStartDate = 1;
                  globalStore.descriptionYearStartDate = parameter.parameter_description;
                  break;
                case 'SelectedDate':
                  globalStore.showSelectedDate = 1;
                  globalStore.descriptionSelectedDate = parameter.parameter_description;
                  break;
                case 'HmisProjectTypes':
                  globalStore.showHmisProjectTypes = 1;
                  globalStore.descriptionHmisProjectTypes = parameter.parameter_description;
                  break;
                case 'IncludeCocFundedPrjctOnly':
                  globalStore.showIncludeCocFundedPrjctOnly = 1;
                  globalStore.descriptionIncludeCocFundedPrjctOnly = parameter.parameter_description;
                  break;
              };
        });
        console.log ('reportParams = ' + JSON.stringify(globalStore.reportParams));
        this.$router.replace(this.$route.query.redirect || '/runReport');
    },

    resetShowParams () {
         globalStore.showReportStartDate = 0;
         globalStore.showReportEndDate = 0;
         globalStore.showMonthStart = 0;
         globalStore.showProgramIds = 0;
         globalStore.showCocName = 0;         
         globalStore.showAgencyName = 0;
         globalStore.showCounty = 0;
         globalStore.showMonthStartDate = 0;
         globalStore.showPIT_date = 0;
         globalStore.showQuarterStart = 0;
         globalStore.showYearStartDate = 0;
         globalStore.showSelectedDate = 0;
         globalStore.showHmisProjectTypes = 0;
         globalStore.showIncludeCocFundedPrjctOnly = 0;
    },
     
/*    logout () {      
      this.axios.get('http://localhost:3000/system_user_manager/user_logout?login=' + globalStore.userLogin)
        .then(request => this.logoutSuccessful(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },
     
    logoutSuccessful (req) {
        this.msg = req.data.message;
        this.$router.replace(this.$route.query.redirect || '/');
    } */
  } 
}
</script>

<style lang="css">
  .loadError {
    color: red
  }
</style>
