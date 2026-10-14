# Decisiones de construcción — Constructor-Padre

Registro de decisiones sobre **cómo se construye y organiza el molde Spring-0**. No son ADR del molde (esos viven en Spring-0); son decisiones del padre sobre la construcción.

## Formato

`## D-<n> — <título>` · Fecha · Estado (propuesta/aceptada) · Contexto · Decisión · Consecuencias.

---

## D-001 — Separar la construcción del molde en un repo padre

- **Fecha:** 2026-10-12
- **Estado:** aceptada
- **Contexto:** construir el molde dentro del propio molde generaba confusión de gobernanza — el gate ramifica por fases de derivado y el molde no es derivado; cada turno de construcción exigía recordar "soy constructor, no participante". Esa fricción es de raíz, no de redacción.
- **Decisión:** crear `Constructor-Padre` (este repo) para la gobernanza de la construcción, y migrar el molde a `Spring-0` (repo fresco, sin historial). Hito-0 queda congelado en V5.6 como seguro. El padre no sufre el régimen del molde; Spring-0 queda limpio y agnóstico de su constructor.
- **Consecuencias:** el historial de gobernanza (ADR 0000–0006, 16 seeds) se migra como contenido, no como historial git, a Spring-0. La construcción se registra aquí (DECISIONES/ESTADO), no en specs de producto del molde.

---

## D-002 — Spring-0 nace sin historial git

- **Fecha:** 2026-10-12
- **Estado:** aceptada
- **Contexto:** la decisión de arrancar sin historial busca eliminar de raíz la confusión gobernanza-del-molde vs gobernanza-de-la-construcción. Arrastrar 16 releases metería el régimen viejo en el repo nuevo.
- **Decisión:** Spring-0 recibe el estado V5.6 como contenido limpio (primer commit = estado migrado), sin el historial git de Hito-0. Hito-0 permanece como archivo histórico congelado si se necesita consultar la evolución.
- **Consecuencias:** se pierde el historial git fino de las seeds (ya no se ve commit a commit cómo evolucionó), pero se gana un repo cuyo régimen de gobernanza es explícitamente el del molde, sin el lastre del constructor. La trazabilidad de decisiones se preserva vía los ADR migrados.

---

## D-003 — Migrar V5.6 tal cual antes de mejorar la gobernanza (opción B)

- **Fecha:** 2026-10-12
- **Estado:** aceptada e implementada
- **Contexto:** la migración y la mejora de gobernanza son dos riesgos distintos; mezclarlos en un solo paso impediría saber qué rompió qué.
- **Decisión:** migrar el estado V5.6 1:1 (byte a byte, verificado con `diff -rq`) a Spring-0 con el gate verde, y **después** resolver la declaración de padre y la limpieza de seeds sobre el repo fresco. La identidad viva (README/STATE/AGENTS) se actualizó a Spring-0, pero la historia (specs seed-*, ADR) se preservó literal.
- **Consecuencias:** Spring-0 quedó funcional en V5.6 (contrato 97/97, tag `v5.6.0`) con la mudanza aislada de la mejora. La mejora de gobernanza queda como pendiente sobre un repo sin historial que defender.
- **Hallazgo de la migración:** el gate necesita `origin/main` para el scope-lock; al commitear el commit raíz (sin push previo) el gate hizo fail-safe (advirtió, no bloqueó) — el comportamiento de fail-safe ante base ausente funcionó como se diseñó.

---

## D-004 — El encabezado AGENTS «Estado inicial» es ancla mecánica del gate

- **Fecha:** 2026-10-12
- **Estado:** aceptada
- **Contexto:** el piloto (`bootstrap-pilot.sh` L77) tiene incrustado el literal `## Estado inicial: semilla Hito 0` en su `sed`; cambiar ese encabezado en AGENTS rompe el matcheo y pone el gate en rojo.
- **Decisión:** en la migración se actualizó la identidad viva de Spring-0 en el **cuerpo** de AGENTS (L3) y README/STATE, pero se **preservó literal** el encabezado `## Estado inicial: semilla Hito 0` por ser ancla mecánica. Su cambio queda como parte de la mejora de gobernanza futura, donde se actualizará el piloto en la misma pasada.
- **Consecuencias:** la migración no tocó el gate ni sus anclas; el gate siguió verde. La ancla "Hito 0" sobrevive en un archivo dentro de Spring-0 como deuda conocida y documentada, no como accidente.

---

## D-005 — Spring-0 vive como submódulo dentro del padre

