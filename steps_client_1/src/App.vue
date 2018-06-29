<template>
  <div id="app">

     <div style="width:900px; height:150px; margin: 0 auto;  horizontal-align: left">
        <div  style="width:24%; height:90px; display:inline-block; vertical-align: top; horizontal-align: left">
            <img src="./assets/steps_logo_small.jpg">
        </div>
        <div style="width:70%; height:90px; display:inline-block; vertical-align: top;">
            <div class="title" style=" height:70 px; width: 600px; ">STEPS Reports</div>
        </div>

        <b-navbar toggleable="md" type="light" variant="light">

          <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

          <b-navbar-brand href="#">NavBar</b-navbar-brand>

          <b-collapse is-nav id="nav_collapse">

            <b-navbar-nav>
              <b-nav-item to="home" variant="primary">Home</b-nav-item>
              <b-nav-item href="#" disabled>Disabled</b-nav-item>
            </b-navbar-nav>

            <!-- Right aligned nav items -->
            <b-navbar-nav class="ml-auto">

              <b-nav-item-dropdown text="Lang" right>
                <b-dropdown-item href="#">EN</b-dropdown-item>
                <b-dropdown-item href="#">ES</b-dropdown-item>
                <b-dropdown-item href="#">RU</b-dropdown-item>
                <b-dropdown-item href="#">FA</b-dropdown-item>
              </b-nav-item-dropdown>

              <b-nav-item-dropdown right>
                <!-- Using button-content slot -->
                <template slot="button-content">
                  <em>User</em>
                </template>
                <b-dropdown-item v-bind:to="'changePword'" href="#" >Change Password</b-dropdown-item>
                <b-dropdown-item href="#" v-on:click="logout ()">Signout</b-dropdown-item>
              </b-nav-item-dropdown>
            </b-navbar-nav>

          </b-collapse>
        </b-navbar>
      <p>  </p><br><br>
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
