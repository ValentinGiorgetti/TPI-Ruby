# Polycon

Trabajo Práctico Integrador de la cursada 2021 de la materia Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática de la Universidad Nacional de La Plata.

Polycon es una herramienta para gestionar los turnos y profesionales de un policonsultorio.

## Uso de `polycon`

Para ejecutar la aplicación se utiliza el script `bin/polycon`, el cual puede correrse de las siguientes maneras:

```bash
$ ruby bin/polycon [args]
```

O bien:

```bash
$ bundle exec bin/polycon [args]
```

O simplemente:

```bash
$ bin/polycon [args]
```

Para la ejecución de la herramienta, es necesario tener una versión reciente de Ruby (2.6 o posterior) y tener instaladas sus dependencias (las cuales se manejan con Bundler).

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

### Estructura del programa

* `bin/`: directorio donde reside el archivo ejecutable `polycon`, que se utiliza como punto de entrada para el uso de la aplicación.

* `lib/`: directorio que contiene todas las clases del modelo y da soporte para la ejecución del programa `bin/polycon`.

* `lib/polycon.rb` es la declaración del namespace `Polycon`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).

* `lib/polycon/` es el directorio que representa el namespace `Polycon`

* `lib/polycon/commands.rb` y `lib/polycon/commands/*.rb` son las definiciones de comandos de `dry-cli` que se utilizarán.

* `lib/polycon/version.rb` define la versión de la herramienta, utilizando [SemVer](https://semver.org/lang/es/).


* `lib/polycon/exceptions.rb` es la declaración del namespace `Polycon::Exceptions`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).

* `lib/polycon/exceptions/` es el directorio que representa el namespace `Polycon::Exceptions`.

* `lib/polycon/exceptions/polyconexception.rb` es el archivo donde se definen las excepciones de la aplicación.


* `lib/polycon/helper.rb` es la declaración del namespace `Polycon::Helper`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).

* `lib/polycon/helper/` es el directorio que representa el namespace `Polycon::Helper`.

* `lib/polycon/helper/polyconhelper.rb` es el archivo donde se define la clase `PolyconHelper` que implementa los métodos helpers que serán utilizados en la aplicación.


* `lib/polycon/persistance.rb` es la declaración del namespace `Polycon::Persistance`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).

* `lib/polycon/persistance/` es el directorio que representa el namespace `Polycon::Persistance`.

* `lib/polycon/persistance/polyconfile.rb` es el archivo donde se define la clase `PolyconFile` que implementa los métodos que serán utilizados para brindar persistencia en el FileSystem a los objetos del modelo de la aplicación.


* `lib/polycon/models.rb` es la declaración del namespace `Polycon::Models`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).

* `lib/polycon/models/` es el directorio que representa el namespace `Polycon::Models`.

* `lib/polycon/models/professional.rb` es el archivo donde se define la clase `Professional` del modelo de objetos de la aplicación, que representará a los profesionales.

* `lib/polycon/models/appointment.rb` es el archivo donde se define la clase `Appointment` del modelo de objetos de la aplicación, que representará a los appointments.


[+] `lib/polycon/exporter.rb` es la declaración del namespace `Polycon::Exporter`, y las directivas de carga de clases o módulos que estén contenidos directamente por éste (`autoload`).

[+] `lib/polycon/exporter/` es el directorio que representa el namespace `Polycon::Exporter`. También contiene a los templates utilizados para realizar la exportación de las grillas diarias o semanales.

[+] `lib/polycon/exporter/html-exporter.erb` es el archivo donde se define la clase `HTMLExporter` que se utiliza para realizar la exportación de las grillas diarias o semanales.

[+] `lib/polycon/exporter/appointments-by-date-template.html.erb` es el archivo donde se define el template HTML que se utiliza para realizar la exportación de las grillas diarias.

[+] `lib/polycon/exporter/appointments-by-week-template.html.erb` es el archivo donde se define el template HTML que se utiliza para realizar la exportación de las grillas semanales.

