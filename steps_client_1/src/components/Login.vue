<template lang="html">
    <div>
        <h1>{{msg}}</h1>

            <form action="/system_user_manager/user_login" method="get" class="form-signin">
                <div>
                    <label>Username</label>
                    <br>
                    <input type="text" name="username" placeholder="" class="input-block-level">
                    <br><br>
                </div>
                <div>
                    <label>Password</label>
                    <br>
                    <input type="password" name="password" placeholder="" class="input-block-level">
                    <br><br>
                </div>
                <div class="row">
                    <button type="submit" class="btn btn-large btn-primary">Sign in </button>
                </div>
            </form>
        </div>
</template>

<script>

export default {
  name: 'Login',
  data () {
    return {
      msg: 'Welcome to STEPS Reports'
    }
  }
}
</script>

<style lang="css">
</style>
