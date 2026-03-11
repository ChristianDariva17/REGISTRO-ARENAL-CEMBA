<template>
  <div class="rv-container">

    <!-- ── Encabezado ─────────────────────────────────────────────────────── -->
    <div class="rv-header">
      <div class="rv-header__left">
        <h1>Libro de Reclamaciones</h1>
        <p class="rv-subtitle">I.E.F El Arenal – CEMBA</p>
      </div>
      <button class="btn-pdf" @click="exportAllPDF" :disabled="loading || filtered.length === 0">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd"/>
        </svg>
        Exportar todo
      </button>
    </div>

    <!-- ── Filtros ────────────────────────────────────────────────────────── -->
    <div class="rv-filters">
      <div class="filter-group">
        <label>Desde</label>
        <input type="date" v-model="filters.desde" />
      </div>
      <div class="filter-group">
        <label>Hasta</label>
        <input type="date" v-model="filters.hasta" />
      </div>
      <div class="filter-group">
        <label>Nombre</label>
        <input type="text" v-model="filters.nombre" placeholder="Reclamante..." />
      </div>
      <div class="filter-group">
        <label>Tipo</label>
        <select v-model="filters.tipo">
          <option value="">Todos</option>
          <option value="producto">Producto</option>
          <option value="servicio">Servicio</option>
        </select>
      </div>
      <div class="filter-group">
        <label>Subtipo</label>
        <select v-model="filters.subtipo">
          <option value="">Todos</option>
          <option value="reclamo">Reclamo</option>
          <option value="queja">Queja</option>
        </select>
      </div>
      <button class="btn-clear-filters" @click="clearFilters" title="Limpiar filtros">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
          <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"/>
        </svg>
        Limpiar
      </button>
    </div>

    <!-- ── Estado ─────────────────────────────────────────────────────────── -->
    <div v-if="loading" class="rv-state">
      <span class="spinner"></span> Cargando reclamaciones...
    </div>
    <div v-else-if="errorMsg" class="rv-state rv-state--error">{{ errorMsg }}</div>
    <div v-else-if="filtered.length === 0" class="rv-state">No se encontraron reclamaciones.</div>

    <!-- ── Tabla ──────────────────────────────────────────────────────────── -->
    <div v-else class="rv-table-wrap">
      <table class="rv-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Fecha</th>
            <th>Nombre</th>
            <th>DNI</th>
            <th>Teléfono</th>
            <th>Tipo</th>
            <th>Subtipo</th>
            <th>Detalle</th>
            <th>Firma</th>
            <th class="th-action">PDF</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(rec, i) in paginated" :key="rec.id">
            <td class="td-center">{{ (currentPage - 1) * perPage + i + 1 }}</td>
            <td class="td-nowrap">{{ formatDate(rec.fecha) }}</td>
            <td>{{ rec.nombre }}</td>
            <td class="td-center td-nowrap">{{ rec.dni }}</td>
            <td class="td-nowrap">{{ rec.telefono }}</td>
            <td class="td-center">
              <span class="badge" :class="rec.tipo === 'producto' ? 'badge--blue' : 'badge--indigo'">
                {{ rec.tipo }}
              </span>
            </td>
            <td class="td-center">
              <span class="badge" :class="rec.subtipo === 'reclamo' ? 'badge--amber' : 'badge--rose'">
                {{ rec.subtipo }}
              </span>
            </td>
            <td class="td-detalle">{{ rec.detalle }}</td>
            <td class="td-center">
              <img
                v-if="rec.firma"
                :src="rec.firma"
                class="thumb-sig"
                @click="openModal(rec.firma, 'Firma del reclamante')"
                title="Ver firma"
              />
              <span v-else class="td-empty">—</span>
            </td>
            <td class="td-center">
              <button class="btn-row-pdf" @click="exportRowPDF(rec)" title="Descargar PDF de esta reclamación">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="13" height="13">
                  <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd"/>
                </svg>
                PDF
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- ── Paginación ─────────────────────────────────────────────────────── -->
    <div class="rv-pagination" v-if="totalPages > 1">
      <button @click="currentPage--" :disabled="currentPage === 1">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clip-rule="evenodd"/>
        </svg>
      </button>
      <span>Página {{ currentPage }} de {{ totalPages }}</span>
      <button @click="currentPage++" :disabled="currentPage === totalPages">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd"/>
        </svg>
      </button>
    </div>

    <!-- ── Total ──────────────────────────────────────────────────────────── -->
    <div class="rv-total" v-if="!loading && filtered.length > 0">
      Total: <strong>{{ filtered.length }}</strong> reclamación(es)
    </div>

    <!-- ── Modal firma ────────────────────────────────────────────────────── -->
    <transition name="modal-fade">
      <div class="modal-backdrop" v-if="modal.open" @click.self="closeModal">
        <div class="modal-box">
          <div class="modal-toolbar">
            <span class="modal-title">{{ modal.label }}</span>
            <button class="modal-close" @click="closeModal">×</button>
          </div>
          <img :src="modal.src" class="modal-img" />
        </div>
      </div>
    </transition>

  </div>