## Decisiones de diseño

### Excepciones

Las excepciones manejadas en esta aplicación son las siguientes:

* `EmptyNameError`: indica que el usuario ingresó un nombre vacío.
* `InvalidNameError`: indica que el usuario ingresó nombre inválido (contiene caracteres que no son letras).
* `EmptySurnameError`: indica que el usuario ingresó un apellido vacío.
* `InvalidSurnameError`: indica que el usuario ingresó apellido inválido (contiene caracteres que no son letras).
* `EmptyPhoneError`: indica que el usuario ingresó un número de teléfono vacío.
* `InvalidPhoneError`: indica que el usuario ingresó número de teléfono inválido (contiene caracteres que no son dígitos).
* `InvalidDateTimeError`: indica que el usuario ingresó una fecha y hora inválida.
* `OldDateTimeError`: indica que el usuario ingresó una fecha y hora que ya pasó.
* `InvalidDateError`: indica que el usuario ingresó una fecha inválida o un horario que no se corresponde con el horario de atención del policonsultario (bloques de 1 hora, de 9:00 hs a 21:00 hs).
* `ProfessionalAlreadyExistsError`: indica que un profesional ya existe.
* `ProfessionalDoesntExistError`: indica que un profesional no existe.
* `ProfessionalCantBeDeletedError`: indica que un profesional no puede borrarse ya que tiene consultas pendientes.
* `AppointmentAlreadyExistsError`: indica que ya existe una consulta en esa fecha para ese profesional.
* `AppointmentDoesntExistError`: indica que no se encontró una consulta en esa fecha para ese profesional.
* `AppointmentCantBeCanceled`: indica que el appointment no puede ser cancelado ya que el mismo ya fue realizado.
* `AppointmentCantBeRescheduled`: indica que no se puede cambiar la fecha y hora del appointment ya que el mismo ya fue realizado.

Estas excepciones están definidas en el archivo `lib/polycon/exceptions/polyconexception.rb`. En caso de que alguna de estas excepciones ocurra, la misma será capturada por el comando, el cuál mostrará el mensaje correspondiente de la excepción.

### Helpers

En el archivo `lib/polycon/helper/polyconhelper.rb`, dentro de la clase `PolyconHelper`, se definen métodos "helpers" utilizados para realizar diferentes validaciones: validar nombres y apellidos (que no sean vacíos y que no contengan caracteres que no sean letras), números de teléfono (que no sean vacíos y que no contengan caracteres que no sean números) y fechas (que el formato sea válido y que no se ingrese una fecha "pasada" para crear un appointment).

[+] Se agregó el método de clase `week_start` que retorna la fecha correspondiente al lunes de la semana de la fecha recibida por parámetro.

### Persistencia

En el archivo `lib/polycon/persistance/polyconfile.rb`, dentro de la clase `PolyconFile`, se definen métodos utilizados para llevar a cabo la persistencia de los objetos del modelo dentro del File System (dentro de esta clase se lleva a cabo el manejo de archivos y directorios):

* En la definición de la clase se lleva a cabo la creación del directorio `.polycon` (en caso que no exista) dentro del home del usuario que ejecuta el programa.

