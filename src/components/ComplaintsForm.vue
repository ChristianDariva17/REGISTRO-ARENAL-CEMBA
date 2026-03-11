<template>
  <div class="complaints-wrapper">
    <!-- Header -->
    <div class="complaints-header">
      <div class="header-institution">
        <img src="/cemba.webp" alt="Logo CEMBA" class="institution-logo" />
        <div class="institution-info">
          <span class="institution-name">I.E.F El Arenal – CEMBA</span>
          <h1 class="header-title">LIBRO DE RECLAMACIONES</h1>
          <p class="header-subtitle">Registro oficial de quejas y reclamos</p>
        </div>
      </div>
    </div>

    <form @submit.prevent="handleSubmit" class="complaints-form" novalidate>

      <!-- ─────────────── SECTION 0: Fecha ─────────────── -->
      <div class="form-section-header">
        <span class="section-icon">📅</span>
        <span>Fecha de Registro</span>
      </div>
      <div class="form-grid form-grid--2" style="max-width:340px">
        <div class="form-group">
          <label class="form-label" for="fecha">Fecha</label>
          <input id="fecha" v-model="form.fecha" type="date" class="form-input" required />
        </div>
      </div>

      <!-- ─────────────── SECTION 1: Identificación del Consumidor ─────────────── -->
      <div class="form-section-header">
        <span class="section-icon">👤</span>
        <span>1. Identificación del Docente Reclamante</span>
      </div>

      <div class="form-group">
        <label class="form-label" for="nombre">Nombre Completo</label>
        <input id="nombre" v-model="form.nombre" type="text"
          class="form-input" placeholder="Apellidos y Nombres" required />
      </div>

      <div class="form-group">
        <label class="form-label" for="telefono">Número de Celular</label>
        <input id="telefono" v-model="form.telefono" type="tel"
          class="form-input" placeholder="+51 999 999 999" required />
      </div>

      <!-- ─────────────── SECTION 2: Identificación del Reclamo ─────────────── -->
      <div class="form-section-header">
        <span class="section-icon">🔍</span>
        <span>2. Identificación del Reclamo</span>
      </div>

      <div class="complaint-type-block">
        <p class="type-label">¿La queja / reclamo concierne a un:</p>
        <div class="type-options">
          <label class="type-card" :class="{ active: form.tipo === 'producto' }">
            <input type="radio" v-model="form.tipo" value="producto" class="type-radio" />
            <span class="type-icon">📦</span>
            <span class="type-name">PRODUCTO</span>
            <span class="type-desc">Bien adquirido o defecto en un artículo</span>
          </label>
          <label class="type-card" :class="{ active: form.tipo === 'servicio' }">
            <input type="radio" v-model="form.tipo" value="servicio" class="type-radio" />
            <span class="type-icon">⚙️</span>
            <span class="type-name">SERVICIO</span>
            <span class="type-desc">Atención, servicio prestado o contratado</span>
          </label>
        </div>
      </div>

      <!-- Producto/Servicio detail when type selected -->
      <div v-if="form.tipo" class="form-group mt-4">
        <label class="form-label" for="desc_bien">
          {{ form.tipo === 'producto' ? 'Descripción del Producto' : 'Descripción del Servicio' }}
        </label>
        <input id="desc_bien" v-model="form.desc_bien" type="text"
          class="form-input"
          :placeholder="form.tipo === 'producto'
            ? 'Nombre o código del producto'
            : 'Tipo de servicio o contrato'" />
      </div>

      <!-- ─────────────── SECTION 3: Detalle de la Reclamación ─────────────── -->
      <div class="form-section-header">
        <span class="section-icon">📝</span>
        <span>3. Detalle de la Reclamación</span>
        <div class="reclamacion-toggle">
          <button type="button"
            class="toggle-btn" :class="{ selected: form.subtipo === 'reclamo' }"
            @click="form.subtipo = 'reclamo'">
            RECLAMO
          </button>
          <button type="button"
            class="toggle-btn" :class="{ selected: form.subtipo === 'queja' }"
            @click="form.subtipo = 'queja'">
            QUEJA
          </button>
        </div>
      </div>

      <div class="definitions-row" v-if="form.subtipo">
        <div class="definition-card" v-if="form.subtipo === 'reclamo'">
          <strong>RECLAMO:</strong> Disconformidad relacionada a los productos o servicios.
        </div>
        <div class="definition-card definition-card--queja" v-if="form.subtipo === 'queja'">
          <strong>QUEJA:</strong> Disconformidad no relacionada a los productos o servicios; o,
          malestar o descontento respecto a la atención al público.
        </div>
      </div>

      <div class="form-group">
        <label class="form-label" for="detalle">
          Describa detalladamente el motivo de su reclamo / queja
          <span class="char-count">{{ form.detalle.length }} / 1000</span>
        </label>
        <textarea id="detalle" v-model="form.detalle" rows="7"
          class="form-textarea"
          placeholder="Describa los hechos de manera clara y ordenada: qué ocurrió, cuándo, cómo y cuáles son sus expectativas de solución..."
          maxlength="1000" required></textarea>
      </div>

      <!-- ─────────────── SECTION 4: Pedido del Consumidor ─────────────── -->
      <div class="form-section-header">
        <span class="section-icon">🎯</span>
        <span>4. Pedido del Consumidor</span>
      </div>

      <div class="form-group">
        <label class="form-label" for="pedido">¿Qué solución espera?</label>
        <textarea id="pedido" v-model="form.pedido" rows="3"
          class="form-textarea"
          placeholder="Indique qué resultado o acción espera por parte de la institución..."></textarea>
      </div>

      <!-- ─────────────── Acciones de la Institución ─────────────── -->
      <div class="institution-block">
        <p class="institution-note">
          Este espacio será completado por un representante de la institución
          una vez recibida y procesada la presente reclamación.
        </p>

        <!-- DNI + Firma lado a lado -->
        <div class="dni-sig-row">
          <!-- Celda DNI -->
          <div class="dni-sig-cell">
            <label class="form-label" for="dni">N° de Identificación DNI</label>
            <input id="dni" v-model="form.dni" type="text"
              class="form-input" placeholder="00000000" maxlength="20" required />
          </div>

          <!-- Celda Firma -->
          <div class="sig-cell">
            <div class="sig-label-row">
              <span class="form-label">Firma del Docente / Reclamante</span>
              <button type="button" class="btn-clear-sig" v-if="hasSignature" @click="clearSignature">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="12" height="12">
                  <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"/>
                </svg>
                Limpiar
              </button>
            </div>
            <div
              class="sig-wrapper"
              :class="{ 'sig-wrapper--filled': hasSignature, 'sig-wrapper--error': sigError }"
            >
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
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" width="20" height="20">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13L6 18l.8-2.685a4.5 4.5 0 011.13-1.897l8.932-8.931zm0 0L19.5 7.125"/>
                </svg>
                <span>Dibuja tu firma aquí</span>
              </div>
            </div>
            <p class="sig-error" v-if="sigError">{{ sigError }}</p>
          </div>
        </div>
      </div>

      <!-- ─────────────── Submit ─────────────── -->
      <div class="form-actions">
        <button type="button" class="btn btn--secondary" @click="resetForm">
          Limpiar Formulario
        </button>
        <button type="submit" class="btn btn--primary" :disabled="submitting">
          <span v-if="submitting" class="spinner"></span>
          {{ submitting ? 'Registrando...' : 'Enviar Reclamación' }}
        </button>
      </div>

      <!-- Toast global -->
      <Toast :message="successMsg" type="success" @dismissed="successMsg = ''" />
      <Toast :message="errorMsg"   type="error"   @dismissed="errorMsg   = ''" />
    </form>

    <!-- Bottom legend -->
    <div class="legend-bar">
      <div class="legend-item">
        <strong>RECLAMO:</strong> Disconformidad relacionada a los productos o servicios.
      </div>
      <div class="legend-item">
        <strong>QUEJA:</strong> Disconformidad no relacionada a los productos o servicios; o,
        malestar o descontento respecto a la atención al público.
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { supabase } from '../supabase.js'
import Toast from './Toast.vue'