</template>

<script setup>
import { ref, reactive, computed, watch, onMounted } from 'vue'
import { supabase } from '../supabase.js'
import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

// ── Datos ────────────────────────────────────────────────────────────────────
const records  = ref([])
const loading  = ref(true)
const errorMsg = ref('')

async function fetchAll () {
  loading.value  = true
  errorMsg.value = ''
  const { data, error } = await supabase
    .from('reclamaciones')
    .select('id, created_at, fecha, nombre, dni, telefono, tipo, desc_bien, subtipo, detalle, pedido, firma')
    .order('created_at', { ascending: false })
  loading.value = false
  if (error) { errorMsg.value = `Error al cargar: ${error.message}`; return }
  records.value = data || []
}

onMounted(fetchAll)

// ── Filtros ──────────────────────────────────────────────────────────────────
const filters = reactive({ desde: '', hasta: '', nombre: '', tipo: '', subtipo: '' })

function clearFilters () {
  Object.assign(filters, { desde: '', hasta: '', nombre: '', tipo: '', subtipo: '' })
}

const filtered = computed(() =>
  records.value.filter(r => {
    if (filters.desde   && r.fecha < filters.desde)                                        return false
    if (filters.hasta   && r.fecha > filters.hasta)                                        return false
    if (filters.nombre  && !r.nombre?.toLowerCase().includes(filters.nombre.toLowerCase())) return false
    if (filters.tipo    && r.tipo    !== filters.tipo)                                      return false
    if (filters.subtipo && r.subtipo !== filters.subtipo)                                   return false
    return true
  })
)

// ── Paginación ───────────────────────────────────────────────────────────────
const perPage     = 10
const currentPage = ref(1)

watch(filters, () => { currentPage.value = 1 })

const totalPages = computed(() => Math.ceil(filtered.value.length / perPage) || 1)
const paginated  = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filtered.value.slice(start, start + perPage)
})

// ── Utilidades ───────────────────────────────────────────────────────────────
function formatDate (d) {
  if (!d) return ''
  const [y, m, day] = d.split('-')
  return `${day}/${m}/${y}`
}

// ── Modal ─────────────────────────────────────────────────────────────────────
const modal = reactive({ open: false, src: '', label: '' })
function openModal (src, label) { modal.src = src; modal.label = label || 'Imagen'; modal.open = true }
function closeModal ()          { modal.open = false; modal.src = ''; modal.label = '' }

// ── PDF helpers ───────────────────────────────────────────────────────────────
const BLUE_DARK  = [30,  58,  138]
const BLUE_MID   = [37,  99,  235]  // eslint-disable-line no-unused-vars
const BLUE_LIGHT = [219, 234, 254]
const GRAY_DARK  = [55,  65,  81]
const GRAY_MID   = [100, 116, 139]

function drawRect (doc, x, y, w, h, fill, stroke) {
  if (fill)   { doc.setFillColor(...fill);   doc.rect(x, y, w, h, 'F') }
  if (stroke) { doc.setDrawColor(...stroke); doc.rect(x, y, w, h, 'S') }
}

function label (doc, text, x, y, value, bold = false) {
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7)
  doc.setTextColor(...GRAY_DARK)
  doc.text(text, x, y)
  doc.setFont('helvetica', bold ? 'bold' : 'normal')
  doc.text(String(value || '—'), x + doc.getTextWidth(text) + 1.5, y)
}

