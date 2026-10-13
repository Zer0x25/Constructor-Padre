# Estado de la construcción — Constructor-Padre

## Última acción

- **2026-10-12 — Nacimiento del repo padre.** Creado `Constructor-Padre` en GitHub (Zer0x25), clonado a `~/Escritorio/Proyects/`. Se establece la separación: padre = gobernanza de la construcción; Spring-0 = el molde (a migrar); derivados = gobierno del molde.

## Situación del molde

- **Hito-0** (repo original): congelado, intacto, en **V5.6** (`0e683dd`, tag `v5.6.0`). Es nuestro repositorio de seguridad — no se toca.
- **Spring-0**: aún no creado. Repo fresco, sin historial, que recibirá el estado V5.6 del molde con la separación de gobernanza aplicada.

## Pendiente

- [ ] Decidir y registrar la separación de gobernanza: qué archivos/contenido van al padre vs a Spring-0.
- [ ] Crear Spring-0 (repo fresco, sin historial).
- [ ] Migrar el molde V5.6 hacia Spring-0 en tandas.
- [ ] Aplicar las mejoras de gobernanza ya identificadas (gate que distingue padre-de-derivado, limpieza de specs seed-*).

## Fricciones conocidas a resolver en la migración (del análisis previo)

1. El gate del molde ramifica por fases de derivado (`seed`/`initializing`/`project`) y el molde no es un derivado — Spring-0 debería poder declararse padre sin romper el gate.
2. Las `specs/seed-*` son unidades de construcción del molde disfrazadas de specs de producto — en la separación, son decisiones de construcción (van al padre o a un espacio propio de Spring-0).
3. El bootstrap del molde necesita cláusulas de excepción para no gobernarse a sí mismo.

## Nota

Este archivo es el estado vivo de la construcción. No es un STATE de derivado ni sigue el formato del molde; es registro del padre.
