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

100.times do |i|
  Professional.create!(name: "Profesional#{i}")
end

#Creating appointments

200.times do |i|
  begin
    Appointment.create!( professional_id: Professional.all.sample.id,
                        name: "Nombre#{i}", surname: "Apellido#{i}", phone: i,                        
                        date_time: rand(Time.now..(Time.now + 1.year)).change(hour: [*12..19].sample))
  rescue
    redo
  end
end