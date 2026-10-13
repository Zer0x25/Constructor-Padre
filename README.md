# Constructor-Padre

Repositorio padre de la **construcción del molde Spring-0** (antes Hito-0). No es un derivado del molde ni un proyecto de producto: es el lugar donde se decide **cómo se construye el molde**.

## Separación de responsabilidades

| Repo | Rol | Se gobierna por |
|---|---|---|
| **Constructor-Padre** (este) | Construye y mantiene el molde | Su propia gobernanza de construcción (este repo) |
| **Spring-0** | El molde agnóstico que provee gobernanza a derivados | Su propia gobernanza agéntica (AGENTS, ADR, gate) |
| **Derivados** | Proyectos de producto | La gobernanza que provee Spring-0 |

**Spring-0 es un submódulo de este repo:** vive físicamente en `Constructor-Padre/Spring-0/`, con su **propio historial git y su propio remoto** (repositorio independiente en GitHub, que además funciona como template para derivados). En GitHub son dos repos independientes; localmente el molde vive dentro del padre.

El padre **no sufre el régimen de gobernanza del molde** (tiers por riesgo, scope-lock, fase seed/initializing/project). Esa gobernanza es para los derivados y para la operación del molde; la construcción del molde se rige por las reglas de este repo.

## Clonar este repo (con el submódulo)

```sh
git clone --recurse-submodules https://github.com/Zer0x25/Constructor-Padre.git
# o, si ya estaba clonado:
git submodule update --init
```

## Por qué existe

Construir el molde dentro del propio molde creaba confusión: el gate del molde ramifica por fases de derivado (`seed`/`initializing`/`project`), y el molde no es ningún derivado. Separar la construcción en su propio repo elimina esa fricción de raíz: aquí no hay "specs de producto" ni gate de fases, hay decisiones de construcción.

## Cómo se trabaja aquí

- Cada decisión de construcción se registra en `DECISIONES.md` (qué se decidió, por qué, evidencia).
- El estado vivo de la construcción está en `ESTADO.md`.
- No hay gate de fases ni scope-lock: el control es la revisión humana de las decisiones de construcción.
- Commits con Conventional Commits, descriptivos.

## Estado

Molde Spring-0 congelado en su repositorio original (Hito-0) en V5.6, funcional. La migración hacia Spring-0 (repo fresco, sin historial) se hace desde aquí cuando el padre esté listo. Ver `ESTADO.md`.
