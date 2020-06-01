require_relative('./film')
require_relative('./screening')
require_relative('./sql_runner')
require_relative('./user')

class Ticket
    attr_reader :id, :user_id, :screening_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @user_id = options['user_id'].to_i 
        @screening_id = options['screening_id'].to_i 
    end

    def save()
        sql = "INSERT INTO tickets (user_id, screening_id) VALUES ($1, $2) RETURNING tickets.id"
        values = [@user_id, @screening_id]
        returned_id = SqlRunner.run(sql, values)[0]['id'].to_i
        @id = returned_id
    end

    def screening()
        sql = "SELECT screenings.* FROM screenings WHERE screenings.id = $1;"
        values = [@screening_id]
        screening = SqlRunner.run(sql, values)[0]
        return Screening.new(screening)
    end

    def user()
        sql = "SELECT users.* FROM users WHERE users.id = $1;"
        values = [@user_id]
        user = SqlRunner.run(sql, values)[0]
        return User.new(user)
    end

    def film()
        sql = "
            SELECT films.* FROM films
            INNER JOIN screenings ON screenings.film_id = films.id
            WHERE screenings.id = $1;"
        values = [@screening_id]
        film = SqlRunner.run(sql, values)[0]
        return Film.new(film)
    end

    
    def self.delete_all()
        sql = 'DELETE FROM tickets;'
        SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM tickets;'
        returned = SqlRunner.run(sql)
        returned_as_arr_of_objects = Ticket.map_to_objects(returned)
        return returned_as_arr_of_objects
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM tickets WHERE id = $1"
        values = [id]
        returned_ticket = SqlRunner.run(sql, values)[0]
        return Ticket.new(returned_ticket)
    end

    def self.map_to_objects(array)
        return array.map { |hash| Ticket.new(hash) }
    end

end