# Challenge Técnico — Análisis de Incidente Productivo (Senior)

## Objetivo

Evaluar cómo investigás un incidente a partir de evidencia real (logs, datos y código), cómo decidís qué hacer con él y cómo lo comunicás. Nos importa el razonamiento, no solo llegar al número correcto.

**Se evalúa:**
- Lectura e interpretación de logs y de código ajeno.
- Manejo de SQL para detectar y cuantificar inconsistencias.
- Criterio para llegar a la causa raíz sin quedarse en el síntoma, y para no asumir que todo tiene la misma causa.
- Capacidad de proponer fixes bien justificados, distinguiendo el parche inmediato de la corrección de fondo.
- Criterio para remediar datos productivos de forma segura.
- Mirada preventiva: cómo evitar que vuelva a pasar y cómo detectarlo antes.
- Claridad para comunicar, tanto a un equipo técnico como a uno no técnico.

## Contenido de este kit

- `enunciado.md`: el incidente reportado y la consigna.
- `dump.sql`: dump de PostgreSQL con esquema y datos (productos, inventario, pedidos, movimientos de stock).
- `app.log`: extracto de logs de la aplicación del período relevante (timestamps en UTC).
- `docker-compose.yml`: levanta PostgreSQL con el dump ya cargado.
- `code/orders.controller.ts`: endpoints de creación y cancelación de pedidos.
- `code/orders.service.ts`: alta de pedidos y cancelación iniciada por el usuario.
- `code/stock.service.ts`: servicio que aplica la reserva de stock.
- `code/order-timeout.worker.ts`: worker que cancela pedidos vencidos y el servicio que registra los movimientos de stock.

## Cómo levantar el entorno

### Opción A: Docker Compose (recomendada)

```bash
docker compose up -d
```

La base queda en `localhost:5432`: base `challenge_db`, usuario `postgres`, password `postgres`. Podés conectarte con DBeaver, pgAdmin, DataGrip, etc., o por consola:

```bash
docker exec -it challenge-pg psql -U postgres -d challenge_db
```

Si el puerto 5432 ya está ocupado en tu máquina, elegí otro con la variable `PG_PORT` (en PowerShell: `$env:PG_PORT=5433; docker compose up -d`):

```bash
PG_PORT=5433 docker compose up -d
```

Para volver a la base original (por ejemplo, después de probar tu script de remediación):

```bash
docker compose down -v
docker compose up -d
```

### Opción B: PostgreSQL local

```bash
createdb challenge_db
psql -d challenge_db -f dump.sql
```

`app.log` es texto plano. Se puede revisar con cualquier editor o con `grep`, `less`, etc. Los archivos en `code/` son fragmentos de TypeScript/NestJS para leer y analizar; no forman parte de un proyecto ejecutable.

## Qué se pide

1. Leer `enunciado.md`.
2. Investigar usando el dump, los logs y el código.
3. Entregar lo que se detalla abajo.

## Entregables

1. **Documento de diagnóstico** con:
   - Productos afectados y, para cada uno, si comparten causa o no.
   - Para cada producto afectado: cuál de los dos valores es el correcto (panel o kardex) y cuál debería ser el stock real.
   - **Causa raíz** de cada problema, con la evidencia que la sostiene (queries, líneas de log, líneas de código).
   - Hallazgos que parecían relevantes pero no lo eran, y por qué los descartaste.
2. **Fixes de código** para cada bug: el cambio inmediato y, si corresponde, la corrección de fondo que harías. Puede ser un diff o la función corregida; no hace falta que compile.
3. **Script de remediación de datos** (SQL) para dejar la base consistente. Debe poder ejecutarse de forma segura sobre producción. Explicá las decisiones que tomaste.
4. **Queries SQL** utilizadas en el análisis.
5. **Alcance, prevención y detección:** cómo determinarías qué otros registros están afectados en producción (fuera de este extracto), qué cambiarías para que no vuelva a pasar y cómo lo detectarías antes de que lo reporte un usuario.
6. **Comunicación:**
   - Un mensaje breve para el equipo de Atención al Cliente, sin jerga técnica: qué pasó, qué impacto tuvo y qué se está haciendo.
   - Un resumen técnico tipo postmortem (media página alcanza).

## Formato de entrega

**Plazo:** hasta 7 días corridos desde que recibís el link a este repositorio. Elegís cuándo dedicarle las 3-4 horas. Tomamos como fecha de entrega el último commit.

### Cómo entregar (repositorio de GitHub)

1. Arriba a la derecha de este repositorio, hacé clic en **Use this template → Create a new repository**.
2. Creá el repo en tu cuenta con el nombre `challenge-apellido-nombre` y visibilidad **Private**.
   > No hagas *fork*: un fork de un repo público es siempre público y tu solución quedaría visible para otros candidatos.
3. Resolvé el challenge en tu repo. Hacé commits a medida que avanzás: el historial también nos sirve para entender cómo trabajaste.
4. Invitá como colaborador al usuario **`mortega-urb`** (*Settings → Collaborators → Add people*).

Después de la fecha de entrega, no hagas más cambios en el repo.

### Estructura esperada

No modifiques los archivos originales del kit. Poné todo lo tuyo dentro de una carpeta `entrega/` en la raíz del repo:

```
entrega/
├── DIAGNOSTICO.md        # documento principal (también vale .pdf o .docx)
├── queries.sql           # queries de análisis
├── remediacion.sql       # script de corrección de datos
└── code/                 # archivos con el fix aplicado, o un fix.diff
```

Sobre cada parte:
- **DIAGNOSTICO:** empezá con un **resumen de no más de 10 líneas** (qué pasó, a qué productos afecta, causas). Después, el detalle en el orden que prefieras, cubriendo los puntos de "Entregables". Incluí los mensajes de comunicación (punto 6) al final.
- **queries.sql:** cada query con un comentario que diga qué pregunta responde y qué resultado obtuviste.
- **remediacion.sql:** lo vamos a ejecutar sobre una base recién levantada con `docker compose`, así que tiene que correr de principio a fin sin errores.
- **code/:** no hace falta que compile. Si el fix de fondo es muy grande, alcanza con describirlo en el diagnóstico y mostrar el fragmento clave.

Al final del diagnóstico agregá dos líneas: **tiempo aproximado dedicado** y **herramientas utilizadas** (incluida IA, si usaste). No resta puntos; nos ayuda a calibrar el challenge.

## Uso de herramientas e IA

Podés usar cualquier herramienta, incluidas herramientas de IA. En la defensa técnica vamos a profundizar sobre tu análisis, tus decisiones y escenarios alternativos. Asegurate de entender y poder justificar todo lo que entregues.
