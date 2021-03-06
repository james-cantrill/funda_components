// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
/* eslint-disable */
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'
import VJstree from 'vue-jstree'
import BootstrapVue from 'bootstrap-vue'

import App from './App'
import router from './router'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(VueAxios, axios)
Vue.use(BootstrapVue)

Vue.config.productionTip = false

export const globalStore = new Vue({
  data: {
    userLogin: 'My Name',
    userFullName: '',
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

Vue.mixin({
  methods: {

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
        this.$router.replace(this.$route.query.redirect || '/');
    } 

  }
})

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
