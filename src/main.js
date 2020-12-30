import Vue from 'vue';
import './../node_modules/bulma/css/bulma.css';
import Buefy from 'buefy';
import 'buefy/dist/buefy.css';

Vue.use(Buefy);

import App from './App.vue';

Vue.config.productionTip = false;

new Vue({
	render : (h) => h(App)
}).$mount('#app');
