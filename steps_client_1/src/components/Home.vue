<template lang="html">
    <div>
        <h1>{{hm_msg}}</h1>
            <treeselect
                v-model="value"
                :multiple="true"
                :options="source"
            />
            <pre class="result">{{ value }}</pre>

            <form class="logout" @submit.prevent="logout">
                <button class="btn-medium" type="submit">Log Out</button>
            </form>
        </div>

</template>

<script>
/* eslint-disable */

import {globalStore} from '../main.js'
import Treeselect from '@riophae/vue-treeselect'

export default {
  name: 'Home',
  data () {
    return {
      hm_msg: 'Please Select a Report',
      localvar: globalStore.userLogin,
      value: [],
	  source: [ {
      id: 'fruits',
      label: 'Fruits',
      children: [ {
        id: 'apple',
        label: 'Apple 🍎',
      }, {
        id: 'grapes',
        label: 'Grapes 🍇',
      }, {
        id: 'pear',
        label: 'Pear 🍐',
      }, {
        id: 'strawberry',
        label: 'Strawberry 🍓',
      }, {
        id: 'watermelon',
        label: 'Watermelon 🍉',
      } ],
    }, {
      id: 'vegetables',
      label: 'Vegetables',
      children: [ {
        id: 'corn',
        label: 'Corn 🌽',
      }, {
        id: 'carrot',
        label: 'Carrot 🥕',
      }, {
        id: 'eggplant',
        label: 'Eggplant 🍆',
      }, {
        id: 'tomato',
        label: 'Tomato 🍅',
      } ],
    } ]
    }
  },

    components: { Treeselect },
    data: {
      value: [],
      source: [ {
      id: 'fruits',
      label: 'Fruits',
      children: [ {
        id: 'apple',
        label: 'Apple 🍎',
      }, {
        id: 'grapes',
        label: 'Grapes 🍇',
      }, {
        id: 'pear',
        label: 'Pear 🍐',
      }, {
        id: 'strawberry',
        label: 'Strawberry 🍓',
      }, {
        id: 'watermelon',
        label: 'Watermelon 🍉',
      } ],
    }, {
      id: 'vegetables',
      label: 'Vegetables',
      children: [ {
        id: 'corn',
        label: 'Corn 🌽',
      }, {
        id: 'carrot',
        label: 'Carrot 🥕',
      }, {
        id: 'eggplant',
        label: 'Eggplant 🍆',
      }, {
        id: 'tomato',
        label: 'Tomato 🍅',
      } ],
    } ],
    
    },

  beforeCreate() {
    console.log('global login = ' + globalStore.userLogin)
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
       console.log('in response from load_report_list');
       console.log(JSON.stringify (req));
       this.hm_msg = req.data.message;     
     },
     
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
        console.log(JSON.stringify (req));
        this.$router.replace(this.$route.query.redirect || '/');
    } 
  } 
}
</script>

<style lang="css">
</style>
