require_relative('./sql_runner')
require_relative('./ticket')
require_relative('./screening')
require_relative('./film')

class User
    attr_reader :id
    attr_accessor :name, :funds

    def initialize( options )
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @funds = options['funds'].to_i
    end

    def save()
        sql = "INSERT INTO users (name, funds) VALUES ($1, $2) RETURNING users.id"
        values = [@name, @funds]
        returned_id = SqlRunner.run(sql, values)[0]['id'].to_i
        @id = returned_id
    end

    def reduce_wallet_balance(amount)
        @funds -= amount
        self.update()
    end

    def update
        sql = "
            UPDATE users
            SET name = $1, funds = $2
            WHERE id = $3"
        values = [@name, @funds, @id]
        SqlRunner.run(sql, values)
    end

    def tickets()
        sql = "
            SELECT tickets.* FROM tickets
            WHERE tickets.user_id = $1;"
        values = [@id]
        tickets_arr = SqlRunner.run(sql, values)
        ticket_objects_arr = Ticket.map_to_objects(tickets_arr)
        return ticket_objects_arr
    end

    def screenings()
        sql = "
            SELECT screenings.* FROM screenings
            INNER JOIN tickets ON tickets.screening_id = screenings.id
            WHERE tickets.user_id = $1;"
        values = [@id]
        screenings_arr = SqlRunner.run(sql, values)
        screening_objects_arr = Screening.map_to_objects(screenings_arr)
        return screening_objects_arr
    end

    def films()
        sql = "
            SELECT DISTINCT films.* FROM films
            INNER JOIN screenings ON screenings.film_id = films.id
            INNER JOIN tickets ON tickets.screening_id = screenings.id
            WHERE tickets.user_id = $1;
        "
        values = [@id]
        films_arr = SqlRunner.run(sql, values)
        film_objects_arr = Film.map_to_objects(films_arr)
        return film_objects_arr 
    end

    def number_of_tickets_bought()
        tickets.count()
    end

    def self.delete_all()
        sql = 'DELETE FROM users;'
        SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM users;'
        return SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM users;'
        returned = SqlRunner.run(sql)
        returned_as_arr_of_objects = User.map_to_objects(returned)
        return returned_as_arr_of_objects
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM user WHERE id = $1"
        values = [id]
        returned_user = SqlRunner.run(sql, values)[0]
        return User.new(returned_user)
    end

    def self.map_to_objects(arr)
        return arr.map { |hash| User.new(hash)}
    end
end