* `save_professional`: guarda un profesional, creando un directorio con su nombre, en la carpeta ".polycon" del directorio personal del usuario que ejecute la aplicación. 
* `delete_professional`: elimina un profesional, borrando el directorio con su nombre.
* `exist_professional?`: verifica si existe un profesional con el nombre recibido como parámetro, verificando si existe un directorio con dicho nombre.
* `rename_professional`: renombra al profesional, modificando el nombre del directorio. 
* `load_professionals`: retorna un arreglo que contiene a todos los profesionales guardados.
* `save_appointment`: guarda una consulta, creando un archivo con el nombre dado por la fecha y hora de consulta, el cual almacena el apellido, nombre, número de teléfono y notas (en caso de que existan) de la persona que solicitó el turno, dentro del directorio del profesional que atenderá dicha consulta.
* `reschedule_appointment`: cambia la fecha y hora del appointment, modificando el nombre del archivo que lo representa.
* `load_appointment`: retorna el appointment del profesional para la fecha y hora indicados, buscando un archivo que coincida con la fecha y hora dentro del appointment dentro del directorio del profesional.
* `professional_appointments_list`: retorna los appointments del profesional recibido como parámetro, recorriendo el directorio con su nombre y guardando cada appointment.
* `delete_appointment`: elimina el appointment, borrando el archivo que lo representa dentro del directorio del profesional.
* `appointment_file_name`: retorna la ruta completa del archivo que representa al appointment de un profesional.
* `professional_directory`: retorna la ruta completa del directorio que representa a un profesional.

### Modelos

Los modelos que implementé para la aplicación son la clase `Professional` y la clase `Appointment`.

En la clase `Professional` se definen los métodos necesarios para manipular estos objetos, tales como:

* `create`: método de clase que retorna una instancia que representa al profesional.

* `save`: método de instancia que guarda el profesional, previamente verificando que no exista otro profesional con el mismo nombre.

* `rename`: método de instancia que modifica el nombre del profesional, verificando que éste sea válido y no exista otro profesional con el mismo nombre.

* `has_appointments?`: método de instancia que indica si el profesional tiene algún appointment sin realizar.

* `has_appointment?`: método de instancia que indica si el profesional tiene un appointment en la fecha y hora recibida como parámetro.

* `delete`: método de instancia que borra al profesional, en caso de que este no tenga ningún appointment por realizar.

* `cancel_all`: método de instancia que cancela todos los appointments del profesional que no hayan sido realizados.

* `appointments_list`: método de instancia que retorna un arreglo con todos los appointments del profesional, opcionalmente filtrados por una fecha recibida como parámetro.

* `exist?`: método de clase que indica si existe un profesional con el nombre recibido por parámetro.

* `list`: método de clase que retorna un listado de todos los profesionales guardados.

* `load`: método de clase que retorna la instancia del profesional guardado con el nombre recibido como parámetro, previamente verificando que el nombre sea válido y que exista un profesional con dicho nombre.

[+] `all_appointments_by_date`: método de clase que retorna todos los appointments del día indicado, opcionalmente filtrando por un profesional.

[+] `all_appointments_by_week`: método de clase que retorna todos los appointments de la semana indicada, opcionalmente filtrando por un profesional. Se calcula cuál es la fecha del día lunes correspondiente a la semana de la fecha recibida por parámetro. Por ejemplo, si se ingresa la fecha "2021-10-14" (día jueves), el día inicial será "2021-10-11" (día lunes).

En la clase `Appointment` se definen los métodos necesarios para manipular estos objetos, tales como:

* `create`: método de clase que retorna una instancia de un nuevo appointment, en caso de que la fecha y hora del mismo sea mayor a la actual.

* `save`: método de instancia que guarda el appointment, previamente verificando que no exista otro appointment a la misma fecha y hora para el profesional.

* `update`: método de instancia que actualiza los datos del appointment.

* `reschedule`: método de instancia que cambia la fecha y hora del appointment por la recibida como parámetro, previamente verificando que la misma sea válida, que el appointment no haya sido realizado, que no exista otro appointment en la misma fecha y hora para el profesional, y que la nueva fecha y hora sea mayor a la actual.

* `cancel`: método de instancia que cancela el appointment, previamente verificando que la fecha y hora del mismo sea mayor a la actual.

* `edit`: método de instancia que recibe una lista de parámetros nombrados para modificar atributos del appointment (nombre de la persona, apellido, número de teléfono y notas).

* `date`: método de instancia que retorna la fecha del appointment.

[+] `hour`: método de instancia que retorna la hora del appointment.

* `load`: método de clase que retorna el appointment del profesional para la fecha y hora indicados.

