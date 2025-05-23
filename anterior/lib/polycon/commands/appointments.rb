module Polycon
  module Commands
    module Appointments
      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          #warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Models::Appointment.create(date, professional, name, surname, phone, notes)
            appointment.save()
          rescue => e
            warn e.message
          else
            puts "Se creó el turno exitosamente"
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Models::Appointment.load(date, professional)
            puts "- Professional: #{appointment.professional.name}"
            puts "- Date: #{appointment.date_time.strftime("%Y-%m-%d %H:%M")}"
            puts "- Name: #{appointment.name}"
            puts "- Surname: #{appointment.surname}"
            puts "- Phone: #{appointment.phone}"
            puts "- Notes: #{appointment.notes}"
          rescue => e
            warn e.message
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          #warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Models::Appointment.load(date, professional)
            appointment.cancel()
          rescue => e
            warn e.message
          else
            puts "Appointment cancelado"
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          #warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            professional = Polycon::Models::Professional.load(professional)
            professional.cancel_all()
          rescue => e
            warn e.message
          else
            puts "Appointments del profesional '#{professional.name}' cancelados"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date: nil)
          #warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            professional = Polycon::Models::Professional.load(professional)
            lista = professional.appointments_list(date)
            puts "Listado de los appointments del profesional '#{professional.name}':"
            lista.each do | appointment |
              puts "- #{appointment}"
            end
          rescue => e
            warn e.message
          end
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          #warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Models::Appointment.load(old_date, professional)
            appointment.reschedule(new_date)
          rescue => e
            warn e.message
          else
            puts "Se modificó la fecha y hora exitosamente"
          end
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          #warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          begin
            appointment = Polycon::Models::Appointment.load(date, professional)
            appointment.edit(**options)
            appointment.update()
          rescue => e
            warn e.message
          else
            puts "Los datos se modificaron exitosamente"
          end
        end
      end

      class ListByDate < Dry::CLI::Command
        desc 'Muestra los turnos de un día particular, opcionalmente filtrando por un o una profesional'

        argument :date, required: true, desc: 'Full date'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
          '"2021-09-16" --professional="Alma Estevez"'
        ]

        def call(date:, professional: nil)
          begin
            appointments = Polycon::Models::Professional.all_appointments_by_date(date, professional)
            Polycon::Exporter::HTMLExporter.export_appointments_by_date(appointments, date, professional)
          rescue => e
            warn e.message
          else
            path = Polycon::Exporter::HTMLExporter.file_path()
            puts "Se exportó el resultado en #{path}"
          end
        end
      end

      class ListByWeek < Dry::CLI::Command
        desc 'Muestra los turnos de una semana particular, opcionalmente filtrando por un o una profesional'

        argument :date, required: true, desc: 'Full date'
        option :professional, required: false, desc: 'Full name of the professional'

        example [
          '"2021-09-16" --professional="Alma Estevez"'
        ]

        def call(date:, professional: nil)
          begin
            appointments = Polycon::Models::Professional.all_appointments_by_week(date, professional)
            Polycon::Exporter::HTMLExporter.export_appointments_by_week(appointments, date, professional)
          rescue => e
            warn e.message
          else
            path = Polycon::Exporter::HTMLExporter.file_path()
            puts "Se exportó el resultado en #{path}"
          end
        end
      end

    end
  end
end
