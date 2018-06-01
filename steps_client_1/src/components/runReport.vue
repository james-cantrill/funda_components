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
                <br>
            </div>

            <div v-if="showMonthStart > 0" style="width:400; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionMonthStart}}</label>
                <date-picker v-model="valueMonthStart" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
            <br><br>
            </div>

            <div v-if="showQuarterStart > 0" style="width:400; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionQuarterStart}}</label>
                <date-picker v-model="valueQuarterStart" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
            <br><br>
            </div>

            <div v-if="showYearStartDate > 0" style="width:400; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionYearStartDate}}</label>
                <date-picker v-model="valueYearStartDate" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
            <br><br>
            </div>

            <div v-if="showSelectedDate > 0" style="width:400; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionSelectedDate}}</label>
                <date-picker v-model="valueSelectedDate" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
            <br><br>
            </div>

            <div v-if="showCocName > 0" style="width:200; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionCocName}}</label>
                <br>
                <input type="radio" id="one" value="NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC" v-model="valueCocName">
                <label for="one">NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC</label>
                <br>
                <input type="radio" id="two" value="NY-510 - Ithaca/Tompkins County CoC" v-model="valueCocName">
                <label for="two">NY-510 - Ithaca/Tompkins County CoC</label>
                <br>
                <input type="radio" id="two" value="NY-000" v-model="valueCocName">
                <label for="two">NY-000</label>
                <br>
            </div>

            <br>
            <div v-if="showIncludeCocFundedPrjctOnly > 0" style="width:200; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionIncludeCocFundedPrjctOnly}}</label>
                <br>
                <input type="radio" id="yes" value="Yes" v-model="valueIncludeCocFundedPrjctOnly">
                <label for="yes">Yes</label>
                <br>
                <input type="radio" id="no" value="No" v-model="valueIncludeCocFundedPrjctOnly">
                <label for="no">No</label>
                <br>
            </div>
            <br>

             <div v-if="showProgramIds > 0" style="width:500; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <div v-if="reportsLoadFailed" class="loadError">
                    <p>{{resultMsg}}</p>
                </div>
                <label>{{descriptionProgramIds}}</label>
                <v-jstree :data="program_json" @item-click="itemClick" show-checkbox multiple  options ref="tree" style="width:500px; height:400px; overflow:auto; overflow-x:auto; overflow-y:auto; " ></v-jstree>
                <br>
            </div>

            <div v-if="showAgencyName > 0" style="width:200; display:inline-block; vertical-align: top; horizontal-align: left; ">
                <br>
                <label>{{descriptionAgencyName}}</label>
                <br>
                <div  v-for="agency in agency_json" :key="agency.text" style="horizontal-align: left; ">
                    <input type="radio" v-model="valueAgencyName" :value="agency.text" > {{ agency.text }}
                </div>
                <br>
            </div>

             <div v-if="showHmisProjectTypes > 0" style="width:500; display:inline-block; vertical-align: top; horizontal-align: center; ">
                <br>
                <label>{{descriptionHmisProjectTypes}}</label>
                <v-jstree :data="project_type_json" @item-click="itemClick" show-checkbox multiple  options ref="types" style="width:500px; overflow:auto; overflow-x:auto; overflow-y:auto; " ></v-jstree>
                <br>
            </div>

            <br>
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
      agency_json: [
                    {"text": "ACCORD Corporation"},
                    {"text": "Catholic Charities of Chemung and Schuyler Counties"},
                    {"text": "Chances and Changes"},
                    {"text": "Steuben County Department of Social Services"}
                ],
      project_type_json:  
        [
            {
              "id":"a",
              "text":"Emergency Shelter",
              "value":"Emergency Shelter",
              "icon":"",
              "selected": false,
            },
            {
              "id":"b",
              "text":"Street Outreach",
              "value":"Street Outreach",
              "icon":"",
              "selected": false,
            },
            {
              "id":"c",
              "text":"PH - Permanent Supportive Housing",
              "value":"PH - Permanent Supportive Housing",
              "icon":"",
              "selected": false,
            },
            {
              "id":"d",
              "text":"PH - Rapid Re-Housing",
              "value":"PH - Rapid Re-Housing",
              "icon":"",
              "selected": false,
            },
            {
              "id":"e",
              "text":"Transitional Housing",
              "value":"Transitional Housing",
              "icon":"",
              "selected": false,
            },
            {
              "id":"f",
              "text":"Homelessness Prevention",
              "value":"Homelessness Prevention",
              "icon":"",
              "selected": false,
            },
            {
              "id":"g",
              "text":"Services Only Program",
              "value":"Services Only Program",
              "icon":"",
              "selected": false,
            }
        ],
      resultMsg: '',
      reportsLoadFailed: false,
      showReportStartDate:  globalStore.showReportStartDate,
      showReportEndDate: globalStore.showReportEndDate,
      showProgramIds: globalStore.showProgramIds,
      showMonthStart: globalStore.showMonthStart,
      showCocName: globalStore.showCocName,
      showAgencyName:  globalStore.showAgencyName,
      showCounty:  globalStore.showCounty,
      showMonthStartDate:  globalStore.showMonthStartDate,
      showQuarterStart:  globalStore.showQuarterStart,
      showYearStartDate:  globalStore.showYearStartDate,
      showSelectedDate:  globalStore.showSelectedDate,
      showHmisProjectTypes:  globalStore.showHmisProjectTypes,
      showIncludeCocFundedPrjctOnly:  globalStore.showIncludeCocFundedPrjctOnly, 
      valueReportStartDate: new Date(),
      valueReportEndDate: new Date(),
      valueProgramIds: '',
      valueMonthStart: '',
      valueCocName: '',
      valueAgencyName: '',
      valueCounty: '',
      valueMonthStartDate: new Date(),
      valuePIT_date: new Date(),
      valueQuarterStart: new Date(),
      valueYearStartDate: new Date(),
      valueSelectedDate: new Date(),
      valueHmisProjectTypes: '',
      valueIncludeCocFundedPrjctOnly: '', 
      descriptionReportStartDate: globalStore.descriptionReportStartDate,
      descriptionReportEndDate: globalStore.descriptionReportEndDate,
      descriptionProgramIds: globalStore.descriptionProgramIds,
      descriptionMonthStart: globalStore.descriptionMonthStart,
      descriptionCocName: globalStore.descriptionCocName,
      descriptionAgencyName:  globalStore.descriptionAgencyName,
      descriptionCounty:  globalStore.descriptionCounty,
      descriptionMonthStartDate:  globalStore.descriptionMonthStartDate,
      descriptionPIT_date:  globalStore.descriptionPIT_date,
      descriptionQuarterStart:  globalStore.descriptionQuarterStart,
      descriptionYearStartDate:  globalStore.descriptionYearStartDate,
      descriptionSelectedDate:  globalStore.descriptionSelectedDate,
      descriptionHmisProjectTypes:  globalStore.descriptionHmisProjectTypes,
      descriptionIncludeCocFundedPrjctOnly:  globalStore.descriptionIncludeCocFundedPrjctOnly,
      programIds: '',
      hmisProjectTypes: ''
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
        console.log ('in runreport method');
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
        if (this.showHmisProjectTypes > 0) {
            this.$refs.types.handleRecursionNodeChilds(this.$refs.types, node => {
                if (node.model.selected == true) {;
                    if (this.hmisProjectTypes < 4 ) {
                        this.hmisProjectTypes = node.model.text;
                    } else {
                        this.hmisProjectTypes = this.hmisProjectTypes + ',' + node.model.text
                    };
                    
                };
            });
        };
        var rptMonthStart;
        var rptQuarterStart;
        var rptYearStartDate;
        var rptSelectedDate;
        var rptStartDate;
        var rptEndDate;
        if (this.showReportStartDate > 0) {
            rptStartDate = (new Date(this.valueReportStartDate)).toISOString().substring(0, 10)
        };
        if (this.showReportEndDate > 0) {
            rptEndDate = (new Date(this.valueReportEndDate)).toISOString().substring(0, 10)
        };
        if (this.showMonthStart > 0) {
            rptMonthStart = (new Date(this.valueMonthStart)).toISOString().substring(0, 10)
        };
        if (this.showQuarterStart > 0) {
            rptQuarterStart = (new Date(this.valueQuarterStart)).toISOString().substring(0, 10)
        };
        if (this.showYearStartDate > 0) {
            rptYearStartDate = (new Date(this.valueYearStartDate)).toISOString().substring(0, 10)
        };
        if (this.showSelectedDate > 0) {
            rptSelectedDate = (new Date(this.valueSelectedDate)).toISOString().substring(0, 10)
        };
        var progIds = this.programIds;
        var projectTypes = this.hmisProjectTypes;
        var rptCoc = this.valueCocName;
        var rptAgencyName = this.valueAgencyName
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
            case 'QuarterStart':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptQuarterStart;
              break;
            case 'YearStartDate':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptYearStartDate;
              break;
            case 'SelectedDate':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptSelectedDate;
              break;
            case 'ProgramIds':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + progIds;
              break;
            case 'HmisProjectTypes':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + projectTypes;
              break;
            case 'CocName':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptCoc;
              break;
            case 'AgencyName':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + rptAgencyName;
              break;
            case 'IncludeCocFundedPrjctOnly':
              rptURl = rptURl + '&' + parameter.parameter_name + '=' + this.valueIncludeCocFundedPrjctOnly;
              break;
        };
    });
      console.log ('rptURl = ' + rptURl);
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
