<template>
  <div class="form-container">
    <div class="form-card">

      <!-- Toast global -->
      <Toast :message="successMessage" type="success" @dismissed="successMessage = ''" />
      <Toast :message="errorMessage"   type="error"   @dismissed="errorMessage = ''" />

      <!-- Encabezado -->
      <div class="form-header">
        <h1>Registro de Control de Limpieza</h1>
        <p class="subtitle">I.E.F El Arenal – CEMBA</p>

        <!-- Logo + vista previa de la foto subida -->
        <div class="header-image-area">
          <img
            :src="'/cemba.webp'"
            class="header-img"
          />
        </div>
      </div>



      <form @submit.prevent="handleSubmit" class="form" novalidate>

        <!-- Fecha y Hora (automáticos) -->
        <div class="date-time-row">
          <div class="date-time-chip">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75z" clip-rule="evenodd"/>
            </svg>
            <span>{{ fechaActual }}</span>
          </div>
          <div class="date-time-chip">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm.75-13a.75.75 0 00-1.5 0v5c0 .414.336.75.75.75h4a.75.75 0 000-1.5h-3.25V5z" clip-rule="evenodd"/>
            </svg>
            <span>{{ horaActual }}</span>
          </div>
        </div>

        <!-- Área -->
        <div class="field-group" :class="{ 'has-error': errors.area }">
          <label for="area">Área</label>
          <div class="input-wrapper">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="input-icon">
              <path fill-rule="evenodd" d="M9.293 2.293a1 1 0 011.414 0l7 7A1 1 0 0117 11h-1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-3a1 1 0 00-1-1H9a1 1 0 00-1 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-6H3a1 1 0 01-.707-1.707l7-7z" clip-rule="evenodd"/>
            </svg>
            <input id="area" v-model.trim="form.area" type="text" placeholder="Ej. Aula 101, Biblioteca, Patio..."/>
          </div>
          <span class="error-msg" v-if="errors.area">{{ errors.area }}</span>
        </div>

        <!-- Grado y Sección (campo único combinado) -->
        <div class="field-group" :class="{ 'has-error': errors.grado_seccion }">
          <label for="grado_seccion">Grado y Sección</label>
          <div class="input-wrapper">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="input-icon">
              <path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3zM3.31 9.397L5 10.12v4.102a8.969 8.969 0 00-1.05-.174 1 1 0 01-.89-.89 11.115 11.115 0 01.25-3.762zm5.99 7.176A9.026 9.026 0 007 14.935v-3.957l1.818.78a3 3 0 002.364 0l5.508-2.361a11.026 11.026 0 01.25 3.762 1 1 0 01-.89.89 8.968 8.968 0 00-5.35 2.524 1 1 0 01-1.4 0zM6 18a1 1 0 001-1v-2.065a8.935 8.935 0 00-2-.712V17a1 1 0 001 1z"/>
            </svg>
            <input
              id="grado_seccion"
              v-model.trim="form.grado_seccion"
              type="text"
              placeholder="Ej. 2°A, 3°B, 1°C..."
              autocomplete="off"
            />
          </div>
          <p class="field-hint">Escribe el grado y la sección juntos, p.ej. <strong>2°A</strong></p>
          <span class="error-msg" v-if="errors.grado_seccion">{{ errors.grado_seccion }}</span>
        </div>

        <!-- Docente Responsable -->
        <div class="field-group" :class="{ 'has-error': errors.docente }">
          <label for="docente">Docente Responsable</label>
          <div class="input-wrapper">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="input-icon">
              <path d="M10 8a3 3 0 100-6 3 3 0 000 6zM3.465 14.493a1.23 1.23 0 00.41 1.412A9.957 9.957 0 0010 18c2.31 0 4.438-.784 6.131-2.1.43-.333.604-.903.408-1.41a7.002 7.002 0 00-13.074.003z"/>
            </svg>
            <input id="docente" v-model.trim="form.docente" type="text" placeholder="Nombre completo del docente" autocomplete="name"/>
          </div>
          <span class="error-msg" v-if="errors.docente">{{ errors.docente }}</span>
        </div>

        <!-- Tareas Realizadas -->
        <div class="field-group" :class="{ 'has-error': errors.tarea_realizada }">
          <label for="tarea_realizada">Tareas Realizadas</label>
          <textarea
            id="tarea_realizada"
            v-model.trim="form.tarea_realizada"
            rows="4"
            placeholder="Describe las tareas de limpieza realizadas..."
          ></textarea>
          <div class="char-count" :class="{ warning: form.tarea_realizada.length > 450 }">
            {{ form.tarea_realizada.length }} / 500
          </div>
          <span class="error-msg" v-if="errors.tarea_realizada">{{ errors.tarea_realizada }}</span>
        </div>

        <!-- Foto de Evidencia -->
        <div class="field-group" :class="{ 'has-error': errors.evidencia }">
          <label>Foto de Evidencia</label>
          <div
            class="upload-zone"
            :class="{ 'upload-zone--active': isDragging, 'upload-zone--filled': previewUrl }"
            @dragover.prevent="isDragging = true"
            @dragleave.prevent="isDragging = false"
            @drop.prevent="onDrop"
            @click="!previewUrl && $refs.fileInput.click()"
          >
            <input ref="fileInput" type="file" accept="image/*" class="file-input-hidden" @change="onFileChange"/>

            <!-- Vista previa dentro de la zona de carga -->
            <div v-if="previewUrl" class="upload-preview-state">
              <img :src="previewUrl" alt="Vista previa" class="inline-preview-img" />
              <p class="inline-preview-name">{{ selectedFile?.name }}</p>
              <button type="button" class="remove-img-full" @click.stop="removeImage">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="15" height="15">
                  <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"/>
                </svg>
                Quitar imagen
              </button>
            </div>

            <div v-else class="upload-placeholder">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="upload-icon">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 16.5V9.75m0 0l3 3m-3-3l-3 3M6.75 19.5a4.5 4.5 0 01-1.41-8.775 5.25 5.25 0 0110.233-2.33 3 3 0 013.758 3.848A3.752 3.752 0 0118 19.5H6.75z"/>
              </svg>
              <p class="upload-text">Arrastra tu foto aquí o <span>selecciona un archivo</span></p>
              <p class="upload-hint">JPG, PNG, WEBP · Máx. 5 MB</p>
            </div>
          </div>
          <span class="error-msg" v-if="errors.evidencia">{{ errors.evidencia }}</span>
        </div>

                <!-- Firma manuscrita (canvas) -->
        <div class="field-group" :class="{ 'has-error': errors.firma }">
          <div class="sig-label-row">
            <label>Firma del Docente</label>
            <button type="button" class="btn-clear-sig" @click="clearSignature" v-if="hasSignature">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="13" height="13">
                <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"/>
              </svg>
              Limpiar
            </button>
          </div>
          <div class="sig-wrapper" :class="{ 'sig-wrapper--error': errors.firma, 'sig-wrapper--filled': hasSignature }">
            <canvas
              ref="signatureCanvas"
              class="sig-canvas"
              @mousedown="sigStart"
              @mousemove="sigDraw"
              @mouseup="sigStop"
              @mouseleave="sigStop"
              @touchstart.prevent="sigStart"
              @touchmove.prevent="sigDraw"
              @touchend.prevent="sigStop"
            ></canvas>
            <div class="sig-hint" v-if="!hasSignature">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="22" height="22">
                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125M18 14v4.75A2.25 2.25 0 0115.75 21H5.25A2.25 2.25 0 013 18.75V8.25A2.25 2.25 0 015.25 6H10"/>
              </svg>
              <span>Dibuja tu firma aquí</span>
            </div>
          </div>
          <span class="error-msg" v-if="errors.firma">{{ errors.firma }}</span>
        </div>

        <button type="submit" class="btn-submit" :disabled="loading">
          <span v-if="loading" class="spinner"></span>
          <svg v-else xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd"/>
          </svg>
          {{ loading ? 'Guardando registro...' : 'Guardar Registro' }}
        </button>
      </form>

      <!-- Últimos registros -->
      <div class="records-section" v-if="records.length > 0">
        <h2>Últimos registros <span class="badge">{{ records.length }}</span></h2>
        <div class="records-list">
          <div class="record-item" v-for="record in records" :key="record.id">
            <div class="record-thumb">
              <img v-if="record.evidencia_url" :src="record.evidencia_url" :alt="record.area"/>
              <div v-else class="record-thumb-placeholder">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="20" height="20">
                  <path fill-rule="evenodd" d="M1 5.25A2.25 2.25 0 013.25 3h13.5A2.25 2.25 0 0119 5.25v9.5A2.25 2.25 0 0116.75 17H3.25A2.25 2.25 0 011 14.75v-9.5zm1.5 5.81v3.69c0 .414.336.75.75.75h13.5a.75.75 0 00.75-.75v-2.69l-2.22-2.219a.75.75 0 00-1.06 0l-1.91 1.909-.48-.48a.75.75 0 00-1.06 0L6.5 13.311l-1.91-1.909a.75.75 0 00-1.08.017l-.01.01zM15 7.5a1.5 1.5 0 100 3 1.5 1.5 0 000-3z" clip-rule="evenodd"/>
                </svg>
              </div>
            </div>
            <div class="record-info">
              <strong>{{ record.area }}</strong>
              <span>{{ record.docente }}</span>
            </div>
            <div class="record-date">{{ formatDate(record.fecha) }}</div>
          </div>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import { supabase } from '../supabase.js'