// ── Exportar PDF (tabla completa) ─────────────────────────────────────────────
function exportAllPDF () {
  const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' })
  const W = 297

  doc.setFillColor(...BLUE_DARK)
  doc.rect(0, 0, W, 22, 'F')
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(13)
  doc.text('I.E.F El Arenal – CEMBA', 14, 10)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(9)
  doc.text('Libro de Reclamaciones', 14, 17)

  const now = new Date()
  const fechaExp = now.toLocaleDateString('es-PE', { day: '2-digit', month: 'long', year: 'numeric' })
  doc.text(`Exportado el: ${fechaExp}`, W - 14, 10, { align: 'right' })
  doc.text(`Total: ${filtered.value.length} reclamación(es)`, W - 14, 17, { align: 'right' })

  autoTable(doc, {
    startY: 26,
    head: [['#', 'Fecha', 'Nombre', 'DNI', 'Teléfono', 'Tipo', 'Subtipo', 'Detalle', 'Pedido']],
    body: filtered.value.map((r, i) => [
      i + 1,
      formatDate(r.fecha),
      r.nombre,
      r.dni,
      r.telefono,
      r.tipo,
      r.subtipo,
      r.detalle,
      r.pedido || '—',
    ]),
    styles: { fontSize: 7.5, cellPadding: 2.5, valign: 'middle', overflow: 'linebreak' },
    headStyles: { fillColor: BLUE_DARK, textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: BLUE_LIGHT },
    columnStyles: {
      0: { cellWidth: 8,  halign: 'center' },
      1: { cellWidth: 22 },
      2: { cellWidth: 38 },
      3: { cellWidth: 22 },
      4: { cellWidth: 26 },
      5: { cellWidth: 20, halign: 'center' },
      6: { cellWidth: 20, halign: 'center' },
      7: { cellWidth: 'auto' },
      8: { cellWidth: 40 },
    },
    didDrawPage (data) {
      const pageCount = doc.internal.getNumberOfPages()
      doc.setFontSize(7); doc.setTextColor(150)
      doc.text(`Página ${data.pageNumber} de ${pageCount}`, W / 2, 205, { align: 'center' })
    }
  })

  doc.save(`libro_reclamaciones_${now.toISOString().slice(0, 10)}.pdf`)
}

// ── Carga el logo de la institución como PNG base64 ───────────────────────────
async function loadLogoB64 () {
  return new Promise((resolve) => {
    const img = new Image()
    img.crossOrigin = 'anonymous'
    img.onload = () => {
      const canvas = document.createElement('canvas')
      canvas.width  = img.naturalWidth  || 128
      canvas.height = img.naturalHeight || 128
      const ctx = canvas.getContext('2d')
      ctx.drawImage(img, 0, 0)
      resolve(canvas.toDataURL('image/png'))
    }
    img.onerror = () => resolve(null)
    img.src = '/cemba.webp'
  })
}

// Helper: dibuja una palomita (tick) con líneas sobre un punto central ────────
function drawTick (doc, cx, cy, size, color) {
  doc.setDrawColor(...color)
  doc.setLineWidth(0.9)
  doc.line(cx - size * 0.5, cy,              cx - size * 0.1, cy + size * 0.4)
  doc.line(cx - size * 0.1, cy + size * 0.4, cx + size * 0.5, cy - size * 0.35)
  doc.setLineWidth(0.2)
}

// Helper: dibuja una X con líneas sobre un punto central ──────────────────────
function drawCross (doc, cx, cy, size, color) {
  doc.setDrawColor(...color)
  doc.setLineWidth(0.9)
  doc.line(cx - size * 0.38, cy - size * 0.38, cx + size * 0.38, cy + size * 0.38)
  doc.line(cx + size * 0.38, cy - size * 0.38, cx - size * 0.38, cy + size * 0.38)
  doc.setLineWidth(0.2)
}

