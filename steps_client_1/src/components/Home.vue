<template lang="html">
    <div>
        <h1>{{hm_msg}}</h1>

            <form class="logout" action="/system_user_manager/user_logout" method="get">
                <button class="btn-medium" type="submit">Log Out</button>
            </form>
        </div>
</template>

<script>

export default {
  name: 'Home',
  data () {
    return {
      hm_msg: ''
    }
  }
}
</script>

<style lang="css">
</style>
