require('byebug')

require_relative('./models/sql_runner')
require_relative('./models/ticket')
require_relative('./models/screening')
require_relative('./models/film')
require_relative('./models/user')
require_relative('./models/reception')

User.delete_all()
Screening.delete_all()
Ticket.delete_all()
Film.delete_all()

user_ollie = User.new({'name' => 'Ollie', 'funds' => '50'})
user_miranda = User.new({'name' => 'Miranda', 'funds' => '70'})
user_caitlin = User.new({'name' => 'Caitlin', 'funds' => '20'})
user_naomi = User.new({'name' => 'Naomi', 'funds' => '30'})
user_craig= User.new({'name' => 'Craig', 'funds' => '90'})
user_dan = User.new({'name' => 'Dan', 'funds' => '2'})


user_ollie.save()
user_miranda.save()
user_caitlin.save()
user_naomi.save()
user_craig.save()
user_dan.save()

film_mud = Film.new({'title' => 'Mud', 'price' => '7'})
film_trainspotting = Film.new({'title' => 'Trainspotting', 'price' => '8'})
film_lion = Film.new({'title' => 'Lion', 'price' => '7'})
film_girlhood = Film.new({'title' => 'Girhood', 'price' => '9'})
film_perfect_blue = Film.new({'title' => 'Perfect Blue', 'price' => '4'})

film_mud.save()
film_trainspotting.save() 
film_lion.save()
film_girlhood.save()
film_perfect_blue.save()

screening_trainspotting_1200 = Screening.new({'film_id' => film_trainspotting.id, 'time' => '1200', 'capacity' => '4'})
screening_trainspotting_1300 = Screening.new({'film_id' => film_trainspotting.id, 'time' => '1300', 'capacity' => '2'})
screening_mud_1400 = Screening.new({'film_id' => film_mud.id, 'time' => '1400', 'capacity' => '8'})
screening_lion_1530 = Screening.new({'film_id' => film_lion.id, 'time' => '1530', 'capacity' => '4'})
screening_girlhood_1900 = Screening.new({'film_id' => film_girlhood.id, 'time' => '1900', 'capacity' => '2'})
screening_lion_2020 = Screening.new({'film_id' => film_lion.id, 'time' => '2020', 'capacity' => '3'})

screening_trainspotting_1200.save()
screening_trainspotting_1300.save()
screening_mud_1400.save()
screening_lion_1530.save() 
screening_girlhood_1900.save()
screening_lion_2020.save()

ticket_ollie_lion_1530 = Ticket.new({'user_id' => user_ollie.id, 'screening_id' => screening_lion_1530.id})
ticket_ollie_lion_1530 = Ticket.new({'user_id' => user_ollie.id, 'screening_id' => screening_lion_1530.id})
ticket_naomi_mud_1400 = Ticket.new({'user_id' => user_naomi.id, 'screening_id' => screening_mud_1400.id})
ticket_caitlin_girlhood_1900 = Ticket.new({'user_id' => user_caitlin.id, 'screening_id' => screening_girlhood_1900.id})
ticket_miranda_lion_1530 = Ticket.new({'user_id' => user_miranda.id, 'screening_id' => screening_lion_1530.id})
ticket_dan_trainspotting_1300 = Ticket.new({'user_id' => user_dan.id, 'screening_id' => screening_trainspotting_1300.id})
ticket_caitlin_trainspotting_1200 = Ticket.new({'user_id' => user_caitlin.id, 'screening_id' => screening_trainspotting_1200.id})
ticket_naomi_trainspotting_1200 = Ticket.new({'user_id' => user_naomi.id, 'screening_id' => screening_trainspotting_1200.id})

ticket_ollie_lion_1530.save()
ticket_ollie_lion_1530.save()
ticket_naomi_mud_1400.save()
ticket_caitlin_girlhood_1900.save()
ticket_miranda_lion_1530.save()
ticket_dan_trainspotting_1300.save()
ticket_caitlin_trainspotting_1200.save()
ticket_naomi_trainspotting_1200.save()

reception = Reception.new(1000)

reception.print_screenings_to_console()

p User.all()
nil