// ── Exportar PDF individual ───────────────────────────────────────────────────
async function exportRowPDF (rec) {
  const logoB64 = await loadLogoB64()

  const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' })
  const W  = 210
  const M  = 14
  const CW = W - M * 2
  let y = 0

  // Paleta
  const C_DARK   = [30,  58,  138]   // azul oscuro principal
  const C_MID    = [37,  99,  235]   // azul medio
  const C_ACCENT = [96,  165, 250]   // azul claro — borde acento
  const C_BG     = [241, 245, 255]   // fondo celda
  const C_TXT    = [30,  41,  59]    // texto oscuro
  const C_MUTED  = [100, 116, 139]   // texto secundario
  const C_BORDER = [203, 213, 225]   // borde celda

  // ── 1. ENCABEZADO MEJORADO ─────────────────────────────────────────────────
  // Banda principal
  doc.setFillColor(...C_DARK)
  doc.rect(0, 0, W, 36, 'F')

  // Franja decorativa inferior del encabezado
  doc.setFillColor(...C_MID)
  doc.rect(0, 32, W, 3, 'F')
  doc.setFillColor(...C_ACCENT)
  doc.rect(0, 34.5, W, 1, 'F')

  // Logo (si disponible) — 20×20 mm, esquina izquierda centrado verticalmente
  const logoSize = 22
  const logoX = M
  const logoY = (32 - logoSize) / 2 + 1
  if (logoB64) {
    // Fondo circular blanco detrás del logo
    doc.setFillColor(255, 255, 255)
    doc.roundedRect(logoX - 1, logoY - 1, logoSize + 2, logoSize + 2, 3, 3, 'F')
    try { doc.addImage(logoB64, 'PNG', logoX, logoY, logoSize, logoSize) } catch (_) {}
  }

  // Texto centrado (desplazado si hay logo)
  const txtX = logoB64 ? logoX + logoSize + 5 : M
  const txtW = logoB64 ? W - txtX - M : W
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(11.5)
  doc.text('I.E.F. EL ARENAL – CEMBA', txtX + txtW / 2, 11, { align: 'center' })
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(8.5)
  doc.text('Libro de Reclamaciones', txtX + txtW / 2, 17.5, { align: 'center' })
  doc.setFontSize(7)
  doc.setTextColor(180, 210, 255)
  doc.text('Hoja de Reclamación Individual', txtX + txtW / 2, 23, { align: 'center' })

  // N° ficha y fecha (below titles)
  doc.setFont('helvetica', 'bold'); doc.setFontSize(8); doc.setTextColor(220, 234, 255)
  doc.text(`N° ${String(rec.id).padStart(6, '0')}`, M, 31)
  doc.text(formatDate(rec.fecha), W - M, 31, { align: 'right' })

  y = 42

  // Helper local: sección header con barra de acento izquierda
  function sectionBar (title, sY) {
    doc.setFillColor(...C_DARK)
    doc.rect(M, sY, CW, 6.5, 'F')
    // Barra acento izquierda
    doc.setFillColor(...C_ACCENT)
    doc.rect(M, sY, 2.5, 6.5, 'F')
    doc.setTextColor(255, 255, 255)
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(7.5)
    doc.text(title, M + 5, sY + 4.3)
    return sY + 6.5
  }

  function dataRow (sY, h = 7) {
    drawRect(doc, M, sY, CW, h, C_BG, C_BORDER)
    return sY
  }

  // ── 2. SECCIÓN 1: IDENTIFICACIÓN ──────────────────────────────────────────
  y = sectionBar('1. IDENTIFICACIÓN DEL RECLAMANTE', y)

  // Nombre
  dataRow(y)
  doc.setTextColor(...C_TXT); doc.setFont('helvetica', 'bold'); doc.setFontSize(6.5)
  doc.text('NOMBRE:', M + 3, y + 4.5)
  doc.setFont('helvetica', 'normal'); doc.setFontSize(8)
  doc.text(String(rec.nombre || '—'), M + 22, y + 4.5)
  y += 7

  // DNI | Teléfono
  const half = CW / 2
  drawRect(doc, M,        y, half, 7, C_BG, C_BORDER)
  drawRect(doc, M + half, y, half, 7, C_BG, C_BORDER)
  doc.setFont('helvetica', 'bold'); doc.setFontSize(6.5); doc.setTextColor(...C_TXT)
  doc.text('DNI / CE:', M + 3, y + 4.5)
  doc.setFont('helvetica', 'normal'); doc.setFontSize(8)
  doc.text(String(rec.dni || '—'), M + 20, y + 4.5)
  doc.setFont('helvetica', 'bold'); doc.setFontSize(6.5)
  doc.text('TELÉFONO:', M + half + 3, y + 4.5)
  doc.setFont('helvetica', 'normal'); doc.setFontSize(8)
  doc.text(String(rec.telefono || '—'), M + half + 24, y + 4.5)
  y += 7

  // ── 3. SECCIÓN 2: TIPO DE RECLAMO ─────────────────────────────────────────
  y = sectionBar('2. IDENTIFICACIÓN DEL RECLAMO', y)

  // Fila con checkboxes Producto / Servicio
  const cbRowH = 9
  drawRect(doc, M, y, CW, cbRowH, C_BG, C_BORDER)

  const cbSz = 4.5   // tamaño caja
  const cbYc = y + cbRowH / 2  // centro vertical de la fila
  const cb1X = M + 6            // inicio PRODUCTO
  const cb2X = M + 70           // inicio SERVICIO

  const tipoProd = rec.tipo === 'producto'
  const tipoSvc  = rec.tipo === 'servicio'

  // — PRODUCTO —
  // Caja
  if (tipoProd) {
    doc.setFillColor(...C_BG)
    doc.setDrawColor(22, 163, 74)
    doc.rect(cb1X, cbYc - cbSz / 2, cbSz, cbSz, 'FD')
    drawCross(doc, cb1X + cbSz / 2, cbYc, cbSz, [22, 163, 74]) // Green X
  } else {
    doc.setFillColor(...C_BG)
    doc.setDrawColor(...C_BORDER) // Gray border, empty inside
    doc.rect(cb1X, cbYc - cbSz / 2, cbSz, cbSz, 'FD')
  }
  doc.setTextColor(...C_TXT); doc.setFont('helvetica', tipoProd ? 'bold' : 'normal'); doc.setFontSize(8)
  doc.text('PRODUCTO', cb1X + cbSz + 2.5, cbYc + 1.5)

  // — SERVICIO —
  if (tipoSvc) {
    doc.setFillColor(...C_BG)
    doc.setDrawColor(22, 163, 74)
    doc.rect(cb2X, cbYc - cbSz / 2, cbSz, cbSz, 'FD')
    drawCross(doc, cb2X + cbSz / 2, cbYc, cbSz, [22, 163, 74]) // Green X
  } else {
    doc.setFillColor(...C_BG)
    doc.setDrawColor(...C_BORDER) // Gray border, empty inside
    doc.rect(cb2X, cbYc - cbSz / 2, cbSz, cbSz, 'FD')
  }
  doc.setTextColor(...C_TXT); doc.setFont('helvetica', tipoSvc ? 'bold' : 'normal'); doc.setFontSize(8)
  doc.text('SERVICIO', cb2X + cbSz + 2.5, cbYc + 1.5)

  y += cbRowH

  // Descripción del bien/servicio (si existe)
  if (rec.desc_bien) {
    drawRect(doc, M, y, CW, 7, C_BG, C_BORDER)
    doc.setFont('helvetica', 'bold'); doc.setFontSize(6.5); doc.setTextColor(...C_TXT)
    doc.text('DESCRIPCIÓN:', M + 3, y + 4.5)
    doc.setFont('helvetica', 'normal'); doc.setFontSize(7.5)
    doc.text(String(rec.desc_bien), M + 30, y + 4.5)
    y += 7
  }

  // ── 4. SECCIÓN 3: DETALLE ─────────────────────────────────────────────────
  // Título de sección + texto simple Reclamo/Queja
  const isReclamo = rec.subtipo === 'reclamo'

  doc.setFillColor(...C_DARK)
  doc.rect(M, y, CW, 6.5, 'F')
  doc.setFillColor(...C_ACCENT)
  doc.rect(M, y, 2.5, 6.5, 'F')
  
  doc.setTextColor(255, 255, 255); doc.setFont('helvetica', 'bold'); doc.setFontSize(7.5)
  // El título cambia dinámicamente según si es reclamo o queja
  doc.text(`3. DETALLE DE LA ${isReclamo ? 'RECLAMACIÓN' : 'QUEJA'}`, M + 5, y + 4.3)

  y += 6.5

  // Área de texto del detalle
  const detalleH = 38
  drawRect(doc, M, y, CW, detalleH, [248, 250, 253], C_BORDER)
  doc.setTextColor(...C_MUTED); doc.setFont('helvetica', 'normal'); doc.setFontSize(7.5)
  const dLines = doc.splitTextToSize(rec.detalle || '—', CW - 6)
  doc.text(dLines, M + 3, y + 5)
  y += detalleH

  // ── 5. SECCIÓN 4: PEDIDO ──────────────────────────────────────────────────
  if (rec.pedido) {
    y = sectionBar('4. PEDIDO DEL RECLAMANTE', y)
    const pedidoH = 22
    drawRect(doc, M, y, CW, pedidoH, [248, 250, 253], C_BORDER)
    doc.setTextColor(...C_MUTED); doc.setFont('helvetica', 'normal'); doc.setFontSize(7.5)
    const pLines = doc.splitTextToSize(rec.pedido, CW - 6)
    doc.text(pLines, M + 3, y + 5)
    y += pedidoH
  }

  // ── 6. SECCIÓN 5: FIRMA + DNI ─────────────────────────────────────────────
  y = sectionBar(rec.pedido ? '5. FIRMA DEL RECLAMANTE' : '4. FIRMA DEL RECLAMANTE', y)

  const sigCol = CW * 0.58
  const dniCol = CW * 0.42
  const sigH   = 44

  // Panel firma
  drawRect(doc, M, y, sigCol, sigH, [248, 250, 253], C_BORDER)
  if (rec.firma) {
    try { doc.addImage(rec.firma, 'PNG', M + 2, y + 2, sigCol - 4, sigH - 14) } catch (_) {}
  }
  doc.setDrawColor(...C_ACCENT)
  doc.setLineWidth(0.4)
  doc.line(M + 6, y + sigH - 9, M + sigCol - 6, y + sigH - 9)
  doc.setLineWidth(0.2)
  doc.setFont('helvetica', 'normal'); doc.setFontSize(6); doc.setTextColor(...C_MUTED)
  doc.text('Firma del Docente / Reclamante', M + sigCol / 2, y + sigH - 4.5, { align: 'center' })

  // Panel DNI — visualmente destacado
  const dniX = M + sigCol + 2
  const dniW = dniCol - 2
  drawRect(doc, dniX, y, dniW, sigH, C_BG, C_BORDER)
  // Línea acento arriba
  doc.setFillColor(...C_MID)
  doc.rect(dniX, y, dniW, 2, 'F')

  doc.setTextColor(...C_TXT); doc.setFont('helvetica', 'bold'); doc.setFontSize(6.5)
  doc.text('N° DE IDENTIFICACIÓN', dniX + dniW / 2, y + 8, { align: 'center' })
  doc.setFont('helvetica', 'bold'); doc.setFontSize(13); doc.setTextColor(...C_DARK)
  doc.text(String(rec.dni || '—'), dniX + dniW / 2, y + 22, { align: 'center' })
  doc.setFont('helvetica', 'normal'); doc.setFontSize(6); doc.setTextColor(...C_MUTED)
  doc.text('DNI / CE', dniX + dniW / 2, y + 28, { align: 'center' })
  y += sigH + 3

  // ── 7. SECCIÓN: ACCIONES DE LA INSTITUCIÓN ────────────────────────────────
  if (y < 248) {
    const secLabel = rec.pedido ? '6. ACCIONES ADOPTADAS POR LA INSTITUCIÓN'
                                : '5. ACCIONES ADOPTADAS POR LA INSTITUCIÓN'
    y = sectionBar(secLabel, y)
    const actH = Math.min(28, 278 - y)
    drawRect(doc, M, y, CW, actH, [248, 250, 252], C_BORDER)
    doc.setFont('helvetica', 'italic'); doc.setFontSize(7); doc.setTextColor(190, 200, 215)
    doc.text('(Uso exclusivo de la institución)', M + CW / 2, y + actH / 2, { align: 'center' })
    y += actH + 3

    // Firma proveedor (opcional)
    if (y < 278) {
      const provH = 26
      const provX = M + CW / 2 + 2
      const provW = CW / 2 - 2
      drawRect(doc, provX, y, provW, provH, [248, 250, 252], C_BORDER)
      doc.setDrawColor(...C_ACCENT); doc.setLineWidth(0.4)
      doc.line(provX + 6, y + provH - 9, provX + provW - 6, y + provH - 9)
      doc.setLineWidth(0.2)
      doc.setFont('helvetica', 'normal'); doc.setFontSize(6); doc.setTextColor(...C_MUTED)
      doc.text('Firma del Proveedor (Opcional)', provX + provW / 2, y + provH - 4.5, { align: 'center' })
    }
  }

  // ── 8. PIE DE PÁGINA ──────────────────────────────────────────────────────
  const fY = 287
  doc.setFillColor(...C_DARK)
  doc.rect(0, fY - 1, W, 11, 'F')
  doc.setFillColor(...C_MID); doc.rect(0, fY - 1, W, 1.5, 'F')
  doc.setTextColor(200, 220, 255); doc.setFont('helvetica', 'normal'); doc.setFontSize(6.5)
  doc.text('I.E.F. El Arenal – CEMBA  |  Libro de Reclamaciones', W / 2, fY + 5.5, { align: 'center' })
  doc.setTextColor(160, 195, 255)
  doc.text(`Generado: ${new Date().toLocaleDateString('es-PE', { day: '2-digit', month: 'long', year: 'numeric' })}`, M, fY + 5.5)
  doc.text(`N° ${String(rec.id).padStart(6, '0')}`, W - M, fY + 5.5, { align: 'right' })

  doc.save(`reclamacion_${String(rec.id).padStart(6, '0')}_${formatDate(rec.fecha).replace(/\//g, '-')}.pdf`)
}
</script>

