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
