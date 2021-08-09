import Vue from 'vue/dist/vue.js';
import * as uiv from 'uiv/dist/uiv.common'
import axios from 'axios/dist/axios'

Vue.use(uiv)
Vue.use({
  install(Vue) {
    Vue.prototype.$http = axios;
  }
})