import { event } from 'vue-gtag'
import Toast from './Toast.vue'

// ── Estado principal ──────────────────────────────────────────────────────────
const form = reactive({ area: '', grado_seccion: '', docente: '', tarea_realizada: '' })

// Parsea "2°A" → { grado: "2°", seccion: "A" }
// Acepta formatos: "2°A", "2° A", "2° - A", "2A", "Segundo A", etc.
function parseGradoSeccion(value) {
  const v = value.trim()
  // Patrón: (parte del grado) seguido opcionalmente de separador y (letra de sección)
  const match = v.match(/^([^A-Za-z]*[°º]?\s*\d*[°º]?[^A-Za-z]*)[-\s]*([A-Za-z])\s*$/)
  if (match) {
    return { grado: match[1].trim().replace(/[-\s]+$/, '').trim(), seccion: match[2].toUpperCase() }
  }
  // Fallback: último carácter letra = sección, resto = grado
  const lastLetter = v.match(/([A-Za-z])\s*$/)
  if (lastLetter) {
    const idx = v.lastIndexOf(lastLetter[1])
    return { grado: v.slice(0, idx).trim().replace(/[-\s]+$/, '').trim(), seccion: lastLetter[1].toUpperCase() }
  }
  return { grado: v, seccion: '' }
}
const errors         = reactive({})
const loading        = ref(false)
const successMessage = ref('')
const errorMessage   = ref('')
const records        = ref([])
const isConnected    = ref(null)

