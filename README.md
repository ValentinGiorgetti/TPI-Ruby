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
* `InvalidDateError`: indica que el usuario ingresó una fecha inválida.
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

En la clase `Appointment` se definen los métodos necesarios para manipular estos objetos, tales como:

* `create`: método de clase que retorna una instancia de un nuevo appointment, en caso de que la fecha y hora del mismo sea mayor a la actual.

* `save`: método de instancia que guarda el appointment, previamente verificando que no exista otro appointment a la misma fecha y hora para el profesional.

* `update`: método de instancia que actualiza los datos del appointment.

* `reschedule`: método de instancia que cambia la fecha y hora del appointment por la recibida como parámetro, previamente verificando que la misma sea válida y no exista otro appointment en la misma fecha y hora para el profesional. 

* `edit`: método de instancia que recibe una lista de parámetros nombrados para modificar atributos del appointment (nombre de la persona, apellido, número de teléfono y notas).

* `load`: método de clase que retorna el appointment del profesional para la fecha y hora indicados.

* `exists`: método de clase que indica si ya existe un appointment del profesional para la fecha y hora indicados.

* En el método `initialize` del appointment se llevan a cabo las validaciones de sus atributos (a partir del llamado a los setters de dichos atributos).

### Algunos comentarios

* Al momento de establecer la fecha y hora de un appointment para guardarlo, se verifica que sea una fecha y hora posterior a la actual.

* Un appointment se considera finalizado cuando su fecha y hora es mayor a la actual.

* Puede editarse y mostrarse la información de un appointment aunque esta ya haya finalizado.

* No puede cambiarse la fecha y hora de un appointment que ya fue realizado.

* El listado de appointments de un profesional muestra todos los appointments de dicho profesional (no se compara con la fecha y hora actual).

* La operación de cancelar un appointment solo está disponible para appointments que no se han realizado (se compara con la fecha y hora actual).

* Para eliminar un profesional este no debe tener ningún appointment por realizar dentro de su directorio (se compara con la fecha y hora actual).