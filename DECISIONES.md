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