// ── Evidencia fotográfica ─────────────────────────────────────────────────────
const fileInput    = ref(null)
const selectedFile = ref(null)
const previewUrl   = ref('')
const isDragging   = ref(false)

function onFileChange(e) { const f = e.target.files[0]; if (f) setFile(f) }
function onDrop(e) { isDragging.value = false; const f = e.dataTransfer.files[0]; if (f?.type.startsWith('image/')) setFile(f) }

function setFile(file) {
  if (file.size > 5 * 1024 * 1024) { errors.evidencia = 'La imagen no puede superar los 5 MB.'; return }
  delete errors.evidencia
  selectedFile.value = file
  previewUrl.value   = URL.createObjectURL(file)
}

function removeImage() {
  selectedFile.value = null
  previewUrl.value   = ''
  if (fileInput.value) fileInput.value.value = ''
}

// ── Firma manuscrita (canvas) ─────────────────────────────────────────────────
const signatureCanvas = ref(null)
const isDrawing       = ref(false)
const hasSignature    = ref(false)

function getCtx() { return signatureCanvas.value?.getContext('2d') }

function initCanvas() {
  const canvas = signatureCanvas.value
  if (!canvas) return
  // Ajustar resolución al tamaño real del elemento
  const rect = canvas.getBoundingClientRect()
  canvas.width  = rect.width  * window.devicePixelRatio
  canvas.height = rect.height * window.devicePixelRatio
  const ctx = canvas.getContext('2d')
  ctx.scale(window.devicePixelRatio, window.devicePixelRatio)
  ctx.strokeStyle = '#1e3a8a'
  ctx.lineWidth   = 2.2
  ctx.lineCap     = 'round'
  ctx.lineJoin    = 'round'
}

