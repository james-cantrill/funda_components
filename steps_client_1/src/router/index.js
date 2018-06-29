import Vue from 'vue'
import Router from 'vue-router'

import Login from '@/components/Login'
import Home from '@/components/Home'
import runReport from '@/components/runReport'
import changePword from '@/components/changePword'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Login',
      component: Login
    },
    {
      path: '/home',
      name: 'Home',
      component: Home
    },
    {
      path: '/runReport',
      name: 'runReport',
      component: runReport
    },
    {
      path: '/changePword',
      name: 'changePword',
      component: changePword
    }
  ]
})
