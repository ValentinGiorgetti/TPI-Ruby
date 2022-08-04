# Correcciones

Las correcciones se irán versionando en este archivo.

## Reviosiones al 2022-08-04

El código a corregir debería de estar en la rama master. De esta forma, cuando
se me indica la finalización de las modificaciones, puedo verificar una copia
fiel de estar viendo algo que acordamos se entrega en esta rama. Por única vez,
mis correcciones se hicieron sobre la rama development. **A partir de esta
corrección se sugiere mergear en master los cambios que deba corregir**.

> Al momento de escribir estas lineas master tiene la versión previa a la
> extensión del TPI para aprobar el final de la materia.

### Correcciones críticas

Las siguientes correcciones deben solucionarse de forma obligatoria:

* Las migraciones no corren de forma satisfactoria. Probar el siguiente caso:
  - Crear una base de datos de cero
  - correr rake db:migrate # <--- Falla!
  - correr sino:

    ```
    rake db:drop
    rake db:create
    rake db:migarte # <-- Falla!
    # La falla es porque 20220712143533_remove_unused_user_fields.rb hace mencion
    # a campos que no se crear en users
    ```

### Sugerencias del profesor

Las siguientes correcciones son a modo de sugerencia. El alumno puede optar por
realizar las modificaciones que considere necesarias.

* El uso de swagger, me refería a su integración con [rswag](https://github.com/rswag/rswag es una gran simplificación)
* El database.yml usa variables de ambiente, pero solamente para algunos datos.
  Siempre conviene usar además variables para el resto de ellos. Incluso usar
  DATABASE_URL es mejor que usar el config/database.yml
* Los scripts wrappers de la carpeta bin/ no tenían permisos de ejecución y
  utilizan además como binarios ruby.exe. Esto no funcionará en un
  servidor productivo.
