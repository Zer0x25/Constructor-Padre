# Estado de la construcción — Constructor-Padre

## Última acción

- **2026-10-14 — Entrega D-008/D-009.** Spring-0 publicado en `main` (`91f2eeb0a37ca0b6b6d1607aacbd339369c5452e`); hook 139/139, hash remoto comprobado y CI del molde verde (`38534303911`). El commit de entrega del constructor actualiza el gitlink y contiene este checkpoint. Distribución completa y CI se verifican con la versión publicada; la identidad del commit del padre se consulta en Git. Siguiente paso propuesto: piloto real de un derivado antes de ampliar gobernanza.

- **2026-10-14 — D-009, cierre y continuidad verificables.** Cierre independiente del diff/base con evidencia por CA y huella de artefacto; SHA de inicio por unidad con fallback legacy explícito; reporte de controles omitidos; pendientes con ID/impacto/responsable/resolución. Validación final: `./scripts/verify-distribution.sh` exit 0, contrato 139/139 en molde y semilla; piloto de dos unidades sin actualizar origin/main, recuperación y cierre de spec/LIG verde. D-009 cerrada localmente; CI remota no ejecutada. Cambios locales acumulados con D-008, sin commit/push ni cambio de puntero del submódulo.

- **2026-10-14 — D-008, entrega acotada de derivación y alcance.** Implementados preparador hacia directorio nuevo (seed y procedencia), parser de permisos de la plantilla real y lectura del LIG activo. Nuevo `./scripts/verify-distribution.sh` y CI del padre. Validación final verde: 111/111 y piloto con dos recuperaciones, alcance con base Git y compatibilidad de listas directas. Pruebas de exportación/limpieza verdes; CI configurada, sin ejecución remota. D-008 cerrada localmente. Cambios locales en padre y submódulo, sin commit/push; el puntero Git del submódulo no se ha actualizado.

- **2026-10-13 — Higienización V1 de ambos repos completada (D-006).** Spring-0 pasó a molde limpio en 5 commits (`5ce4b15`..`3574d02`): gate desacoplado de constructivos, borradas 16 specs seed + seed-upgrades, identidad agnóstica (sin "Hito-0"), enseñanza de evolución reapuntada al Constructor-Padre. Gate verde en cada paso: 97/97. Constructor-Padre ganó `.gitignore` propio y su submódulo ahora apunta al molde higienizado (`3574d02`). Pendiente: push de ambos a GitHub.
- **2026-10-12 — Migración V5.6 a Spring-0 completada.** Creado `Spring-0` (repo fresco, sin historial), migrado el estado V5.6 de Hito-0 **1:1 byte a byte** (verificado con `diff -rq`, idéntico salvo `.git`). Commit raíz `bb387bf`, tag `v5.6.0`, pusheado a `main`. **Gate verde en el repo migrado: contrato 97/97, exit 0.** Identidad viva actualizada a Spring-0 en README/STATE/AGENTS; la historia (16 specs seed-*, ADR 0000–0006) se preservó literal como documento del molde.

## Situación

- **Hito-0** (repo original): congelado, intacto, V5.6 (`0e683dd`). Seguro histórico — no se toca.
- **Spring-0** (molde): repo independiente en GitHub (funciona como template), **submódulo** de este repo en `Constructor-Padre/Spring-0/`. Vivo, funcional, tag `v5.6.0` (`bb387bf`), con su propio historial git.
- **Constructor-Padre** (este): gobierna la construcción de Spring-0. Spring-0 vive dentro como submódulo.

## Pendiente

- [x] Crear Constructor-Padre y registrar la separación (D-001, D-002).
- [x] Crear Spring-0 y migrar V5.6 tal cual (opción B).
- [x] **Higienización V1 completada** (D-006): Spring-0 = molde limpio sin constructivos de versión ni identidad de Hito-0; Constructor-Padre = repo constructor con `.gitignore` propio y submódulo apuntando al molde higienizado.
- [x] **Declaración de padre en el gate** (D-007, TDD): Spring-0 corre en `phase=mold`; el gate lo trata como padre (archivos del molde, sin scope-lock ni verificador de producto). Contrato 103/103. Pusheado (`bb4c02f`, puntero del submódulo `1114d6b`).
- [x] Verificar la generación local desde Spring-0 en `seed` mediante preparador y prueba de distribución (D-008). Una copia directa de GitHub template conserva `mold` y requiere exportación explícita.

## Fricciones conocidas a resolver en la mejora (del análisis previo)

1. El gate del molde ramifica por fases de derivado (`seed`/`initializing`/`project`) y el molde no es un derivado — Spring-0 debería poder declararse padre sin romper el gate.
2. Las `specs/seed-*` son unidades de construcción del molde disfrazadas de specs de producto — en la separación, son decisiones de construcción (van al padre o a un espacio propio de Spring-0).
3. El bootstrap del molde necesita cláusulas de excepción para no gobernarse a sí mismo.
4. El encabezado AGENTS `## Estado inicial: semilla Hito 0` es ancla mecánica del gate (ver D-004); su cambio debe hacerse junto al piloto.

## Nota

Este archivo es el estado vivo de la construcción. No es un STATE de derivado ni sigue el formato del molde; es registro del padre.