- **Fecha:** 2026-10-13
- **Estado:** aceptada e implementada
- **Contexto:** Spring-0 se creó primero como repo hermano (local `~/Escritorio/Proyects/Spring-0`), pero el diseño correcto es que el molde viva **dentro** de Constructor-Padre, conservando su independencia.
- **Decisión:** en GitHub son **dos repos independientes** (Constructor-Padre = gobernanza del constructor; Spring-0 = molde, funciona como template para derivados). **Localmente Spring-0 es un submódulo** de Constructor-Padre: vive en `Constructor-Padre/Spring-0/`, con su propio historial git y su propio remoto. No se fusionó ni se eliminó nada.
- **Consecuencias:** `git clone --recurse-submodules` del padre trae el molde; trabajar en el molde se hace dentro de `Constructor-Padre/Spring-0/` con su propio git/remoto. El submódulo quedó registrado apuntando a `bb387bf` (tag `v5.6.0`) — historial intacto. Spring-0 conserva su repo en GitHub como template.

---

## D-006 — Higienización V1: molde limpio sin constructivos ni identidad de Hito-0

- **Fecha:** 2026-10-13
- **Estado:** aceptada e implementada (opción A), sin push aún
- **Contexto:** Spring-0 arrastraba constructivos de versión (`specs/seed-*.md`, `docs/seed-upgrades.md`) y la identidad del repo viejo ("Hito-0"), que son de la construcción, no del molde que se entrega a derivados.
- **Decisión (4 pasos, cada uno con gate verde 97/97):** (1) desacoplar el gate de `docs/seed-upgrades.md` (`5ce4b15`); (2) borrar 16 specs seed + seed-upgrades, limpiar refs, conservar `harness-metrics.md` (funcionalidad) e `docs/history/` (historia) (`81cddb6`); (3) identidad agnóstica — ancla AGENTS `## Estado inicial` + piloto en la misma pasada, quitar "(antes Hito-0)", conservar "Hito 0" solo como fase del flujo (`9611a60`, `d7ec60b`, `3574d02`); (4) `.gitignore` propio del padre (ruido del constructor, NO Spring-0) + submódulo apuntando al molde higienizado.
- **Consecuencias:** Spring-0 = molde limpio y agnóstico (V5.6-higienizada, 5 commits sobre el tag). El constructor mantiene su gobernanza en DECISIONES/ESTADO. La separación constructor↔molde quedó materializada en ambos repos. Pendiente: push de ambos a GitHub y la declaración de padre en el gate de Spring-0.

---

## D-007 — Fase `mold`: el molde se gobierna como padre, no como derivado

- **Fecha:** 2026-10-13
- **Estado:** aceptada e implementada (TDD), pusheada
- **Contexto:** tras la higienización V1, Spring-0 seguía en `phase=seed` — un estado de derivado ("a punto de nacer") que conceptualmente mentía: el molde no es un derivado. El gate ramificaba por fases de derivado y le exigía tratar el molde como semilla.
- **Decisión (TDD rojo→verde):** nueva fase `mold` en el gate. 6 tests nuevos en `verify-contract.sh` (rojo confirmado, luego verde): `mold` pasa sin verificador de producto, no corre scope-lock, corre el contrato pero no el piloto (ensayo del ciclo `seed`), no exige claves de producto, y un governance file faltante sí bloquea. Implementada en las 3 piezas del gate (`verify-structure.sh` ramifica a archivos del molde; `verify.sh` corre contrato sin piloto/scope-lock/verify-project; `verify-scope.sh` → exit 0 por defensa en profundidad). `project-profile.conf` → `phase=mold`; STATE/AGENTS/README documentan la fase. ADR 0006 intacto (su transición `seed→initializing→project` es del derivado, no del molde).
- **Consecuencias:** el molde se declara padre y el gate lo trata como tal — le exige los archivos del molde, no los de producto. Contrato 97 → **103 passed, 0 failed**. Commit `bb4c02f`. La distinción conceptual derivado↔molde quedó materializada en el gate, no solo en documentos.

---

## D-008 — Derivación explícita y alcance verificable con documentos reales

