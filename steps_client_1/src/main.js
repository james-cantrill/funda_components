// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
/* eslint-disable */
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VJstree from 'vue-jstree'

import App from './App'
import router from './router'

Vue.use(VueAxios, axios)

Vue.config.productionTip = false

export const globalStore = new Vue({
  data: {
    userLogin: 'My Name',
    userFullName: 'John Doe',
    reportName: '',
    reportParams:    [
                        {
                            parameter_name: '',
                            parameter_description: '',
                            parameter_value: ''
                        }
                    ],
    reportUrl: '',
    showReportStartDate: 0,
    showReportEndDate: 0,
    showProgramIds: 0,
    showMonthStart: 0,
    showCocName: 0,
    showAgencyName: 0,
    showCounty: 0,
    showMonthStartDate: 0,
    showPIT_date: 0,
    showQuarterStart: 0,
    showYearStartDate: 0,
    showSelectedDate: 0,
    showHmisProjectTypes: 0,
    showIncludeCocFundedPrjctOnly: 0,
    descriptionReportStartDate: '',
    descriptionReportEndDate: '',
    descriptionProgramIds: '',
    descriptionMonthStart: '',
    descriptionCocName: '',
    descriptionAgencyName: '',
    descriptionCounty: '',
    descriptionMonthStartDate: '',
    descriptionPIT_date: '',
    descriptionQuarterStart: '',
    descriptionYearStartDate: '',
    descriptionSelectedDate: '',
    descriptionHmisProjectTypes: '',
    descriptionIncludeCocFundedPrjctOnly: ''
  }
})

//Vue.prototype.$userLogin = 'My Name';

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { 
      App, 
      VJstree
    },

  template: '<App/>'
})
