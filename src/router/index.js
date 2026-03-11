import { createRouter, createWebHistory } from 'vue-router'
import ContactForm        from '../components/ContactForm.vue'
import RecordsView        from '../components/RecordsView.vue'
import ComplaintsForm     from '../components/ComplaintsForm.vue'
import ReclamacionesView  from '../components/ReclamacionesView.vue'

const routes = [
  { path: '/',                   component: ContactForm },
  { path: '/registros',          component: RecordsView },
  { path: '/reclamaciones',      component: ComplaintsForm },
  { path: '/ver-reclamaciones',  component: ReclamacionesView },
]

export default createRouter({
  history: createWebHistory(),
  routes
})
