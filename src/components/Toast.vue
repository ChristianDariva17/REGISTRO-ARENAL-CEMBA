<template>
  <teleport to="body">
    <transition name="toast-slide">
      <div v-if="visible" class="toast-wrap" :class="`toast-wrap--${type}`" role="alert">
        <!-- Icon -->
        <div class="toast-icon">
          <!-- Success -->
          <svg v-if="type === 'success'" xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
            <path fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
              clip-rule="evenodd"/>
          </svg>
          <!-- Error -->
          <svg v-else xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
            <path fill-rule="evenodd"
              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z"
              clip-rule="evenodd"/>
          </svg>
        </div>

        <!-- Body -->
        <div class="toast-body">
          <p class="toast-title">{{ type === 'success' ? '¡Éxito!' : 'Error' }}</p>
          <p class="toast-message">{{ message }}</p>
        </div>

        <!-- Progress bar -->
        <div class="toast-progress" :style="{ animationDuration: duration + 'ms' }"></div>

        <!-- Close -->
        <button class="toast-close" @click="dismiss" aria-label="Cerrar">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"
            fill="currentColor" width="14" height="14">
            <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0
              101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06
              10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"/>
          </svg>
        </button>
      </div>
    </transition>
  </teleport>
</template>

<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
  message:  { type: String,  default: '' },
  type:     { type: String,  default: 'success' }, // 'success' | 'error'
  duration: { type: Number,  default: 4500 },
})

const emit = defineEmits(['dismissed'])

const visible = ref(false)
let timer = null

function show () {
  visible.value = true
  clearTimeout(timer)
  timer = setTimeout(dismiss, props.duration)
}

function dismiss () {
  clearTimeout(timer)
  visible.value = false
  emit('dismissed')
}

// Show whenever message changes to a non-empty string
watch(() => props.message, (val) => {
  if (val) show()
})

defineExpose({ show, dismiss })
</script>

<style>
/* Global — not scoped so Teleport works */
.toast-wrap {
  position: fixed;
  top: 1.25rem;
  right: 1.25rem;
  z-index: 9999;
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  width: clamp(280px, 90vw, 420px);
  padding: 1rem 1rem 0;
  border-radius: 14px;
  box-shadow: 0 8px 32px rgba(0,0,0,0.18), 0 2px 8px rgba(0,0,0,0.08);
  overflow: hidden;
  font-family: 'Inter', 'Segoe UI', sans-serif;
  backdrop-filter: blur(8px);
}

/* Success */
.toast-wrap--success {
  background: linear-gradient(135deg, #ecfdf5, #d1fae5);
  border: 1.5px solid #6ee7b7;
  color: #065f46;
}
.toast-wrap--success .toast-icon { color: #10b981; }
.toast-wrap--success .toast-progress { background: #10b981; }

/* Error */
.toast-wrap--error {
  background: linear-gradient(135deg, #fff1f2, #ffe4e6);
  border: 1.5px solid #fda4af;
  color: #9f1239;
}
.toast-wrap--error .toast-icon { color: #f43f5e; }
.toast-wrap--error .toast-progress { background: #f43f5e; }

/* Icon */
.toast-icon {
  flex-shrink: 0;
  margin-top: 0.1rem;
}

/* Body */
.toast-body {
  flex: 1;
  padding-bottom: 0.9rem;
}
.toast-title {
  font-size: 0.85rem;
  font-weight: 800;
  margin: 0 0 0.2rem;
  letter-spacing: 0.2px;
}
.toast-message {
  font-size: 0.8rem;
  font-weight: 500;
  margin: 0;
  line-height: 1.5;
}

/* Close button */
.toast-close {
  flex-shrink: 0;
  background: none;
  border: none;
  cursor: pointer;
  color: inherit;
  opacity: 0.6;
  padding: 0;
  margin-top: 0.1rem;
  transition: opacity 0.15s;
}
.toast-close:hover { opacity: 1; }

/* Progress bar */
.toast-progress {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  width: 100%;
  border-radius: 0 0 14px 14px;
  transform-origin: left;
  animation: toast-shrink linear forwards;
}

@keyframes toast-shrink {
  from { transform: scaleX(1); }
  to   { transform: scaleX(0); }
}

/* Slide animation */
.toast-slide-enter-active {
  transition: transform 0.32s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.25s;
}
.toast-slide-leave-active {
  transition: transform 0.22s ease-in, opacity 0.22s;
}
.toast-slide-enter-from  { transform: translateX(calc(100% + 1.25rem)); opacity: 0; }
.toast-slide-leave-to    { transform: translateX(calc(100% + 1.25rem)); opacity: 0; }
</style>
