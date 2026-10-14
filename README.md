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

Spring-0 es el molde vivo, migrado desde Hito-0 y mantenido como submódulo. D-008/D-009 incorporan derivación explícita, cierre verificable y pendientes trazables; contrato 139/139 y distribución comprobada. El repositorio original Hito-0 permanece como archivo histórico. Ver `ESTADO.md` para el checkpoint de entrega.

## Validar la distribución

```sh
./scripts/verify-distribution.sh
```

Verifica el gate del molde, destinos seguros y repetición del preparador, y exporta una copia temporal en `seed`. Su gate ensaya inicialización, dos interrupciones/recuperaciones, sellado y unidades con spec y registro ligero. Usa la plantilla real y una base Git temporal para comprobar alcance. Limpia las copias al salir, sin red ni instalación de dependencias. La CI del padre ejecuta el mismo comando.

Para crear un proyecto local independiente:

```sh
./Spring-0/scripts/prepare-derivative.sh /ruta/nuevo-proyecto
```

El padre del destino debe existir. El preparador conserva el molde, registra procedencia y no crea commits ni configura remotos.