<style scoped>
*, *::before, *::after { box-sizing: border-box; }

/* ── Layout ─────────────────────────────────────────────────────────────── */
.rv-container {
  min-height: calc(100vh - 48px);
  background: linear-gradient(145deg, #eff6ff 0%, #f0f7ff 50%, #e8f0fe 100%);
  padding: 2rem 1.5rem;
  font-family: 'Inter', 'Segoe UI', sans-serif;
}

/* ── Header ─────────────────────────────────────────────────────────────── */
.rv-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1.5rem;
}
.rv-header h1 {
  font-size: 1.4rem;
  font-weight: 800;
  color: #1e3a8a;
  margin: 0 0 0.2rem;
}
.rv-subtitle {
  font-size: 0.82rem;
  font-weight: 600;
  color: #6b7280;
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.6px;
}

/* ── Botón exportar ─────────────────────────────────────────────────────── */
.btn-pdf {
  display: flex;
  align-items: center;
  gap: 0.45rem;
  background: linear-gradient(135deg, #1e3a8a, #2563eb);
  color: #fff;
  border: none;
  border-radius: 10px;
  padding: 0.6rem 1.2rem;
  font-size: 0.85rem;
  font-weight: 700;
  cursor: pointer;
  font-family: inherit;
  box-shadow: 0 4px 12px rgba(37,99,235,0.3);
  transition: opacity 0.2s, transform 0.15s;
}
.btn-pdf:hover:not(:disabled) { transform: translateY(-1px); opacity: 0.92; }
.btn-pdf:disabled { opacity: 0.45; cursor: not-allowed; }

/* ── Filtros ────────────────────────────────────────────────────────────── */
.rv-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  align-items: flex-end;
  background: #fff;
  border: 1px solid #bfdbfe;
  border-radius: 12px;
  padding: 1rem 1.2rem;
  margin-bottom: 1.5rem;
}
.filter-group {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  min-width: 120px;
}
.filter-group label {
  font-size: 0.75rem;
  font-weight: 700;
  color: #374151;
  letter-spacing: 0.2px;
}
.filter-group input,
.filter-group select {
  background: #f9fafb;
  border: 1.5px solid #d1d5db;
  border-radius: 8px;
  padding: 0.45rem 0.7rem;
  font-size: 0.82rem;
  color: #111827;
  font-family: inherit;
  transition: border-color 0.2s;
}
.filter-group input:focus,
.filter-group select:focus {
  outline: none;
  border-color: #2563eb;
  box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}

