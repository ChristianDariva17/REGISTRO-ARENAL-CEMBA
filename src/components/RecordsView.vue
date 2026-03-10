<template>
  <div class="rv-container">

    <!-- Encabezado -->
    <div class="rv-header">
      <div class="rv-header__left">
        <h1>Registros de Limpieza</h1>
        <p class="rv-subtitle">I.E.F El Arenal – CEMBA</p>
      </div>
      <button class="btn-pdf" @click="exportPDF" :disabled="loading || filtered.length === 0">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
          <path fill-rule="evenodd" d="M3 17a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm3.293-7.707a1 1 0 011.414 0L9 10.586V3a1 1 0 112 0v7.586l1.293-1.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd"/>
        </svg>
        Exportar PDF
      </button>
    </div>

    <!-- Filtros -->
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
        <label>Área</label>
        <input type="text" v-model="filters.area" placeholder="Ej. Aula 101" />
      </div>
      <div class="filter-group">
        <label>Grado</label>
        <input type="text" v-model="filters.grado" placeholder="Ej. 2°" />
      </div>
      <div class="filter-group">
        <label>Sección</label>
        <input type="text" v-model="filters.seccion" placeholder="Ej. A" />
      </div>
      <div class="filter-group">
        <label>Docente</label>
        <input type="text" v-model="filters.docente" placeholder="Nombre..." />
      </div>
      <button class="btn-clear-filters" @click="clearFilters" title="Limpiar filtros">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" width="14" height="14">
          <path d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"/>
        </svg>
        Limpiar
      </button>
    </div>

    <!-- Estado de carga / error -->
    <div v-if="loading" class="rv-state">
      <span class="spinner"></span> Cargando registros...
    </div>
    <div v-else-if="errorMsg" class="rv-state rv-state--error">{{ errorMsg }}</div>
    <div v-else-if="filtered.length === 0" class="rv-state">No se encontraron registros.</div>

    <!-- Tabla -->
    <div v-else class="rv-table-wrap">
      <table class="rv-table">
        <thead>
          <tr>
            <th>#</th>
            <th>Fecha</th>
            <th>Hora</th>
            <th>Área</th>
            <th>Grado</th>
            <th>Sección</th>
            <th>Docente</th>
            <th>Tarea realizada</th>
            <th>Firma</th>
            <th>Evidencia</th>
            <th class="th-action">PDF</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(rec, i) in paginated" :key="rec.id">
            <td class="td-center">{{ (currentPage - 1) * perPage + i + 1 }}</td>
            <td class="td-nowrap">{{ formatDate(rec.fecha) }}</td>
            <td class="td-nowrap">{{ rec.hora?.slice(0,5) }}</td>
            <td>{{ rec.area }}</td>
            <td class="td-center">{{ rec.grado }}</td>
            <td class="td-center">{{ rec.seccion }}</td>
            <td class="td-nowrap">{{ rec.docente }}</td>
            <td class="td-tarea">{{ rec.tarea_realizada }}</td>
            <td class="td-center">
              <img
                v-if="rec.firma"
                :src="rec.firma"
                class="thumb-sig"
                @click="openModal(rec.firma, 'firma')"
                title="Ver firma"
              />
              <span v-else class="td-empty">—</span>
            </td>
            <td class="td-center">
              <img
                v-if="rec.evidencia_url"
                :src="rec.evidencia_url"
                class="thumb-img"
                @click="openModal(rec.evidencia_url, rec.evidencia_nombre)"
                title="Ver evidencia"
              />
              <span v-else class="td-empty">—</span>
            </td>
            <td class="td-center">
              <button class="btn-row-pdf" @click="exportRowPDF(rec)" title="Descargar PDF de este registro">
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

    <!-- Paginación -->
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

    <!-- Total -->
    <div class="rv-total" v-if="!loading && filtered.length > 0">
      Total: <strong>{{ filtered.length }}</strong> registro(s)
    </div>

    <!-- Modal imagen / firma -->
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