- **Fecha:** 2026-10-14.
- **Estado:** aceptada por el usuario («hazlo»); implementada y verificada localmente, sin commit/push.
- **Autoridad y alcance:** entrega acotada de propuestas 1–4. Cambios locales sin commit/push. Clasificación Tier 1 por controles deterministas; revisión mediante pruebas adversarias, sin atribuir independencia a la revisión propia.
- **Decisión:** preparar derivados mediante exportación a un directorio nuevo, nunca convertir el molde en sitio. Conservar procedencia (commit de la copia fuente y huella del contenido), establecer `seed` y limpiar STATE. Repetir sobre un derivado ya preparado conserva todos sus archivos; destinos ajenos o el propio molde se rechazan. La entrevista sigue siendo explícita.
- **Controles:** interpretar etiquetas Markdown y separar editables/protegidos (la protección prevalece); seleccionar el bloque LIG exacto. Conservar las políticas de fases, autoridad y omisión ante falta de base. No alterar ADR históricos.
- **Rutas autorizadas:** DECISIONES.md, ESTADO.md, README.md; scripts/verify-distribution.sh, scripts/tests/verify-derivative.sh; .github/workflows/verify.yml del padre. En Spring-0: scripts/prepare-derivative.sh, scripts/verify-scope.sh, scripts/verify.sh, scripts/verify-structure.sh, scripts/tests/verify-contract.sh, scripts/tests/bootstrap-pilot.sh, .agents/bootstrap.md, README.md, AGENTS.md y STATE.md.
- **Criterios:** CA-1 exportación `mold → seed` con origen, sin sobrescritura; CA-2 plantilla real acepta editables y rechaza protegidos/fuera de alcance; CA-3 dos LIG históricos no mezclan permisos; CA-4 verificación del padre ejecuta gate y ciclo completo en copia temporal, con limpieza.
- **Verificación prevista:** rojo/verde de regresiones; gate del molde; prueba de distribución que incluya rechazo de destinos, repetición, recuperación y sellado. Experimentos exclusivamente temporales, sin red ni dependencias nuevas.

- **CA-1 — evidencia:** `bash scripts/tests/verify-derivative.sh` exit 0: rechaza fuente/destino anidado/symlink/carpeta ajena, genera seed con procedencia, conserva checkpoint en seed/initializing/project. Una copia Git local confirmó exclusión de `.env` y notas no versionadas, inclusión de cambios versionados y limpieza ante fuente incompleta.
- **CA-2/CA-3 — evidencia:** rojo inicial `107 passed, 3 failed` (plantilla real, protegido sin negritas, LIG activo); regresión adicional de listas directas `110 passed, 1 failed`. Verde final `111 passed, 0 failed`. Las pruebas rechazan también permisos históricos y del bloque siguiente; protegidos prevalecen sobre globs editables.
- **CA-4 — evidencia:** `./scripts/verify-distribution.sh` exit 0: gate del molde 111/111, exportación y gate seed 111/111, piloto con dos interrupciones/recuperaciones, sellado y unidades Tier 2/Tier 3 con alcance comprobado contra Git temporal. Los commits de fixtures se eliminan con sus directorios; ninguno se creó en los repositorios del usuario.
- **Revisión/cierre:** diff revisado y `git diff --check` en ambos repos exit 0; pruebas adversarias de controles deterministas realizadas por el mismo agente. CI del padre configurada, no ejecutada remotamente. Sin entrevista real ni certificación de stacks alternativos. No cambió el puntero del submódulo. Próximas mejoras opcionales: limpieza documental general y versionado/publicación (propuestas 5–6), fuera de esta entrega.

---

## D-009 — Cierre, base por unidad y pendientes trazables

- **Fecha:** 2026-10-14.
- **Estado:** aceptada por el usuario («hazlo»), implementada y verificada localmente, sin commit/push.
- **Autoridad:** puntos 1–4 de la auditoría de gobernanza. Tier 1 por controles deterministas; revisión con regresiones adversarias por el mismo agente, sin atribuir independencia. Cambios locales, sin commits/push en repositorios del usuario.
- **Decisión:** normalizar estado Markdown y comprobar cierre antes de resolver base/diff. Evidencia por CA con verificación, resultado `pass`, artefacto relativo y SHA-256 que coincida con su contenido; el gate valida declaración/huella, no certifica quién ejecutó el comando. Base de alcance = SHA de inicio de la unidad, ancestro de HEAD, congelada en spec o bloque LIG; fallback a origin/main para derivados anteriores, reportado como incompleto. La revisión acumulada de rama conserva su diff aparte y no se confunde con permisos de una unidad.
- **Reporte:** controles `verificado`, `omitido` o `no_aplica`; omisiones mantienen exit 0 con advertencia y resumen de gobernanza incompleta. Violaciones confirmadas bloquean project y advierten en initializing. Un gate técnico verde con controles omitidos no acredita cierre.
- **Pendientes:** marcadores `HITO0_PENDING:PEND-n`; tabla única en STATE con ID, impacto (`critico`/`diferible`), responsable, condición de resolución y estado (`abierto`/`resuelto`). Cada referencia debe corresponder a un registro. Pendientes críticos abiertos impiden project; diferibles registrados advierten. initializing conserva pendientes y recuperación. Marcadores antiguos sin ID requieren migración explícita, no inventar decisiones.
- **Rutas autorizadas:** DECISIONES.md, ESTADO.md; Spring-0/scripts/verify-scope.sh, verify-structure.sh, verify.sh, tests/verify-contract.sh, tests/bootstrap-pilot.sh; Spring-0/specs/templates/feature.template.md; Spring-0/.agents/bootstrap.md, prd.template.md, master-prompt.template.md; Spring-0/AGENTS.md, README.md y STATE.md.
- **Criterios:** CA-1 rechazar cierre sin evidencia/comando/resultado/artefacto vigente, incluso con Markdown, diff vacío o base ausente; CA-2 permitir unidades consecutivas sin push y rechazar cambios ajenos, base inválida y manipulación solo staged; CA-3 reportar omisiones sin ocultarlas ni afirmar cierre satisfactorio; CA-4 vincular pendientes exactos y distinguir críticos/diferibles sin depender de palabras sueltas.
- **Verificación:** regresiones rojo/verde, contrato y distribución completos; fixtures temporales con limpieza, sin red ni nuevas dependencias. ADR históricos intactos. Continuidad de D-008 preservada.