// ── Canvas / Firma ────────────────────────────────────────────────────────────
const signatureCanvas = ref(null)
const isDrawing       = ref(false)
const hasSignature    = ref(false)
const sigError        = ref('')

function getCtx () { return signatureCanvas.value?.getContext('2d') }

function initCanvas () {
  const canvas = signatureCanvas.value
  if (!canvas) return
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

function getPos (e, canvas) {
  const rect = canvas.getBoundingClientRect()
  const src  = e.touches ? e.touches[0] : e
  return { x: src.clientX - rect.left, y: src.clientY - rect.top }
}

function sigStart (e) {
  const canvas = signatureCanvas.value
  if (!canvas) return
  initCanvas()
  isDrawing.value = true
  sigError.value  = ''
  const ctx = getCtx()
  const pos = getPos(e, canvas)
  ctx.beginPath()
  ctx.moveTo(pos.x, pos.y)
}

function sigDraw (e) {
  if (!isDrawing.value) return
  const canvas = signatureCanvas.value
  const ctx    = getCtx()
  const pos    = getPos(e, canvas)
  ctx.lineTo(pos.x, pos.y)
  ctx.stroke()
  hasSignature.value = true
}

function sigStop () { isDrawing.value = false }

function clearSignature () {
  const canvas = signatureCanvas.value
  if (!canvas) return
  const ctx = getCtx()
  ctx.clearRect(0, 0, canvas.width, canvas.height)
  hasSignature.value = false
}

function getSignatureDataURL () {
  return hasSignature.value ? signatureCanvas.value?.toDataURL('image/png') : null
}

// ── Reactive form state ─────────────────────────────────────────────────────
const defaultForm = () => ({
  fecha:    new Date().toISOString().split('T')[0],
  nombre:   '',
  dni:      '',
  telefono: '',
  tipo:     '',       // 'producto' | 'servicio'
  desc_bien:'',
  subtipo:  '',       // 'reclamo' | 'queja'
  detalle:  '',
  pedido:   '',
})

const form       = ref(defaultForm())
const submitting = ref(false)
const successMsg = ref('')
const errorMsg   = ref('')

// ── Reset ────────────────────────────────────────────────────────────────────
function resetForm () {
  form.value       = defaultForm()
  successMsg.value = ''
  errorMsg.value   = ''
  sigError.value   = ''
  clearSignature()
}

// ── Submit ───────────────────────────────────────────────────────────────────
async function handleSubmit () {
  successMsg.value = ''
  errorMsg.value   = ''

  if (!form.value.tipo) {
    errorMsg.value = 'Por favor seleccione si el reclamo es sobre un Producto o Servicio.'
    return
  }
  if (!form.value.subtipo) {
    errorMsg.value = 'Por favor indique si es un Reclamo o una Queja.'
    return
  }
  if (!hasSignature.value) {
    sigError.value = 'La firma es obligatoria.'
    return
  }

  submitting.value = true
  try {
    const { error } = await supabase
      .from('reclamaciones')
      .insert([{
        fecha:     form.value.fecha,
        nombre:    form.value.nombre,
        dni:       form.value.dni,
        telefono:  form.value.telefono,
        tipo:      form.value.tipo,
        desc_bien: form.value.desc_bien,
        subtipo:   form.value.subtipo,
        detalle:   form.value.detalle,
        pedido:    form.value.pedido,
        firma:     getSignatureDataURL(),
      }])

    if (error) throw error

    successMsg.value = '¡Reclamación registrada exitosamente! Nos pondremos en contacto contigo a la brevedad.'
    resetForm()
  } catch (err) {
    console.error(err)
    errorMsg.value = `Error al registrar: ${err.message}`
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  await nextTick()
  initCanvas()
})
</script>

<style scoped>
/* ─── Wrapper ──────────────────────────────────────────────────────────────── */
.complaints-wrapper {
  max-width: 860px;
  margin: 2rem auto 4rem;
  padding: 0 1rem;
  font-family: 'Inter', 'Segoe UI', sans-serif;
}

/* ─── Header ───────────────────────────────────────────────────────────────── */
.complaints-header {
  background: linear-gradient(135deg, #1e3a8a, #1d4ed8);
  color: #fff;
  border-radius: 16px 16px 0 0;
  padding: 1.6rem 2rem;
  display: flex;
  justify-content: center;
}

.header-institution {
  display: flex;
  align-items: center;
  gap: 1.25rem;
}

.institution-logo {
  width: 72px;
  height: 72px;
  object-fit: contain;
  border-radius: 10px;
  background: rgba(255,255,255,0.15);
  padding: 5px;
  border: 2px solid rgba(255,255,255,0.35);
  box-shadow: 0 4px 14px rgba(0,0,0,0.2);
  flex-shrink: 0;
}

.institution-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.institution-name {
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 1px;
  text-transform: uppercase;
  opacity: 0.85;
}

.header-title {
  font-size: 1.3rem;
  font-weight: 800;
  letter-spacing: 1.5px;
  margin: 0;
}

.header-subtitle {
  font-size: 0.78rem;
  opacity: 0.7;
  margin: 0;
}

/* ─── Form container ────────────────────────────────────────────────────────── */
.complaints-form {
  background: #ffffff;
  border: 1px solid #e2e8f0;
  border-top: none;
  border-radius: 0 0 16px 16px;
  padding: 2rem;
  box-shadow: 0 8px 32px rgba(30, 58, 138, 0.10);
}

/* ─── Section headers ───────────────────────────────────────────────────────── */
.form-section-header {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  background: linear-gradient(90deg, #eff6ff, #dbeafe);
  border-left: 4px solid #1d4ed8;
  color: #1e3a8a;
  font-size: 0.82rem;
  font-weight: 700;
  letter-spacing: 0.5px;
  text-transform: uppercase;
  padding: 0.55rem 1rem;
  border-radius: 0 8px 8px 0;
  margin: 1.6rem 0 1rem;
}

.form-section-header:first-child { margin-top: 0; }

.form-section-header--secondary {
  background: linear-gradient(90deg, #f8fafc, #f1f5f9);
  border-left-color: #64748b;
  color: #475569;
}

.section-icon { font-size: 0.95rem; }

.section-badge {
  margin-left: auto;
  font-size: 0.65rem;
  font-weight: 700;
  background: #64748b;
  color: #fff;
  padding: 0.15rem 0.55rem;
  border-radius: 99px;
  letter-spacing: 0.5px;
}

/* ─── Grids ─────────────────────────────────────────────────────────────────── */
.form-grid { display: grid; gap: 1rem; }
.form-grid--2 { grid-template-columns: 1fr 1fr; }
.form-grid--3 { grid-template-columns: 1fr 1fr 1fr; }

@media (max-width: 640px) {
  .form-grid--2,
  .form-grid--3 { grid-template-columns: 1fr; }
}

/* ─── Groups / Labels / Inputs ──────────────────────────────────────────────── */
.form-group { display: flex; flex-direction: column; gap: 0.4rem; }
.mt-4 { margin-top: 1rem; }

.form-label {
  font-size: 0.78rem;
  font-weight: 600;
  color: #374151;
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 1rem;
}

.char-count {
  font-size: 0.72rem;
  font-weight: 400;
  color: #9ca3af;
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 0.6rem 0.85rem;
  border: 1.5px solid #d1d5db;
  border-radius: 8px;
  font-size: 0.88rem;
  color: #1f2937;
  background: #f9fafb;
  transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
  box-sizing: border-box;
  font-family: inherit;
}

.form-input:focus,
.form-textarea:focus {
  outline: none;
  border-color: #1d4ed8;
  background: #fff;
  box-shadow: 0 0 0 3px rgba(29, 78, 216, 0.12);
}

.form-textarea { resize: vertical; min-height: 120px; }

/* ─── Type selector ──────────────────────────────────────────────────────────── */
.complaint-type-block {
  background: #f8fafc;
  border: 1.5px solid #e2e8f0;
  border-radius: 12px;
  padding: 1.25rem 1.5rem;
}

.type-label {
  font-size: 0.82rem;
  font-weight: 600;
  color: #374151;
  margin: 0 0 0.85rem;
}

.type-options {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.85rem;
}

.type-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.3rem;
  padding: 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 12px;
  cursor: pointer;
  text-align: center;
  background: #fff;
  transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
}

.type-card:hover {
  border-color: #93c5fd;
  background: #eff6ff;
}

.type-card.active {
  border-color: #1d4ed8;
  background: #eff6ff;
  box-shadow: 0 0 0 3px rgba(29, 78, 216, 0.12);
}

.type-radio { display: none; }

.type-icon { font-size: 1.6rem; }

.type-name {
  font-size: 0.82rem;
  font-weight: 700;
  color: #1e3a8a;
  letter-spacing: 0.5px;
}

.type-desc {
  font-size: 0.72rem;
  color: #6b7280;
  line-height: 1.4;
}

/* ─── Reclamo/Queja toggle ──────────────────────────────────────────────────── */
.reclamacion-toggle {
  margin-left: auto;
  display: flex;
  gap: 0.4rem;
}

.toggle-btn {
  padding: 0.25rem 0.85rem;
  border: 2px solid #d1d5db;
  border-radius: 99px;
  background: #fff;
  font-size: 0.72rem;
  font-weight: 700;
  cursor: pointer;
  color: #6b7280;
  letter-spacing: 0.5px;
  transition: all 0.18s;
}

.toggle-btn:hover { border-color: #1d4ed8; color: #1d4ed8; }

.toggle-btn.selected {
  background: #1d4ed8;
  border-color: #1d4ed8;
  color: #fff;
}

/* ─── Definition cards ──────────────────────────────────────────────────────── */
.definitions-row { margin-bottom: 1rem; }

.definition-card {
  font-size: 0.78rem;
  color: #374151;
  background: #eff6ff;
  border: 1px solid #bfdbfe;
  border-radius: 8px;
  padding: 0.65rem 1rem;
  line-height: 1.55;
}

.definition-card--queja {
  background: #fff7ed;
  border-color: #fed7aa;
  color: #92400e;
}

/* ─── Institution / Signature block ─────────────────────────────────────────── */
.institution-block {
  background: #f8fafc;
  border: 1.5px solid #e2e8f0;
  border-radius: 12px;
  padding: 1.25rem 1.5rem;
  margin-bottom: 1.8rem;
  margin-top: 1.8rem;
}

.institution-note {
  font-size: 0.78rem;
  color: #6b7280;
  margin: 0 0 1.25rem;
  font-style: italic;
  line-height: 1.55;
}

/* DNI + Firma en fila */
.dni-sig-row {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 1.5rem;
  align-items: end;
}

.dni-sig-cell {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.sig-cell {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}

/* Label row (label + clear button) */
.sig-label-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.btn-clear-sig {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  background: #fee2e2;
  color: #dc2626;
  border: 1px solid #fecaca;
  border-radius: 6px;
  padding: 0.2rem 0.6rem;
  font-size: 0.74rem;
  font-weight: 600;
  cursor: pointer;
  font-family: inherit;
  transition: background 0.18s;
}
.btn-clear-sig:hover { background: #fecaca; }

/* Canvas wrapper */
.sig-wrapper {
  position: relative;
  border: 2px dashed #d1d5db;
  border-radius: 10px;
  background: #f9fafb;
  overflow: hidden;
  height: 120px;
  cursor: crosshair;
  transition: border-color 0.2s, background 0.2s;
}
.sig-wrapper:hover         { border-color: #1d4ed8; background: #eff6ff; }
.sig-wrapper--filled       { border-style: solid; border-color: #1d4ed8; background: #fff; }
.sig-wrapper--error        { border-color: #ef4444 !important; }

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
  gap: 0.35rem;
  color: #9ca3af;
  font-size: 0.78rem;
  pointer-events: none;
  user-select: none;
}

.sig-error {
  font-size: 0.76rem;
  color: #dc2626;
  margin: 0;
}

/* ─── Actions ───────────────────────────────────────────────────────────────── */
.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1rem;
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.65rem 1.5rem;
  border-radius: 10px;
  font-size: 0.88rem;
  font-weight: 700;
  cursor: pointer;
  border: none;
  transition: all 0.2s;
}

.btn--primary {
  background: linear-gradient(135deg, #1e3a8a, #1d4ed8);
  color: #fff;
  box-shadow: 0 4px 12px rgba(29, 78, 216, 0.3);
}

.btn--primary:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(29, 78, 216, 0.4);
}

.btn--primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn--secondary {
  background: #f1f5f9;
  color: #475569;
  border: 1.5px solid #e2e8f0;
}

.btn--secondary:hover {
  background: #e2e8f0;
}

/* ─── Alerts ────────────────────────────────────────────────────────────────── */
.alert {
  display: flex;
  align-items: flex-start;
  gap: 0.6rem;
  margin-top: 1rem;
  padding: 0.85rem 1rem;
  border-radius: 10px;
  font-size: 0.85rem;
  font-weight: 500;
  line-height: 1.5;
}

.alert--success {
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  color: #166534;
}

.alert--error {
  background: #fef2f2;
  border: 1px solid #fecaca;
  color: #991b1b;
}

/* ─── Spinner ───────────────────────────────────────────────────────────────── */
.spinner {
  width: 14px; height: 14px;
  border: 2px solid rgba(255,255,255,0.4);
  border-top-color: #fff;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
  display: inline-block;
}

@keyframes spin { to { transform: rotate(360deg); } }

/* ─── Legend bar ────────────────────────────────────────────────────────────── */
.legend-bar {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1px;
  margin-top: 0.5rem;
  background: #e2e8f0;
  border-radius: 0 0 12px 12px;
  overflow: hidden;
}

.legend-item {
  background: #f8fafc;
  font-size: 0.72rem;
  color: #475569;
  padding: 0.55rem 1rem;
  line-height: 1.55;
}

/* ─── Fade transition ────────────────────────────────────────────────────────── */
.fade-enter-active, .fade-leave-active { transition: opacity 0.35s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

/* ─── Mobile responsive (≤ 640 px) ──────────────────────────────────────────── */
@media (max-width: 640px) {
  .complaints-wrapper {
    margin: 1rem auto 2.5rem;
    padding: 0 0.5rem;
  }

  /* Header */
  .complaints-header { padding: 1.2rem 1rem; }
  .header-institution {
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 0.85rem;
  }
  .institution-logo  { width: 56px; height: 56px; }
  .header-title      { font-size: 1.05rem; }
  .institution-name  { font-size: 0.72rem; }

  /* Form padding */
  .complaints-form { padding: 1.25rem 1rem; }

  /* Section headers */
  .form-section-header {
    font-size: 0.75rem;
    flex-wrap: wrap;
    gap: 0.4rem;
  }
  .reclamacion-toggle {
    margin-left: 0;
    width: 100%;
    justify-content: flex-end;
  }

  /* All grids collapse to 1 column */
  .form-grid--2,
  .form-grid--3 { grid-template-columns: 1fr; }

  /* Type cards */
  .type-options { grid-template-columns: 1fr; }

  /* DNI + Firma: stack vertically on mobile */
  .dni-sig-row {
    grid-template-columns: 1fr;
    gap: 1.25rem;
  }
  .sig-cell     { align-items: flex-start; }
  .signature-line { height: 48px; }

  /* Institution block */
  .institution-block { padding: 1rem; }

  /* Actions */
  .form-actions {
    flex-direction: column-reverse;
    gap: 0.6rem;
  }
  .btn {
    width: 100%;
    justify-content: center;
  }

  /* Legend bar */
  .legend-bar { grid-template-columns: 1fr; }
}
</style>
