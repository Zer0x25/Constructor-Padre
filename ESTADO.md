# Estado de la construcción — Constructor-Padre

## Última acción

- **2026-10-12 — Migración V5.6 a Spring-0 completada.** Creado `Spring-0` (repo fresco, sin historial), migrado el estado V5.6 de Hito-0 **1:1 byte a byte** (verificado con `diff -rq`, idéntico salvo `.git`). Commit raíz `bb387bf`, tag `v5.6.0`, pusheado a `main`. **Gate verde en el repo migrado: contrato 97/97, exit 0.** Identidad viva actualizada a Spring-0 en README/STATE/AGENTS; la historia (16 specs seed-*, ADR 0000–0006) se preservó literal como documento del molde.

## Situación

- **Hito-0** (repo original): congelado, intacto, V5.6 (`0e683dd`). Seguro histórico — no se toca.
- **Spring-0** (molde): https://github.com/Zer0x25/Spring-0 — vivo, funcional, tag `v5.6.0`. Local: `~/Escritorio/Proyects/Spring-0`.
- **Constructor-Padre** (este): https://github.com/Zer0x25/Constructor-Padre — gobierna la construcción de Spring-0.

## Pendiente

- [x] Crear Constructor-Padre y registrar la separación (D-001, D-002).
- [x] Crear Spring-0 y migrar V5.6 tal cual (opción B).
- [ ] **Resolver la declaración de padre en Spring-0:** el gate sigue ramificando por fases de derivado (`seed`/`initializing`/`project`) y Spring-0 vive en `phase=seed` — un estado que conceptualmente miente ("derivado a punto de nacer"). Decidir si Spring-0 se declara explícitamente padre (fase nueva tipo `mold`, o fuera del ciclo) — requiere tocar su gate, ahora sobre repo fresco y sin historial que defender.
- [ ] Limpieza de gobernanza: las `specs/seed-*` son construcción del molde; en la separación deberían dejar de ser "la unidad de trabajo" del molde (la construcción se decide en el padre).
- [ ] Verificar que los derivados futuros se generen desde Spring-0 (no desde Hito-0 congelado).

## Fricciones conocidas a resolver en la mejora (del análisis previo)

1. El gate del molde ramifica por fases de derivado (`seed`/`initializing`/`project`) y el molde no es un derivado — Spring-0 debería poder declararse padre sin romper el gate.
2. Las `specs/seed-*` son unidades de construcción del molde disfrazadas de specs de producto — en la separación, son decisiones de construcción (van al padre o a un espacio propio de Spring-0).
3. El bootstrap del molde necesita cláusulas de excepción para no gobernarse a sí mismo.
4. El encabezado AGENTS `## Estado inicial: semilla Hito 0` es ancla mecánica del gate (ver D-004); su cambio debe hacerse junto al piloto.

## Nota

Este archivo es el estado vivo de la construcción. No es un STATE de derivado ni sigue el formato del molde; es registro del padre.