* `exists`: método de clase que indica si ya existe un appointment del profesional para la fecha y hora indicados.

* En el método `initialize` del appointment se llevan a cabo las validaciones de sus atributos (a partir del llamado a los setters de dichos atributos).

### [+] Exportación de grillas diarias o semanales

La clase `HTMLExporter` se encarga de realizar la exportación de las grillas de appointments diarios o semanales. Se utilizó la librería "ERB" (Embedded RuBy) para poder generar las plantillas HTML de dichas grillas.

* `create_hours_hash`: método de clase que retorna un hash donde las claves se corresponden con los horarios de atención del policonsultorio (de 9:00 hs a 21:00 hs) y el valor son listas vacías, las cuales posteriormente almacenarán los appointments que se correspondan con dicho horario de comienzo.

* `create_days_hash`: método de clase que retorna un hash donde las claves se corresponden con las fechas de la semana recibida por parámetro y el valor son el hash de horas mencionado en el punto anterior. Posteriormente, este hash almacenará los appointments de cada horario de cada día de la semana.

* `export_appointments_by_date`: método de clase que recibe el listado de appointments de un día en particular y los inserta en la plantilla correspondiente a la grilla de appointments diarios, generando el documento HTML resultante en "appointments.html" dentro del home del usuario que esté ejecutando el comando.

* `export_appointments_by_week`: método de clase que recibe el listado de appointments de una semana en particular y los inserta en la plantilla correspondiente a la grilla de appointments semanales, generando el documento HTML resultante en "appointments.html" dentro del home del usuario que esté ejecutando el comando.

* `get_day_of_week`: método de clase que se utiliza para obtener el día de semana correspondiente a la fecha recibida por parámetro.

Las grillas serán representadas como tablas, donde el eje vertical representa el horario de atención (de 9:00 hs a 21:00 hs) y el eje horizontal representa el o los días (en el caso de una grilla semanal) a mostrar.

Cada celda representará un bloque donde pueden haber turnos de uno/a o más profesionales, en los cuales se mostrará el nombre de paciente que tiene el turno y qué profesional lo atiende, o quedará en blanco en caso que el turno no esté tomado.

La grilla mostrará la información en bloques de duración fija (de 1 hora cada bloque), y cada turno se considera que durará el total de tiempo del bloque en el que esté.

Se agregaron dos nuevos comandos en el apartado de appointmens:

* `list-by-date`: muestra los turnos de un día particular, opcionalmente filtrando por un o una profesional. Ejemplo "appointments list-by-date '2021-09-16' --professional='Alma Estevez'".

* `list-by-week`: muestra los turnos de una semana particular, opcionalmente filtrando por un o una profesional. Ejemplo "appointments list-by-week '2021-09-16' --professional='Alma Estevez'".

### Algunos comentarios

* Al momento de establecer la fecha y hora de un appointment para guardarlo, se verifica que sea una fecha y hora posterior a la actual.

* Un appointment se considera finalizado cuando su fecha y hora es mayor a la actual.

* Puede editarse y mostrarse la información de un appointment aunque este ya haya finalizado.

* El listado de appointments de un profesional muestra todos los appointments de dicho profesional (no se compara con la fecha y hora actual).

* No puede hacerse un reschedule de un appointment que ya fue realizado.

* La operación de cancelar un appointment solo está disponible para appointments que no se han realizado (se compara con la fecha y hora actual).

* Para eliminar un profesional este no debe tener ningún appointment por realizar dentro de su directorio (se compara con la fecha y hora actual).

[+] Los bloques de horarios que se mostrarán en las grillas serán de 1 hora, y abarcará desde las 9:00 hasta las 21:00, por ende, cuando se ingrese una fecha y hora, se verificará que el horario comience en alguno de dichos bloques (por ejemplo, un turno no podría crearse a las 9:30 hs, sino a las 9:00 hs, es decir, al comienzo del bloque).