function getPos(e, canvas) {
  const rect = canvas.getBoundingClientRect()
  const src  = e.touches ? e.touches[0] : e
  return { x: src.clientX - rect.left, y: src.clientY - rect.top }
}

function sigStart(e) {
  const canvas = signatureCanvas.value
  if (!canvas) return
  initCanvas()
  isDrawing.value = true
  const ctx = getCtx()
  const pos = getPos(e, canvas)
  ctx.beginPath()
  ctx.moveTo(pos.x, pos.y)
}

function sigDraw(e) {
  if (!isDrawing.value) return
  const canvas = signatureCanvas.value
  const ctx    = getCtx()
  const pos    = getPos(e, canvas)
  ctx.lineTo(pos.x, pos.y)
  ctx.stroke()
  hasSignature.value = true
}

function sigStop() { isDrawing.value = false }

function clearSignature() {
  const canvas = signatureCanvas.value
  if (!canvas) return
  const ctx = getCtx()
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  hasSignature.value = false
}

function getSignatureDataURL() {
  return hasSignature.value ? signatureCanvas.value?.toDataURL('image/png') : null
}

// ── Fecha y hora ──────────────────────────────────────────────────────────────
const now = new Date()
const fechaActual = now.toLocaleDateString('es-PE', { day: '2-digit', month: 'long', year: 'numeric' })
const horaActual  = now.toLocaleTimeString('es-PE', { hour: '2-digit', minute: '2-digit' })

// ── Conexión ──────────────────────────────────────────────────────────────────
const statusMessage = computed(() => {
  if (isConnected.value === null) return 'Verificando conexión...'
  return isConnected.value ? 'Conectado a Supabase' : 'Sin conexión – configura tu .env'
})
const statusClass = computed(() => ({
  'status-ok':      isConnected.value === true,
  'status-error':   isConnected.value === false,
  'status-pending': isConnected.value === null
}))

// ── Validación ────────────────────────────────────────────────────────────────
function validate() {
  Object.keys(errors).forEach(k => delete errors[k])
  let valid = true
  if (!form.area)            { errors.area = 'El área es obligatoria.'; valid = false }
  if (!form.grado_seccion) {
    errors.grado_seccion = 'El grado y sección son obligatorios.'; valid = false
  } else {
    const { grado, seccion } = parseGradoSeccion(form.grado_seccion)
    if (!grado || !seccion) {
      errors.grado_seccion = 'Formato inválido. Usa p.ej. 2°A o 3°B.'; valid = false
    }
  }
  if (!form.docente)         { errors.docente = 'El nombre del docente es obligatorio.'; valid = false }
  if (!hasSignature.value)   { errors.firma = 'La firma es obligatoria.'; valid = false }
  if (!form.tarea_realizada) { errors.tarea_realizada = 'Debes describir las tareas realizadas.'; valid = false }
  else if (form.tarea_realizada.length > 500) { errors.tarea_realizada = 'No puede superar los 500 caracteres.'; valid = false }
  return valid
}