async function fetchAll() {
  loading.value = true
  errorMsg.value = ''
  const { data, error } = await supabase
    .from('registro_limpieza')
    .select('id, fecha, hora, area, grado, seccion, docente, firma, tarea_realizada, evidencia_url, evidencia_nombre')
    .order('fecha', { ascending: false })
    .order('hora', { ascending: false })
  loading.value = false
  if (error) { errorMsg.value = `Error al cargar: ${error.message}`; return }
  records.value = data || []
}

onMounted(fetchAll)

// ── Filtros ──────────────────────────────────────────────────────────────────
const filters = reactive({ desde: '', hasta: '', area: '', grado: '', seccion: '', docente: '' })

function clearFilters() {
  Object.assign(filters, { desde: '', hasta: '', area: '', grado: '', seccion: '', docente: '' })
}

const filtered = computed(() => {
  return records.value.filter(r => {
    if (filters.desde && r.fecha < filters.desde) return false
    if (filters.hasta && r.fecha > filters.hasta) return false
    if (filters.area    && !r.area?.toLowerCase().includes(filters.area.toLowerCase()))       return false
    if (filters.grado   && !r.grado?.toLowerCase().includes(filters.grado.toLowerCase()))     return false
    if (filters.seccion && !r.seccion?.toLowerCase().includes(filters.seccion.toLowerCase())) return false
    if (filters.docente && !r.docente?.toLowerCase().includes(filters.docente.toLowerCase())) return false
    return true
  })
})

// ── Paginación ───────────────────────────────────────────────────────────────
const perPage     = 10
const currentPage = ref(1)

watch(filters, () => { currentPage.value = 1 })

const totalPages = computed(() => Math.ceil(filtered.value.length / perPage))
const paginated  = computed(() => {
  const start = (currentPage.value - 1) * perPage
  return filtered.value.slice(start, start + perPage)
})

// ── Formato ──────────────────────────────────────────────────────────────────
function formatDate(d) {
  if (!d) return ''
  const [y, m, day] = d.split('-')
  return `${day}/${m}/${y}`
}

// ── Modal ────────────────────────────────────────────────────────────────────
const modal = reactive({ open: false, src: '', label: '' })
function openModal(src, label) { modal.src = src; modal.label = label || 'Imagen'; modal.open = true }
function closeModal() { modal.open = false; modal.src = ''; modal.label = '' }

// ── Exportar PDF (tabla completa) ─────────────────────────────────────────────
function exportPDF() {
  const doc = new jsPDF({ orientation: 'landscape', unit: 'mm', format: 'a4' })

  // Encabezado
  doc.setFillColor(30, 58, 138)
  doc.rect(0, 0, 297, 22, 'F')
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(13)
  doc.text('I.E.F El Arenal – CEMBA', 14, 10)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(9)
  doc.text('Registro de Control de Limpieza', 14, 17)

  const now = new Date()
  const fechaExport = now.toLocaleDateString('es-PE', { day: '2-digit', month: 'long', year: 'numeric' })
  doc.text(`Exportado el: ${fechaExport}`, 297 - 14, 10, { align: 'right' })
  doc.text(`Total de registros: ${filtered.value.length}`, 297 - 14, 17, { align: 'right' })

  // Tabla
  autoTable(doc, {
    startY: 26,
    head: [[
      '#', 'Fecha', 'Hora', 'Área', 'Grado', 'Sección', 'Docente', 'Tarea Realizada'
    ]],
    body: filtered.value.map((r, i) => [
      i + 1,
      formatDate(r.fecha),
      r.hora?.slice(0, 5) || '',
      r.area,
      r.grado,
      r.seccion,
      r.docente,
      r.tarea_realizada
    ]),
    styles: { fontSize: 8, cellPadding: 3, valign: 'middle', overflow: 'linebreak' },
    headStyles: { fillColor: [30, 58, 138], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [239, 246, 255] },
    columnStyles: {
      0: { cellWidth: 10, halign: 'center' },
      1: { cellWidth: 22 },
      2: { cellWidth: 15 },
      3: { cellWidth: 35 },
      4: { cellWidth: 18, halign: 'center' },
      5: { cellWidth: 18, halign: 'center' },
      6: { cellWidth: 40 },
      7: { cellWidth: 'auto' }
    },
    didDrawPage(data) {
      const pageCount = doc.internal.getNumberOfPages()
      doc.setFontSize(7)
      doc.setTextColor(150)
      doc.text(`Página ${data.pageNumber} de ${pageCount}`, 297 / 2, 205, { align: 'center' })
    }
  })

  doc.save(`registros_limpieza_${now.toISOString().slice(0,10)}.pdf`)
}

