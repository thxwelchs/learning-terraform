import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
import HelloWorld from './components/HelloWorld.vue'
import HealthCheck from './components/HealthCheck.vue'

Vue.config.productionTip = false

const router = new VueRouter({
    routes: [
        {
            path: '/',
            component: HelloWorld
        },
        {
            path: '/healthz',
            component: HealthCheck
        }
    ],
    mode: 'history'
})

Vue.use(VueRouter)

new Vue({
  render: h => h(App),
  router,
}).$mount('#app')



