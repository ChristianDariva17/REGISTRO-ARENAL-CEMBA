<template>
  <nav class="app-nav">
    <span class="app-nav__brand">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="18" height="18">
        <path fill-rule="evenodd" d="M9.293 2.293a1 1 0 011.414 0l7 7A1 1 0 0117 11h-1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-3a1 1 0 00-1-1H9a1 1 0 00-1 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-6H3a1 1 0 01-.707-1.707l7-7z" clip-rule="evenodd"/>
      </svg>
      CEMBA
    </span>
    <div class="app-nav__links">
      <RouterLink to="/" class="app-nav__link">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
          <path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3zM3.31 9.397L5 10.12v4.102a8.969 8.969 0 00-1.05-.174 1 1 0 01-.89-.89 11.115 11.115 0 01.25-3.762zm5.99 7.176A9.026 9.026 0 007 14.935v-3.957l1.818.78a3 3 0 002.364 0l5.508-2.361a11.026 11.026 0 01.25 3.762 1 1 0 01-.89.89 8.968 8.968 0 00-5.35 2.524 1 1 0 01-1.4 0zM6 18a1 1 0 001-1v-2.065a8.935 8.935 0 00-2-.712V17a1 1 0 001 1z"/>
        </svg>
        Formulario
      </RouterLink>
      <RouterLink to="/registros" class="app-nav__link">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
          <path fill-rule="evenodd" d="M2 4.75A.75.75 0 012.75 4h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 4.75zm0 10.5a.75.75 0 01.75-.75h7.5a.75.75 0 010 1.5h-7.5a.75.75 0 01-.75-.75zM2 10a.75.75 0 01.75-.75h14.5a.75.75 0 010 1.5H2.75A.75.75 0 012 10z" clip-rule="evenodd"/>
        </svg>
        Ver Registros
      </RouterLink>
      <RouterLink to="/reclamaciones" class="app-nav__link">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a.75.75 0 000 1.5h.253a.25.25 0 01.244.304l-.459 2.066A1.75 1.75 0 0010.747 15H11a.75.75 0 000-1.5h-.253a.25.25 0 01-.244-.304l.459-2.066A1.75 1.75 0 009.253 9H9z" clip-rule="evenodd"/>
        </svg>
        Reclamaciones
      </RouterLink>
      <RouterLink to="/ver-reclamaciones" class="app-nav__link">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
          <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v4a1 1 0 11-2 0V8zm4-1a1 1 0 00-1 1v4a1 1 0 002 0V8a1 1 0 00-1-1z" clip-rule="evenodd"/>
        </svg>
        Ver Reclamos
      </RouterLink>
    </div>
  </nav>
  <RouterView />
</template>

<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<style>
.app-nav {
  position: sticky;
  top: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.65rem 1.5rem;
  background: linear-gradient(135deg, #1e3a8a, #1d4ed8);
  box-shadow: 0 2px 10px rgba(30, 58, 138, 0.35);
  font-family: 'Inter', 'Segoe UI', sans-serif;
}

.app-nav__brand {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  color: #fff;
  font-weight: 800;
  font-size: 0.95rem;
  letter-spacing: 1px;
}

.app-nav__links {
  display: flex;
  gap: 0.5rem;
}

.app-nav__link {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  color: rgba(255,255,255,0.8);
  text-decoration: none;
  font-size: 0.82rem;
  font-weight: 600;
  padding: 0.4rem 0.85rem;
  border-radius: 8px;
  transition: background 0.2s, color 0.2s;
}

.app-nav__link:hover {
  background: rgba(255,255,255,0.15);
  color: #fff;
}

.app-nav__link.router-link-active {
  background: rgba(255,255,255,0.2);
  color: #fff;
}
</style>
