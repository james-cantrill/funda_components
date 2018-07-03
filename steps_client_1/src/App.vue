<template>
  <div id="app">

     <div style="width:900px; height:150px; margin: 0 auto;  horizontal-align: left">
        <div  style="width:24%; height:90px; display:inline-block; vertical-align: top; horizontal-align: left">
            <img src="./assets/steps_logo_small.jpg">
        </div>
        <div style="width:70%; height:90px; display:inline-block; vertical-align: top;">
            <div class="title" style=" height:70 px; width: 600px; ">STEPS Reports</div>
        </div>

    </div>
      <router-view/>

  </div>

</template>

<script>
import {globalStore} from './main.js'

export default {
  name: 'App',

  data () {
    return {
      user_name: globalStore.userFullName,
      localvar: globalStore.userLogin
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

.title {
    font-size: 70px;
    font-weight: bold;
    color: green;
    vertical-align: top;
}

</style>
