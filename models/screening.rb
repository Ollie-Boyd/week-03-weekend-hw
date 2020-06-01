require_relative('./film')
require_relative('./ticket')
require_relative('./sql_runner')
require_relative('./user')

class Screening
    attr_reader :id
    attr_accessor :time, :capacity, :film_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @film_id = options['film_id'].to_i
        @time = options['time'].to_i
        @capacity = options['capacity'].to_i
    end

    def save()
        sql = "INSERT INTO screenings (film_id, time, capacity) VALUES ($1, $2, $3) RETURNING screenings.id"
        values = [@film_id, @time, @capacity]
        returned_id = SqlRunner.run(sql, values)[0]['id'].to_i
        @id = returned_id
    end

    def update
        sql = "
            UPDATE screenings
            SET time = $1, capacity = $2, film_id = $3
            WHERE id = $4"
        values = [@time, @capacity, @film_id, @id]
        SqlRunner.run(sql, values)
    end

    def users()
        sql = "
            SELECT users.* FROM users
            INNER JOIN tickets ON tickets.user_id = users.id
            WHERE tickets.screening_id = $1;"
        values = [@id]
        returned_users = SqlRunner.run(sql, values)
        user_objects_arr = User.map_to_objects(returned_users)
        return user_objects_arr
    end

    def film()
        sql = "
            SELECT films.* FROM films WHERE films.id = $1;"
        values = [@film_id]
        returned_film = SqlRunner.run(sql, values)[0]
        return Film.new(returned_film)
    end 

    def tickets()
        sql = "
            SELECT tickets.* FROM tickets
            WHERE tickets.screening_id = $1;"
        values = [@id]
        returned_tickets = SqlRunner.run(sql, values)
        ticket_objects_arr = Ticket.map_to_objects(returned_tickets)
        return ticket_objects_arr
    end

    def tickets_sold()
        return tickets.count
    end

    def self.delete_all()
        sql = "DELETE FROM screenings;"
        SqlRunner.run(sql)
    end

    def self.all()
        sql = "SELECT * FROM screenings;"
        returned = SqlRunner.run(sql)
        returned_as_arr_of_objects = Screening.map_to_objects(returned)
        return returned_as_arr_of_objects
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM screenings WHERE id = $1"
        values = [id]
        returned_screening = SqlRunner.run(sql, values)[0]
        return Screening.new(returned_screening)
    end

    def self.map_to_objects(array)
        return array.map { |hash| Screening.new(hash) }
    end
end