// ── Exportar PDF individual por registro ──────────────────────────────────────
async function exportRowPDF(rec) {
  const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' })
  const W = 210   // ancho A4
  const M = 14    // margen lateral
  const CW = W - M * 2  // ancho de contenido
  let y = 10

  // ── Colores institucionales ──
  const BLUE_DARK  = [30,  58,  138]
  const BLUE_MID   = [37,  99,  235]
  const BLUE_LIGHT = [219, 234, 254]
  const GRAY_TITLE = [55,  65,  81]
  const GRAY_TEXT  = [75,  85,  99]

  // Helper: rectángulo con borde
  function rect(x, _y, w, h, fill, stroke) {
    if (fill)   { doc.setFillColor(...fill);   doc.rect(x, _y, w, h, 'F') }
    if (stroke) { doc.setDrawColor(...stroke); doc.rect(x, _y, w, h, 'S') }
  }

  // Helper: texto cortado a un ancho máximo (en mm)
  function textWrap(text, x, _y, maxW, lineH = 5) {
    const lines = doc.splitTextToSize(String(text || '—'), maxW)
    doc.text(lines, x, _y)
    return _y + lines.length * lineH
  }

  // ── 1. ENCABEZADO: banda azul oscura ──────────────────────────────────────
  rect(0, 0, W, 28, BLUE_DARK)

  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(11)
  doc.text('I.E.F. EL ARENAL – CEMBA', W / 2, 9, { align: 'center' })
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(8.5)
  doc.text('Registro de Control de Limpieza', W / 2, 15, { align: 'center' })
  doc.setFontSize(7)
  doc.text('Área de Gestión Institucional', W / 2, 21, { align: 'center' })

  // Número de ficha (ID del registro)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7.5)
  doc.text(`N° ${String(rec.id).padStart(6, '0')}`, M, 22)

  y = 33

  // ── 2. SECCIÓN 1: DATOS GENERALES ────────────────────────────────────────
  rect(M, y, CW, 6, BLUE_DARK)
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7.5)
  doc.text('1. IDENTIFICACIÓN DEL ÁREA', M + 2, y + 4)
  y += 6

  // Fila: Fecha | Hora
  rect(M, y, CW / 2, 7, [249, 250, 251], [200, 200, 200])
  rect(M + CW / 2, y, CW / 2, 7, [249, 250, 251], [200, 200, 200])
  doc.setTextColor(...GRAY_TITLE)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7)
  doc.text('FECHA:', M + 2, y + 4.5)
  doc.setFont('helvetica', 'normal')
  doc.text(formatDate(rec.fecha), M + 18, y + 4.5)
  doc.setFont('helvetica', 'bold')
  doc.text('HORA:', M + CW / 2 + 2, y + 4.5)
  doc.setFont('helvetica', 'normal')
  doc.text(rec.hora?.slice(0, 5) || '—', M + CW / 2 + 16, y + 4.5)
  y += 7

  // Fila: Área (fila completa)
  rect(M, y, CW, 7, null, [200, 200, 200])
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7)
  doc.text('ÁREA:', M + 2, y + 4.5)
  doc.setFont('helvetica', 'normal')
  doc.text(rec.area || '—', M + 14, y + 4.5)
  y += 7

  // Fila: Grado | Sección
  rect(M, y, CW / 2, 7, null, [200, 200, 200])
  rect(M + CW / 2, y, CW / 2, 7, null, [200, 200, 200])
  doc.setFont('helvetica', 'bold')
  doc.text('GRADO:', M + 2, y + 4.5)
  doc.setFont('helvetica', 'normal')
  doc.text(rec.grado || '—', M + 18, y + 4.5)
  doc.setFont('helvetica', 'bold')
  doc.text('SECCIÓN:', M + CW / 2 + 2, y + 4.5)
  doc.setFont('helvetica', 'normal')
  doc.text(rec.seccion || '—', M + CW / 2 + 22, y + 4.5)
  y += 7

  // ── 3. SECCIÓN 2: DOCENTE RESPONSABLE ────────────────────────────────────
  rect(M, y, CW, 6, BLUE_DARK)
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7.5)
  doc.text('2. DOCENTE RESPONSABLE', M + 2, y + 4)
  y += 6

  rect(M, y, CW, 7, null, [200, 200, 200])
  doc.setTextColor(...GRAY_TITLE)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7)
  doc.text('NOMBRE:', M + 2, y + 4.5)
  doc.setFont('helvetica', 'normal')
  doc.text(rec.docente || '—', M + 22, y + 4.5)
  y += 7

  // ── 4. SECCIÓN 3: TAREAS REALIZADAS ─────────────────────────────────────
  rect(M, y, CW, 6, BLUE_DARK)
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7.5)
  doc.text('3. DETALLE DE TAREAS REALIZADAS', M + 2, y + 4)
  y += 6

  const tareaBoxH = 34
  rect(M, y, CW, tareaBoxH, [249, 250, 251], [200, 200, 200])
  doc.setTextColor(...GRAY_TEXT)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(7.5)
  const tareaLines = doc.splitTextToSize(rec.tarea_realizada || '—', CW - 6)
  doc.text(tareaLines, M + 3, y + 5)
  y += tareaBoxH

  // ── 5. SECCIÓN 4: FIRMA Y EVIDENCIA (2 columnas) ─────────────────────────
  rect(M, y, CW, 6, BLUE_DARK)
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(7.5)
  doc.text('4. FIRMA Y EVIDENCIA FOTOGRÁFICA', M + 2, y + 4)
  y += 6

  const COL1_W = CW * 0.46
  const COL2_W = CW * 0.54
  const colH = 62

  // Columna izquierda: firma
  rect(M, y, COL1_W, colH, [249, 250, 251], [200, 200, 200])
  doc.setTextColor(...GRAY_TITLE)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(6.5)
  doc.text('FIRMA DEL DOCENTE', M + COL1_W / 2, y + 5, { align: 'center' })

  if (rec.firma) {
    try {
      doc.addImage(rec.firma, 'PNG', M + 3, y + 8, COL1_W - 6, colH - 18)
    } catch (_) { /* firma no disponible */ }
  }
  // Línea de firma al fondo
  doc.setDrawColor(150)
  doc.line(M + 6, y + colH - 8, M + COL1_W - 6, y + colH - 8)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(6)
  doc.setTextColor(150)
  doc.text('Firma del Docente Responsable', M + COL1_W / 2, y + colH - 4, { align: 'center' })

  // Columna derecha: evidencia
  const col2X = M + COL1_W + 2
  rect(col2X, y, COL2_W - 2, colH, [249, 250, 251], [200, 200, 200])
  doc.setTextColor(...GRAY_TITLE)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(6.5)
  doc.text('EVIDENCIA FOTOGRÁFICA', col2X + (COL2_W - 2) / 2, y + 5, { align: 'center' })

  if (rec.evidencia_url) {
    try {
      // Cargar imagen de evidencia via fetch → base64
      const response = await fetch(rec.evidencia_url)
      const blob = await response.blob()
      const b64 = await new Promise((resolve) => {
        const reader = new FileReader()
        reader.onloadend = () => resolve(reader.result)
        reader.readAsDataURL(blob)
      })
      const imgType = (rec.evidencia_tipo || 'image/jpeg').split('/')[1].toUpperCase()
      doc.addImage(b64, imgType, col2X + 2, y + 8, COL2_W - 6, colH - 12)
    } catch (_) {
      doc.setTextColor(180)
      doc.setFont('helvetica', 'italic')
      doc.setFontSize(7)
      doc.text('Imagen no disponible', col2X + (COL2_W - 2) / 2, y + colH / 2, { align: 'center' })
    }
  } else {
    doc.setTextColor(180)
    doc.setFont('helvetica', 'italic')
    doc.setFontSize(7)
    doc.text('Sin evidencia fotográfica', col2X + (COL2_W - 2) / 2, y + colH / 2, { align: 'center' })
  }

  y += colH + 4

  // ── 6. PIE DE PÁGINA ──────────────────────────────────────────────────────
  const footerY = 287
  rect(0, footerY - 1, W, 10, BLUE_DARK)
  doc.setTextColor(200, 220, 255)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(6.5)
  doc.text('I.E.F. El Arenal – CEMBA  |  Área de Gestión Institucional', W / 2, footerY + 5, { align: 'center' })
  doc.setTextColor(170, 200, 255)
  doc.text(`Generado el: ${new Date().toLocaleDateString('es-PE', { day: '2-digit', month: 'long', year: 'numeric' })}`, M, footerY + 5)
  doc.text(`Registro N° ${String(rec.id).padStart(6, '0')}`, W - M, footerY + 5, { align: 'right' })

  doc.save(`registro_limpieza_${formatDate(rec.fecha)}_${rec.area?.replace(/\s+/g, '_') || 'sin_area'}.pdf`)
}
</script>

