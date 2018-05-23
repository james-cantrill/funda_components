<template lang="html">
    <div>
        <h2>{{run_msg}}</h2>

            <div v-if="showReportStartDate > 0" style="width:400; display:inline-block; vertical-align: top; border: dotted red;">
				<div  style="width:47%; display:inline-block; vertical-align: top; horizontal-align: center; border: dotted green;">
					<label>{{descriptionReportStartDate}}</label>
					<date-picker v-model="valueReportStartDate" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
				</div>
				<div  style="width:47%; display:inline-block; vertical-align: top; horizontal-align: center; border: dotted blue;">
					<label>{{descriptionReportEndDate}}</label>
					<date-picker v-model="valueReportStartDate" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
				</div>
            </div>
			
            <div v-if="showMonthStart > 0" style="width:400; display:inline-block; vertical-align: top; horizontal-align: center; border: dashed red;">
				<label>{{descriptionMonthStart}}</label>
				<date-picker v-model="valueMonthStart" type="date" format="yyyy-MM-dd" lang="en"></date-picker>
            </div>
            <br><br>
            <div v-if="showCocName > 0" style="width:200; display:inline-block; vertical-align: top; horizontal-align: center; border: dashed yellow;">
				<label>{{descriptionCocName}}</label>
				<textarea >List of Coc names is here</textarea>
			</div>

            <div v-if="showProgramIds > 0" style="width:500; display:inline-block; vertical-align: top; horizontal-align: center; border: solid blue;">
                <label>{{descriptionProgramIds}}</label>
                <v-jstree :data="program_json" @item-click="itemClick" style="width:500px; height:400px; overflow:auto; overflow-x:auto; overflow-y:auto; border: solid red;" ></v-jstree>
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
      run_msg: 'Running ' + globalStore.reportName + ' for ' + globalStore.userFullName,
      localvar: globalStore.userLogin,
      program_json: [],
      showReportStartDate:  globalStore.showReportStartDate,
      showReportEndDate: globalStore.showReportEndDate,
      showProgramIds: globalStore.showProgramIds,
      showMonthStart: globalStore.showMonthStart,
      showCocName: globalStore.showCocName,
      valueReportStartDate: '',
      valueReportEndDate: '',
      valueProgramIds: '',
      valueMonthStart: '',
      valueCocName: '',
      descriptionReportStartDate: globalStore.descriptionReportStartDate,
      descriptionReportEndDate: globalStore.descriptionReportEndDate,
      descriptionProgramIds: globalStore.descriptionProgramIds,
      descriptionMonthStart: globalStore.descriptionMonthStart,
      descriptionCocName: globalStore.descriptionCocName,
      value1: 'Value1'
    }
  },

  components: { 
      DatePicker,
      VJstree
    },

  created() {
    console.log('report name= ' + globalStore.reportName);
    console.log (this.showProgramIds);
  },
  
  methods: {  

   itemClick (node) {
      console.log('node.model.icon = ')
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
      console.log('report url = ' + globalStore.reportUrl);     
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