- **CA-1 — evidencia:** regresiones de cierre con Markdown, mención CA sin evidencia, worktree limpio, base ausente, campos ausentes, resultado fallido y artefacto modificado; rechazo confirmado. Declaración explícita con huella vigente pasa. El piloto comprueba cierre tanto de spec como de LIG sin crear una spec adicional.
- **CA-2 — evidencia:** dos unidades consecutivas pasan sin actualizar `origin/main`; cambios ajenos, staged sin presencia en worktree, SHA incompleto y base no ancestral bloquean. El piloto conserva origin/main entre Tier 2 y Tier 3.
- **CA-3 — evidencia:** unidad ausente y base ausente emiten reporte incompleto; sin base se verifica igualmente el cierre. El gate conserva exit 0 para omisiones y cambia su mensaje a gobernanza incompleta. initializing mantiene advertencias/recuperación sin ocultar fallos de scripts con `|| true`.
- **CA-4 — evidencia:** pendientes sin ID/registro exacto, IDs diferentes, registros duplicados, responsable/condición ausentes y marcadores de pendientes resueltos bloquean project; críticos abiertos bloquean project pero conservan initializing; diferibles abiertos registrados pasan con aviso.
- **Verificación/cierre:** rojo inicial de las regresiones observado antes de implementar; corregido además un fixture que dejaba una spec de la unidad anterior sin commitear. Verde final `bash Spring-0/scripts/tests/verify-contract.sh`: 139 passed, 0 failed. `./scripts/verify-distribution.sh` exit 0, contrato 139/139 en molde y semilla, piloto completo y pruebas de exportación/limpieza. Sintaxis Bash y `git diff --check` en ambos repos exit 0. ADR históricos sin cambios. Revisión propia con pruebas adversarias, no independiente.
- **Adopción/límites:** derivados existentes requieren registrar base por unidad, migrar evidencia antigua al formato explícito y asignar IDs/impacto a pendientes bajo su autoridad vigente. No se modificaron derivados reales. El control de SHA valida el contenido del artefacto declarado, no autentica ejecución ni certifica cobertura del producto. CI remota no ejecutada; sin commits/push ni cambio de puntero del submódulo. D-009 cerrada localmente; propuestas 5–8 quedan fuera de esta entrega.


## Entrega de D-008/D-009 — autorización de publicación

- **Fecha:** 2026-10-14.
- **Autoridad:** petición explícita «commit and push, que sigue?»; publicar el alcance acumulado verificado, sin tags ni release solicitados.
- **Secuencia:** commit y push de Spring-0; registrar su SHA y actualizar el gitlink; commit y push del constructor. Ambos usan Conventional Commits y revisión del staged. No se reabren criterios técnicos por la publicación.
- **Verificación:** gate/hook del molde, distribución del padre, comparación de HEAD con main remota y comprobación de CI tras cada push. El checkpoint pertenece al commit de entrega; la evidencia remota se informa al terminar.

- **Corrección de entrega:** el hook real heredó `core.hooksPath` a los commits de fixtures y bloqueó la preparación de estados deliberadamente inválidos. Se aíslan exclusivamente los commits de repos temporales con su propia opción Git; el commit del molde mantiene el hook real activo. La corrección no cambia criterios ni controles del producto.

- **Molde publicado:** `91f2eeb0a37ca0b6b6d1607aacbd339369c5452e`, main local/remota idénticas. Hook real completó 139 passed, 0 failed tras aislar los fixtures. El commit de entrega del padre guarda el gitlink a ese SHA y los controles de distribución.

- **CI del molde:** GitHub Actions `38534303911` concluyó `success` para `91f2eeb`; confirmado tras el push. La distribución/CI del padre comprueba la composición del checkout y el ciclo completo.