// ── Envío ─────────────────────────────────────────────────────────────────────
async function handleSubmit() {
  if (!validate()) return
  loading.value = true
  successMessage.value = ''
  errorMessage.value   = ''

  let evidencia_url = null, evidencia_nombre = null, evidencia_tipo = null

  if (selectedFile.value) {
    const ext  = selectedFile.value.name.split('.').pop()
    const path = `limpieza_${Date.now()}.${ext}`
    const { data: sd, error: se } = await supabase.storage
      .from('evidencias-limpieza').upload(path, selectedFile.value, { cacheControl: '3600', upsert: false })
    if (se) { errorMessage.value = `Error al subir la imagen: ${se.message}`; loading.value = false; return }
    const { data: ud } = supabase.storage.from('evidencias-limpieza').getPublicUrl(sd.path)
    evidencia_url    = ud.publicUrl
    evidencia_nombre = selectedFile.value.name
    evidencia_tipo   = selectedFile.value.type
  }

  // Separar el campo combinado antes de insertar en Supabase
  const { grado, seccion } = parseGradoSeccion(form.grado_seccion)

  const { error } = await supabase.from('registro_limpieza').insert([{
    fecha: now.toISOString().split('T')[0],
    hora:  now.toTimeString().split(' ')[0],
    area: form.area, grado, seccion,
    docente: form.docente, firma: getSignatureDataURL(), tarea_realizada: form.tarea_realizada,
    evidencia_url, evidencia_nombre, evidencia_tipo
  }])

  loading.value = false
  if (error) {
    errorMessage.value = `Error al guardar: ${error.message}`
    event('form_error', {mensaje: error.message})
  } else {
    successMessage.value = '¡Registro guardado correctamente!'
    
    // Rastrear evento en Google Analytics (Antes de limpiar el formulario)
    event('registro_limpieza_guardado', {
      area: form.area,
      grado_seccion: form.grado_seccion,
      docente: form.docente
    })

    Object.assign(form, { area: '', grado_seccion: '', docente: '', tarea_realizada: '' })
    clearSignature()
    removeImage()
    await fetchRecords()
  }
  setTimeout(() => { successMessage.value = ''; errorMessage.value = '' }, 5000)
}

// ── Registros ─────────────────────────────────────────────────────────────────
async function fetchRecords() {
  const { data, error } = await supabase
    .from('registro_limpieza').select('id, fecha, area, docente, evidencia_url')
    .order('created_at', { ascending: false }).limit(5)
  if (!error && data) { records.value = data; isConnected.value = true }
  else { isConnected.value = false }
}

function formatDate(d) { if (!d) return ''; const [y,m,day] = d.split('-'); return `${day}/${m}/${y}` }

onMounted(async () => {
  await fetchRecords()
  await nextTick()
  initCanvas()
})
</script>

<style scoped>
/* ── Reset & Variables ───────────────────────────────────────────────────────── */
*, *::before, *::after { box-sizing: border-box; }

