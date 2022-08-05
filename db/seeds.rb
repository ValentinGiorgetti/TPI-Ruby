# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating users

User.create( [ {name: 'Oscar', surname: 'Castilla', email: 'admin@gmail.com', password: '123456', role: "administrator"},
               {name: 'Miguel', surname: 'Mendez', email: 'assistant@gmail.com', password: '123456', role: "assistant"},
               {name: 'Josefina', surname: 'Perez', email: 'consultant@gmail.com', password: '123456', role: "consultant"} ] )

# Creating professionals

Professional.create( [ {name: 'Jose'}, {name: 'Juan'}, {name: 'Marta'} ] )

#Creating appointments

Appointment.create( [ {professional_id: 1, name: 'Carlos', surname: 'Perez', phone: '12345214', date_time: DateTime.strptime("11/2/2023 13:00", "%d/%m/%Y %H:%M")},
                      {professional_id: 1, name: 'Alberto', surname: 'Martinez', phone: '12345213', date_time: DateTime.strptime("11/2/2023 15:00", "%d/%m/%Y %H:%M")},
                      {professional_id: 2, name: 'Juana', surname: 'Perez', phone: '12345211', date_time: DateTime.strptime("11/2/2023 15:00", "%d/%m/%Y %H:%M")},
                      {professional_id: 2, name: 'Luciano', surname: 'Flores', phone: '12345215', date_time: DateTime.strptime("14/2/2023 15:00", "%d/%m/%Y %H:%M")},
                      {professional_id: 3, name: 'Martin', surname: 'Flores', phone: '12345210', date_time: DateTime.strptime("15/2/2023 17:00", "%d/%m/%Y %H:%M")},
                      {professional_id: 3, name: 'Jorge', surname: 'Perez', phone: '12345219', date_time: DateTime.strptime("15/2/2023 21:00", "%d/%m/%Y %H:%M")} ] )