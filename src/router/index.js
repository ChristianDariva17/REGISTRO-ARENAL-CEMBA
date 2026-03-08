import { createRouter, createWebHistory } from 'vue-router'
import ContactForm from '../components/ContactForm.vue'
import RecordsView from '../components/RecordsView.vue'

const routes = [
  { path: '/',          component: ContactForm },
  { path: '/registros', component: RecordsView }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