/* ── Layout ─────────────────────────────────────────────────────────────────── */
.form-container {
  min-height: 100vh;
  background: linear-gradient(145deg, #eff6ff 0%, #f0f7ff 50%, #e8f0fe 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem 1rem;
  font-family: 'Inter', 'Segoe UI', sans-serif;
}

.form-card {
  width: 100%;
  max-width: 580px;
  background: #ffffff;
  border-radius: 20px;
  border: 1px solid #bfdbfe;
  box-shadow: 0 10px 40px rgba(37, 99, 235, 0.12), 0 2px 8px rgba(0,0,0,0.06);
  overflow: hidden;
}

/* ── Header ─────────────────────────────────────────────────────────────────── */
.form-header {
  background: linear-gradient(135deg, #1e3a8a 0%, #1d4ed8 60%, #2563eb 100%);
  padding: 2rem 2rem 1.5rem;
  text-align: center;
}

.form-header h1 {
  color: #ffffff;
  font-size: 1.35rem;
  font-weight: 800;
  letter-spacing: 0.3px;
  margin: 0 0 0.3rem;
  text-shadow: 0 1px 4px rgba(0,0,0,0.2);
}

.subtitle {
  color: rgba(255,255,255,0.88);
  font-size: 0.92rem;
  font-weight: 600;
  margin: 0 0 1.2rem;
  letter-spacing: 0.8px;
  text-transform: uppercase;
}

/* ── Header image area (logo / preview) ─────────────────────────────────────── */
.header-image-area {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.header-img {
  width: 110px;
  height: 110px;
  object-fit: contain;
  border-radius: 12px;
  background: rgba(255,255,255,0.15);
  padding: 6px;
  border: 2px solid rgba(255,255,255,0.4);
  transition: all 0.35s ease;
  box-shadow: 0 4px 16px rgba(0,0,0,0.2);
}

.header-img.is-preview {
  width: 160px;
  height: 160px;
  object-fit: cover;
  border-color: #bfdbfe;
  border-width: 3px;
  box-shadow: 0 6px 24px rgba(0,0,0,0.25);
}

.preview-label {
  color: #bfdbfe;
  font-size: 0.78rem;
  font-weight: 600;
  margin: 0;
  letter-spacing: 0.3px;
}

/* ── Status badge ───────────────────────────────────────────────────────────── */
.status-badge {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.55rem 1.5rem;
  font-size: 0.78rem;
  font-weight: 500;
  border-bottom: 1px solid #dbeafe;
  color: #6b7280;
  background: #f9fafb;
}
.status-dot { width: 8px; height: 8px; border-radius: 50%; background: #d1d5db; }
.status-ok   .status-dot { background: #2563eb; box-shadow: 0 0 5px #2563eb; }
.status-error .status-dot { background: #ef4444; }
.status-ok    { color: #1d4ed8; }
.status-error { color: #dc2626; }

/* ── Alerts ─────────────────────────────────────────────────────────────────── */
.alert {
  display: flex; align-items: center; gap: 0.75rem;
  margin: 1rem 1.5rem 0; padding: 0.85rem 1rem;
  border-radius: 10px; font-size: 0.875rem; font-weight: 500;
}
.alert svg { width: 18px; height: 18px; flex-shrink: 0; }
.alert-success { background: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
.alert-error   { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }

.fade-enter-active, .fade-leave-active { transition: opacity 0.3s, transform 0.3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; transform: translateY(-6px); }

/* ── Form ───────────────────────────────────────────────────────────────────── */
.form { padding: 1.5rem; display: flex; flex-direction: column; gap: 1.2rem; }

/* ── Date / time chips ───────────────────────────────────────────────────────── */
.date-time-row { display: flex; gap: 0.75rem; flex-wrap: wrap; }
.date-time-chip {
  display: flex; align-items: center; gap: 0.5rem;
  background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px;
  padding: 0.45rem 0.85rem; font-size: 0.82rem; font-weight: 600; color: #1d4ed8;
}
.date-time-chip svg { width: 15px; height: 15px; }

/* ── Two-column row (Grado + Sección) ────────────────────────────────────────── */
.two-col-row { display: grid; grid-template-columns: 1fr 1fr; gap: 0.9rem; }

/* ── Fields ─────────────────────────────────────────────────────────────────── */
.field-group { display: flex; flex-direction: column; gap: 0.35rem; }
.field-group label { font-size: 0.82rem; font-weight: 700; color: #374151; letter-spacing: 0.2px; }

.input-wrapper { position: relative; display: flex; align-items: center; }
.input-icon { position: absolute; left: 0.9rem; width: 17px; height: 17px; color: #9ca3af; pointer-events: none; }

.input-wrapper input, textarea {
  width: 100%;
  background: #f9fafb;
  border: 1.5px solid #d1d5db;
  border-radius: 10px;
  color: #111827;
  font-size: 0.9rem;
  transition: border-color 0.2s, box-shadow 0.2s;
  box-sizing: border-box;
  font-family: inherit;
}
.input-wrapper input { padding: 0.72rem 0.9rem 0.72rem 2.6rem; }
textarea { padding: 0.72rem 0.9rem; resize: vertical; line-height: 1.5; }

.input-wrapper input:focus, textarea:focus {
  outline: none; border-color: #2563eb; box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
  background: #fff;
}
.input-wrapper input::placeholder, textarea::placeholder { color: #9ca3af; }
.has-error .input-wrapper input, .has-error textarea { border-color: #ef4444; }
.error-msg { font-size: 0.78rem; color: #dc2626; }
.field-hint { font-size: 0.76rem; color: #6b7280; margin: 0.1rem 0 0; }

.char-count { font-size: 0.75rem; color: #9ca3af; text-align: right; }
.char-count.warning { color: #d97706; }

/* ── Upload zone ────────────────────────────────────────────────────────────── */
.upload-zone {
  border: 2px dashed #d1d5db; border-radius: 10px; padding: 1.25rem;
  cursor: pointer; transition: border-color 0.2s, background 0.2s;
  text-align: center; min-height: 110px;
  display: flex; align-items: center; justify-content: center;
  background: #f9fafb;
}
.upload-zone:hover, .upload-zone--active {
  border-color: #2563eb; background: #eff6ff;
}
.upload-zone--filled { border-color: #2563eb; background: #eff6ff; border-style: solid; }
.file-input-hidden { display: none; }

.upload-placeholder { display: flex; flex-direction: column; align-items: center; gap: 0.4rem; }
.upload-icon { width: 36px; height: 36px; color: #9ca3af; }
.upload-text { font-size: 0.875rem; color: #6b7280; margin: 0; }
.upload-text span { color: #2563eb; text-decoration: underline; }
.upload-hint { font-size: 0.75rem; color: #9ca3af; margin: 0; }

/* Preview inline dentro de la zona de carga */
.upload-preview-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.75rem;
  width: 100%;
}

.inline-preview-img {
  max-height: 220px;
  max-width: 100%;
  border-radius: 10px;
  object-fit: cover;
  border: 2px solid #93c5fd;
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.15);
}

.inline-preview-name {
  font-size: 0.78rem;
  color: #6b7280;
  margin: 0;
  max-width: 280px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  text-align: center;
}

.remove-img-full {
  display: flex;
  align-items: center;
  gap: 0.4rem;
  background: #fee2e2;
  color: #dc2626;
  border: 1px solid #fecaca;
  border-radius: 8px;
  padding: 0.45rem 1rem;
  font-size: 0.82rem;
  font-weight: 600;
  cursor: pointer;
  font-family: inherit;
  transition: background 0.2s, transform 0.15s;
}
.remove-img-full:hover { background: #fecaca; transform: translateY(-1px); }

/* ── Submit button ──────────────────────────────────────────────────────────── */
.btn-submit {
  width: 100%; padding: 0.9rem;
  background: linear-gradient(135deg, #1e3a8a, #2563eb);
  color: #fff; font-size: 0.95rem; font-weight: 700;
  border: none; border-radius: 10px; cursor: pointer;
  display: flex; align-items: center; justify-content: center; gap: 0.6rem;
  transition: opacity 0.2s, transform 0.15s, box-shadow 0.2s;
  box-shadow: 0 4px 14px rgba(37,99,235,0.3);
}
.btn-submit:hover:not(:disabled) { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(37,99,235,0.4); }
.btn-submit:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-submit svg { width: 18px; height: 18px; }

.spinner {
  display: inline-block; width: 18px; height: 18px;
  border: 2.5px solid rgba(255,255,255,0.35); border-top-color: #fff;
  border-radius: 50%; animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Records ────────────────────────────────────────────────────────────────── */
.records-section { padding: 0 1.5rem 1.5rem; }
.records-section h2 {
  font-size: 0.92rem; font-weight: 700; color: #374151;
  margin: 0 0 0.75rem; display: flex; align-items: center; gap: 0.5rem;
}
.badge {
  background: #dbeafe; color: #1d4ed8;
  border-radius: 20px; padding: 0.1rem 0.55rem; font-size: 0.75rem; font-weight: 700;
}
.records-list { display: flex; flex-direction: column; gap: 0.5rem; }
.record-item {
  display: flex; align-items: center; gap: 0.85rem;
  padding: 0.7rem 1rem; background: #f9fafb;
  border-radius: 10px; border: 1px solid #e5e7eb;
}
.record-thumb {
  width: 42px; height: 42px; border-radius: 8px; overflow: hidden; flex-shrink: 0;
  background: #e5e7eb; display: flex; align-items: center; justify-content: center;
  border: 1px solid #d1d5db;
}
.record-thumb img { width: 100%; height: 100%; object-fit: cover; }
.record-thumb-placeholder { color: #9ca3af; }
.record-info { flex: 1; display: flex; flex-direction: column; min-width: 0; }
.record-info strong { font-size: 0.875rem; color: #111827; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.record-info span   { font-size: 0.78rem; color: #6b7280; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.record-date { font-size: 0.75rem; color: #9ca3af; white-space: nowrap; }

/* ── Firma manuscrita ────────────────────────────────────────────────────────── */
.sig-label-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.35rem;
}

.sig-label-row label { margin-bottom: 0; }

.btn-clear-sig {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  background: #fee2e2;
  color: #dc2626;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 0.22rem 0.65rem;
  font-size: 0.76rem;
  font-weight: 600;
  cursor: pointer;
  font-family: inherit;
  transition: background 0.18s;
}
.btn-clear-sig:hover { background: #fecaca; }

.sig-wrapper {
  position: relative;
  border: 2px dashed #d1d5db;
  border-radius: 10px;
  background: #f9fafb;
  overflow: hidden;
  height: 130px;
  cursor: crosshair;
  transition: border-color 0.2s, background 0.2s;
}
.sig-wrapper:hover      { border-color: #2563eb; background: #eff6ff; }
.sig-wrapper--filled    { border-style: solid; border-color: #2563eb; background: #fff; }
.sig-wrapper--error     { border-color: #ef4444 !important; }

.sig-canvas {
  width: 100%;
  height: 100%;
  display: block;
  touch-action: none;
}

.sig-hint {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  color: #9ca3af;
  font-size: 0.82rem;
  pointer-events: none;
  user-select: none;
}

/* ── Responsive ──────────────────────────────────────────────────────────────── */
@media (max-width: 620px) {
  .form-card { border-radius: 14px; }
  .form-header { padding: 1.5rem 1.25rem 1.2rem; }
  .form-header h1 { font-size: 1.1rem; }
  .subtitle { font-size: 0.82rem; }
  .header-img { width: 85px; height: 85px; }
  .form { padding: 1.1rem; gap: 1rem; }
  .two-col-row { grid-template-columns: 1fr; gap: 1rem; }
  .date-time-row { flex-direction: column; gap: 0.5rem; }
  .date-time-chip { justify-content: center; }
  .records-section { padding: 0 1.1rem 1.1rem; }
}

@media (max-width: 400px) {
  .form-header h1 { font-size: 0.98rem; }
  .btn-submit { font-size: 0.88rem; padding: 0.78rem; }
  .sig-wrapper { height: 110px; }
}
</style>