.btn-clear-filters {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  background: #f3f4f6;
  color: #6b7280;
  border: 1.5px solid #d1d5db;
  border-radius: 8px;
  padding: 0.45rem 0.85rem;
  font-size: 0.8rem;
  font-weight: 600;
  cursor: pointer;
  font-family: inherit;
  align-self: flex-end;
  transition: background 0.2s;
}
.btn-clear-filters:hover { background: #e5e7eb; color: #374151; }

/* ── Estado ─────────────────────────────────────────────────────────────── */
.rv-state {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  justify-content: center;
  padding: 3rem;
  font-size: 0.9rem;
  color: #6b7280;
}
.rv-state--error { color: #dc2626; }

/* ── Tabla ──────────────────────────────────────────────────────────────── */
.rv-table-wrap {
  background: #fff;
  border: 1px solid #bfdbfe;
  border-radius: 12px;
  overflow-x: auto;
  box-shadow: 0 4px 20px rgba(37,99,235,0.07);
}
.rv-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.82rem;
  color: #111827;
}
.rv-table thead tr {
  background: linear-gradient(135deg, #1e3a8a, #2563eb);
  color: #fff;
}
.rv-table th {
  padding: 0.75rem 0.9rem;
  text-align: left;
  font-weight: 700;
  font-size: 0.78rem;
  letter-spacing: 0.3px;
  white-space: nowrap;
}
.rv-table tbody tr {
  border-bottom: 1px solid #e5e7eb;
  transition: background 0.15s;
}
.rv-table tbody tr:hover { background: #eff6ff; }
.rv-table tbody tr:last-child { border-bottom: none; }
.rv-table td {
  padding: 0.65rem 0.9rem;
  vertical-align: middle;
}

.td-center  { text-align: center; }
.td-nowrap  { white-space: nowrap; }
.td-detalle { max-width: 220px; color: #4b5563; font-size: 0.78rem; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.td-empty   { color: #d1d5db; }

/* ── Badges ─────────────────────────────────────────────────────────────── */
.badge {
  display: inline-block;
  padding: 0.18rem 0.6rem;
  border-radius: 99px;
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.4px;
}
.badge--blue   { background: #dbeafe; color: #1d4ed8; }
.badge--indigo { background: #e0e7ff; color: #4338ca; }
.badge--amber  { background: #fef3c7; color: #b45309; }
.badge--rose   { background: #ffe4e6; color: #be123c; }

/* ── Botón PDF por fila ─────────────────────────────────────────────────── */
.th-action { width: 60px; text-align: center; }
.btn-row-pdf {
  display: inline-flex;
  align-items: center;
  gap: 0.3rem;
  background: linear-gradient(135deg, #1e3a8a, #2563eb);
  color: #fff;
  border: none;
  border-radius: 7px;
  padding: 0.32rem 0.65rem;
  font-size: 0.74rem;
  font-weight: 700;
  cursor: pointer;
  font-family: inherit;
  box-shadow: 0 2px 6px rgba(37,99,235,0.3);
  transition: opacity 0.18s, transform 0.12s;
}
.btn-row-pdf:hover { opacity: 0.88; transform: translateY(-1px); }

/* ── Miniatura firma ────────────────────────────────────────────────────── */
.thumb-sig {
  width: 52px;
  height: 32px;
  object-fit: contain;
  border-radius: 5px;
  border: 1.5px solid #bfdbfe;
  background: #f9fafb;
  cursor: zoom-in;
  transition: transform 0.15s, box-shadow 0.15s;
}
.thumb-sig:hover {
  transform: scale(1.08);
  box-shadow: 0 3px 10px rgba(37,99,235,0.2);
}

/* ── Paginación ─────────────────────────────────────────────────────────── */
.rv-pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  margin-top: 1.2rem;
  font-size: 0.85rem;
  color: #374151;
  font-weight: 600;
}
.rv-pagination button {
  display: flex;
  align-items: center;
  background: #fff;
  border: 1.5px solid #bfdbfe;
  border-radius: 8px;
  padding: 0.38rem 0.6rem;
  cursor: pointer;
  color: #2563eb;
  transition: background 0.15s;
}
.rv-pagination button:hover:not(:disabled) { background: #eff6ff; }
.rv-pagination button:disabled { opacity: 0.35; cursor: not-allowed; }

/* ── Total ──────────────────────────────────────────────────────────────── */
.rv-total {
  text-align: right;
  font-size: 0.78rem;
  color: #9ca3af;
  margin-top: 0.6rem;
}
.rv-total strong { color: #374151; }

/* ── Spinner ────────────────────────────────────────────────────────────── */
.spinner {
  display: inline-block;
  width: 16px; height: 16px;
  border: 2px solid #bfdbfe;
  border-top-color: #2563eb;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Modal ──────────────────────────────────────────────────────────────── */
.modal-backdrop {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.55);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
  padding: 1rem;
}
.modal-box {
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  max-width: 90vw;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 20px 60px rgba(0,0,0,0.35);
}
.modal-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.7rem 1rem;
  background: #1e3a8a;
  color: #fff;
}
.modal-title { font-size: 0.85rem; font-weight: 600; }
.modal-close {
  background: none;
  border: none;
  color: #fff;
  font-size: 1.4rem;
  cursor: pointer;
  line-height: 1;
  padding: 0 0.2rem;
}
.modal-img {
  max-width: 100%;
  max-height: calc(90vh - 48px);
  object-fit: contain;
}

/* ── Transición modal ───────────────────────────────────────────────────── */
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity 0.2s; }
.modal-fade-enter-from,  .modal-fade-leave-to      { opacity: 0; }

/* ── Responsive ─────────────────────────────────────────────────────────── */
@media (max-width: 640px) {
  .rv-container { padding: 1rem; }
  .rv-header { flex-direction: column; align-items: flex-start; }
  .rv-header h1 { font-size: 1.1rem; }
  .rv-filters { padding: 0.85rem; gap: 0.6rem; }
  .filter-group { min-width: 100px; }
}
</style>
