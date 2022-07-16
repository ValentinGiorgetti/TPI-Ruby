# Polycon

Trabajo Práctico Integrador de la cursada 2021 de la materia Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática de la Universidad Nacional de La Plata.

Polycon es una herramienta para gestionar los turnos y profesionales de un policonsultorio.

## Uso de `polycon` (versión web)

1. Clonar el repositorio.
2. En la raíz del proyecto crear un archivo `.env`, y definir las variables de entorno "DB_USERNAME" y "DB_PASSWORD" (para la conexión a la base de datos), "GOOGLE_CLIENT_ID" y "GOOGLE_CLIENT_SECRET" (para la autenticación con Google).
3. Instalar las dependencias con el comando `bundle install`.
4. Ejecutar el comando `rails db:setup` para crear la base de datos junto con algunos datos de ejemplo.
5. Ejecutar el comando `rails s` para iniciar el servidor. Luego, en la consola se podrá visualizar en qué dirección y puerto está escuchando el servidor (por lo general http://127.0.0.1:3000).

En el archivo [`db/seeds.rb`](https://github.com/ValentinGiorgetti/TPI-Ruby/blob/development/db/seeds.rb) puede verse la seed inicial donde se crean algunos usuarios, profesionales y appointments (se puede volver a cargar con el comando `rails db:seed`). Allí puede encontrarse el email y contraseña de los usuarios de ejemplo, para iniciar como administrador el email es "admin@gmail.com" y la contraseña "123456").

## Desarrollo

### Instalación de dependencias

Este proyecto utiliza Bundler para manejar sus dependencias. 

Para que Bundler instale las dependencias del proyecto, ejecutar el siguiente comando:

```bash
$ bundle install
```

> Bundler puede instalarse mediante el siguiente comando (aunque ya debería estar disponible al instalar Ruby):
>
> ```bash
> $ gem install bundler
> ```

### Persistencia

La persistencia se realiza a partir del almacenamiento de los datos en una base de datos estructurada (SQL). Se utilizó MySQL como sistema de gestión de bases de datos relacional. Se utiliza `ActiveRecord` para guardar los usuarios, profesionales y turnos.

### Modelos

Los modelos implementados pueden observarse en `/app/models`

- En la clase `Professional` se especifica que el nombre del profesional sea obligatorio y único, además se especifica la relación que tienen los profesionales con los appointments. Se define el método `has_pending_appointments?` que verifica si el profesional tiene turnos pendientes.

- En la clase `Appointment` se especifica que todos los campos (excepto las notas) sean obligatorios, se verifica que el profesional no tenga un appointment en la misma fecha y hora. Se especifica la relación que tienen los appointments con los profesionales. Algunos de los métodos implementados son:

* `valid_hours`: método de clase que retorna una lista con los horarios de inicio de los turnos del policonsultorio (bloques de 1 hora, de 9:00 hs a 22:00 hs).

* `all_appointments_by_date`: método que retorna todos los appointments del día indicado, opcionalmente filtrando por un profesional (no se compara con la fecha y hora actual).

* `all_appointments_by_week`: método de clase que retorna todos los appointments de la semana indicada, opcionalmente filtrando por un profesional (no se compara con la fecha y hora actual). Se calcula cuál es la fecha del día lunes correspondiente a la semana de la fecha recibida por parámetro. Por ejemplo, si se ingresa la fecha "2021-10-14" (día jueves), el día inicial será "2021-10-11" (día lunes).

- En la clase `User` se especifica que todos los campos sean obligatorios. El email no debe repetirse y la contraseña debe tener al menos seis dígitos.

### Vistas y controladores

Las vistas se encuentran dentro del directorio `app/views` y los controladores dentro del directorio `app/controllers`.

En el módulo de usuarios se verifica que el usuario actualmente logueado no pueda borrarse a si mismo.

La clase `AppointmentsExporterController` es el controlador que se encarga de realizar la exportación de las grillas diarias o semanales de appointments.

### Autenticación

Para autenticación de usuarios se utilizó la gema `devise`, de esta forma los usuarios podrán iniciar sesión en el sistema, o cerrar su sesión cuando así lo deseen. 

### Autorización

Para autorización de usuarios se utilizó la gema `CanCan`, de esta forma los usuarios únicamente podrán acceder a los recursos que tengan habilitados.

En la clase `Ability`, dentro de `app/models` se definen los diferentes permisos que tiene cada rol:

- "Administrator": podrá hacer cualquier operación en el sistema.

- "Assistant": podrá gestionar por completo los turnos, pero no podrá modificar ni borrar profesionales.

- "Consultant": podrá ver información de profesionales y turnos, pero no podrá realizar cambios (modificar o borrar) ningún dato del sistema.

### Exportación de grillas diarias o semanales

Decidí realizar la exportación de las grillas en formato HTML, ya que este es un formato visualmente rico y es un lenguaje de marcado que permite fácilmente indicar la estructura de los documentos mediante etiquetas. Además, este lenguaje ofrece una gran adaptabilidad y estructuración lógica, y puede visualizarse desde cualquier navegador web. 

Decidí utilizar "ERB" (Embedded RuBy) para poder generar las plantillas HTML de las grillas de appointments diarios o semanales, ya que ERB una gema que se encuentra en la librería estándar del lenguaje que proporciona un sistema de plantillas potente el cuál brinda la capacidad de insertar código Ruby a cualquier documento de texto plano.

Descripción de los métodos implementados en la clase `AppointmentsExporterHelper`, la cuál se encarga de realizar la exportación de las grillas de appointments diarios o semanales:

* `create_hours_hash`: método de clase que retorna un hash donde las claves se corresponden con los horarios de inicio de los turnos del policonsultorio y el valor son listas vacías, las cuales posteriormente almacenarán los appointments que se correspondan con dicho horario de comienzo.

* `create_days_hash`: método de clase que retorna un hash donde las claves se corresponden con las fechas de la semana recibida por parámetro y el valor son el hash de horas mencionado en el punto anterior. Posteriormente, este hash almacenará los appointments de cada horario de cada día de la semana.

* `export_appointments_by_date`: método de clase que recibe el listado de appointments de un día en particular y los inserta en la plantilla correspondiente a la grilla de appointments diarios, generando el documento HTML resultante que luego podrá ser descargado por el usuario.

* `export_appointments_by_week`: método de clase que recibe el listado de appointments de una semana en particular y los inserta en la plantilla correspondiente a la grilla de appointments semanales, generando el documento HTML resultante que luego podrá ser descargado por el usuario.

* `get_day_of_week`: método de clase que se utiliza para obtener el día de semana correspondiente a la fecha recibida por parámetro.

* `file_path`: método de clase que retorna el path donde se almacenará la grilla exportada para que luego el usuario pueda descargarla.

Las grillas serán representadas como tablas, donde el eje vertical representa el horario de atención (muestra los horarios de inicio de los turnos del policonsultorio, es decir, bloques de 1 hora, de 9:00 hs a 22:00 hs) y el eje horizontal representa el o los días a mostrar (en el caso de una grilla semanal se mostrarán los días lunes a domingo de dicha semana).

Los templates HTML utilizados para realizar la exportación de las grillas diarias o semanales están definidos en los archivos `appointments-by-date-template.html.erb` y `appointments-by-week-template.html.erb` respectivamente (dentro de `app\views\appointments_exporter`). En el template lo que se hace es crear la tabla a partir del listado de appointments recibido.

Cada celda representará un bloque donde pueden haber turnos de uno/a o más profesionales, en los cuales se mostrará el nombre y apellido del paciente que tiene el turno y qué profesional lo atiende, o quedará en blanco en caso que el turno no esté tomado.

La grilla mostrará la información en bloques de duración fija (de 1 hora cada bloque), y cada turno se considera que durará el total de tiempo del bloque en el que esté.

Se asume que los turnos de un/a mismo/a profesional no se solaparán dentro de un mismo bloque (es decir, no habrán sobreturnos).

### Algunos comentarios

* Al momento de establecer la fecha y hora de un appointment para guardarlo, se verifica que sea una fecha y hora posterior a la actual.

* Un appointment se considera finalizado cuando su fecha y hora es mayor a la actual.

* Puede editarse y mostrarse la información de un appointment aunque este ya haya finalizado.

* El listado de appointments de un profesional muestra todos los appointments de dicho profesional (no se compara con la fecha y hora actual).

* No puede hacerse un reschedule de un appointment que ya fue realizado.

* La operación de cancelar un appointment solo está disponible para appointments que no se han realizado (se compara con la fecha y hora actual).

* Para eliminar un profesional este no debe tener ningún appointment por realizar (se compara con la fecha y hora actual).

* Los bloques de horarios que se mostrarán en las grillas serán de 1 hora, y abarcará desde las 9:00 hasta las 22:00, por ende, cuando se ingrese una fecha y hora, se verificará que el horario comience en alguno de dichos bloques (por ejemplo, un turno no podría crearse a las 9:30 hs, sino a las 9:00 hs, es decir, al comienzo del bloque; tampoco podría crearse a las 22:00, sino por ejemplo a las 21:00).