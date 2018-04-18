// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
/* eslint-disable */
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'

import App from './App'
import router from './router'

Vue.use(VueAxios, axios)

Vue.config.productionTip = false

export const globalStore = new Vue({
  data: {
    userLogin: 'My Name'
  }
})

//Vue.prototype.$userLogin = 'My Name';

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  components: { App },
  template: '<App/>'
})