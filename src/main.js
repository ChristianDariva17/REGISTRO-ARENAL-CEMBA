import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router/index.js'
import { createGtag } from "vue-gtag";

const app = createApp(App)

// 2. Configura VueGtag (Versión 3.x)
app.use(createGtag({
  config: { 
    id: import.meta.env.VITE_GA_MEASUREMENT_ID 
  },
  pageTracker: {
    router
  }
}));

app.use(router);    
app.mount('#app');
