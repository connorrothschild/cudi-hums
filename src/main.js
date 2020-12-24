import Vue from 'vue';
import './../node_modules/bulma/css/bulma.css';
import { ObserveVisibility } from 'vue-observe-visibility';

import App from './App.vue';

Vue.directive('observe-visibility', ObserveVisibility);

Vue.config.productionTip = false;

new Vue({
	render : (h) => h(App)
}).$mount('#app');