<style scoped>
*, *::before, *::after { box-sizing: border-box; }

.rv-container {
  min-height: calc(100vh - 48px);
  background: linear-gradient(145deg, #eff6ff 0%, #f0f7ff 50%, #e8f0fe 100%);
  padding: 2rem 1.5rem;
  font-family: 'Inter', 'Segoe UI', sans-serif;
}

/* Encabezado ---------------------------------------------------------------- */
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

/* Botón PDF ----------------------------------------------------------------- */
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

/* Filtros ------------------------------------------------------------------- */
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
.filter-group input {
  background: #f9fafb;
  border: 1.5px solid #d1d5db;
  border-radius: 8px;
  padding: 0.45rem 0.7rem;
  font-size: 0.82rem;
  color: #111827;
  font-family: inherit;
  transition: border-color 0.2s;
}
.filter-group input:focus {
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

/* Estado -------------------------------------------------------------------- */
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

/* Tabla --------------------------------------------------------------------- */
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
.td-tarea   { max-width: 240px; color: #4b5563; font-size: 0.78rem; }
.td-empty   { color: #d1d5db; }

/* Botón PDF por fila -------------------------------------------------------- */
.th-action  { width: 60px; text-align: center; }
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

/* Miniaturas ---------------------------------------------------------------- */
.thumb-sig,
.thumb-img {
  width: 44px;
  height: 32px;
  object-fit: cover;
  border-radius: 5px;
  border: 1.5px solid #bfdbfe;
  cursor: zoom-in;
  transition: transform 0.15s, box-shadow 0.15s;
}
.thumb-sig { object-fit: contain; background: #f9fafb; }
.thumb-sig:hover, .thumb-img:hover {
  transform: scale(1.08);
  box-shadow: 0 3px 10px rgba(37,99,235,0.2);
}

/* Paginación ---------------------------------------------------------------- */
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

/* Total --------------------------------------------------------------------- */
.rv-total {
  text-align: right;
  font-size: 0.78rem;
  color: #9ca3af;
  margin-top: 0.6rem;
}
.rv-total strong { color: #374151; }

/* Spinner ------------------------------------------------------------------- */
.spinner {
  display: inline-block;
  width: 16px;
  height: 16px;
  border: 2px solid #bfdbfe;
  border-top-color: #2563eb;
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* Modal --------------------------------------------------------------------- */
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

/* Modal transition ---------------------------------------------------------- */
.modal-fade-enter-active, .modal-fade-leave-active { transition: opacity 0.2s; }
.modal-fade-enter-from, .modal-fade-leave-to { opacity: 0; }

/* Responsive ---------------------------------------------------------------- */
@media (max-width: 640px) {
  .rv-container { padding: 1rem; }
  .rv-header h1 { font-size: 1.1rem; }
  .rv-filters { padding: 0.85rem; gap: 0.6rem; }
  .filter-group { min-width: 100px; }
}
</style>
