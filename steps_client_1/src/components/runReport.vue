<template lang="html">
    <div>
        <h2>{{run_msg}}</h2>

            <div v-if="showReportStartDate > 0" style="width:400; display:inline-block; vertical-align: top;">
                <div  style="width:47%; display:inline-block; vertical-align: top; horizontal-align: center; ">
                    <label>{{descriptionReportStartDate}}</label>
                    <date-picker v-model="valueReportStartDate" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
                </div>
                <div  style="width:47%; display:inline-block; vertical-align: top; horizontal-align: center; ">
                    <label>{{descriptionReportEndDate}}</label>
                    <date-picker v-model="valueReportEndDate" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
                </div>
            </div>

            <div v-if="showMonthStart > 0" style="width:400; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <label>{{descriptionMonthStart}}</label>
                <date-picker v-model="valueMonthStart" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
            </div>
            <br><br>
            <div v-if="showCocName > 0" style="width:200; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <label>{{descriptionCocName}}</label>
                <textarea >List of Coc names is here</textarea>
            </div>

            <div v-if="showProgramIds > 0" style="width:500; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <div v-if="reportsLoadFailed" class="loadError">
                    <p>{{resultMsg}}</p>
                </div>
                <label>{{descriptionProgramIds}}</label>
                <v-jstree :data="program_json" @item-click="itemClick" show-checkbox multiple  options ref="tree" style="width:500px; height:400px; overflow:auto; overflow-x:auto; overflow-y:auto; " ></v-jstree>
            </div>

            <br><br>
            <div style="width:500px; margin: 0 auto; horizontal-align: center;">
              <div style="width:33%; display:inline-block; vertical-align: top; ">
                <form class="runReport" @submit.prevent="runReport">
                  <button class="btn-large" type="submit">Run Report</button>
                </form>
              </div>

              <div style="width:32%; display:inline-block; vertical-align: top; ">
                <form class="cancel" @submit.prevent="cancel">
                  <button class="btn-large" type="submit">Cancel</button>
                </form>
              </div>

              <div style="width:33%; display:inline-block; vertical-align: top; ">
                <form class="logout" @submit.prevent="logout">
                  <button class="btn-medium" type="submit">Log Out</button>
                </form>
              </div>
            </div>

    </div>

</template>

<script>
/* eslint-disable */

import {globalStore} from '../main.js'
import DatePicker from 'vue2-datepicker'
import VJstree from 'vue-jstree'

export default {
  name: 'runReport',
  data () {
    return {
      run_msg: ' ' + globalStore.reportName,
      localvar: globalStore.userLogin,
      program_json: [],
      resultMsg: '',
      reportsLoadFailed: false,
      showReportStartDate:  globalStore.showReportStartDate,
      showReportEndDate: globalStore.showReportEndDate,
      showProgramIds: globalStore.showProgramIds,
      showMonthStart: globalStore.showMonthStart,
      showCocName: globalStore.showCocName,
      valueReportStartDate: new Date(),
      valueReportEndDate: new Date(),
      valueProgramIds: '',
      valueMonthStart: '',
      valueCocName: '',
      descriptionReportStartDate: globalStore.descriptionReportStartDate,
      descriptionReportEndDate: globalStore.descriptionReportEndDate,
      descriptionProgramIds: globalStore.descriptionProgramIds,
      descriptionMonthStart: globalStore.descriptionMonthStart,
      descriptionCocName: globalStore.descriptionCocName,
      programIds: ''
    }
  },

  components: { 
      DatePicker,
      VJstree
    },

  created() {
    console.log('In runReport.created ');
    console.log ('showProgramIds = ' + this.showProgramIds);
    if (this.showProgramIds > 0) {
        this.axios.get('http://localhost:5000/programs_manager/load_program_list?login=' + globalStore.userLogin)
      .then(request => this.programsReturned(request))
          .catch(function (error) {
            console.log(error);
          });
    };
  },
  
  methods: {  

   itemClick (node) {
      console.log('node.model.text = ' + node.model.text);
      
    },

    programsReturned (req) {
        console.log('In programsReturned');
      if (req.data.result_indicator == 'Failure'){
           this.resultMsg = req.data.message;
           this.reportsLoadFailed = true
      } else {
          this.program_json = JSON.parse(JSON.stringify (req.data.data));
      }
        
    },

    logout () {      
      this.axios.get('http://localhost:3000/system_user_manager/user_logout?login=' + globalStore.userLogin)
        .then(request => this.logoutSuccessful(request))
        .catch(function (error) {
          console.log('in error')
          console.log(JSON.stringify(error))
        })
    },

    cancel () {      
      this.$router.replace(this.$route.query.redirect || '/Home');
    },

    runReport () {      
        console.log ('in runreport metnhod');
        if (this.showProgramIds > 0) {
            this.$refs.tree.handleRecursionNodeChilds(this.$refs.tree, node => {
                if (node.model.selected == true) {;
                    if (this.programIds < 4 ) {
                        this.programIds = node.model.id;
                    } else {
                        this.programIds = this.programIds + ', ' + node.model.id
                    };
                    
                };
            });
        };
        var rptMonthStart;
        var rptStartDate =  (new Date(this.valueReportStartDate)).toISOString().substring(0, 10);
        var rptEndDate = (new Date(this.valueReportEndDate)).toISOString().substring(0, 10);
        if (this.showMonthStart > 0) {
            rptMonthStart = (new Date(this.valueMonthStart)).toISOString().substring(0, 10)
        };
        var progIds = this.programIds;
        var rptCoc = this.valueCocName;
        var rptURl = globalStore.reportUrl
        globalStore.reportParams.forEach(function(parameter){
        switch (parameter.parameter_name) {
            case 'ReportStartDate':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptStartDate;
              break;
            case 'ReportEndDate':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptEndDate;
              break;
            case 'MonthStart':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptMonthStart;
              break;
            case 'ProgramIds':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + progIds;
              break;
            case 'CocName':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptCoc;
              break;
        };
    });                                                                
      window.open(rptURl);  
      this.$router.replace(this.$route.query.redirect || '/Home');
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
 
 label {
     font-weight: bold;
     color: black;
 }
 
 
 
</style>
