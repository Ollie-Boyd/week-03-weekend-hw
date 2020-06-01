require_relative('./sql_runner')
require_relative('./ticket')
require_relative('./screening')
require_relative('./user')

class Film
    attr_reader :id
    attr_accessor :title, :price
    
    def initialize(options)
        @id = options['id'].to_i if options['id']
        @title = options['title']
        @price = options['price'].to_i
    end

    def save()
        sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING films.id"
        values = [@title, @price]
        returned_id = SqlRunner.run(sql, values)[0]['id'].to_i
        @id = returned_id
    end

    def update
        sql = "
            UPDATE films
            SET title = $1, price = $2
            WHERE id = $3"
        values = [@title, @price, @id]
        SqlRunner.run(sql, values)
    end

    def users()
        sql = "
            SELECT users.* FROM users
            INNER JOIN tickets ON tickets.user_id = users.id
            INNER JOIN screenings ON screenings.id = tickets.screening_id
            WHERE screenings.film_id = $1;"
        values = [@id]
        users_arr = SqlRunner.run(sql, values)
        user_objects_arr = User.map_to_objects(users_arr)
        return user_objects_arr
    end

    def tickets()
        sql = "
            SELECT tickets.* FROM tickets
            INNER JOIN screenings ON tickets.screening_id = screenings.id
            WHERE screenings.film_id = $1;"
        values = [@id]
        tickets_arr = SqlRunner.run(sql, values)
        ticket_objects_arr = Ticket.map_to_objects(tickets_arr)
        return ticket_objects_arr
    end

    def screenings()
        sql = "
            SELECT screenings.* FROM screenings
            WHERE screenings.film_id = $1;"
        values = [@id]
        screenings_arr = SqlRunner.run(sql, values)
        screening_objects_arr = Screening.map_to_objects(screenings_arr)
        return screening_objects_arr
    end

    def most_popular_screening()
        best_seller = screenings.max_by{ |screening| screening.tickets_sold()}
        return best_seller
    end

    def self.delete_all()
        sql = 'DELETE FROM films;'
        SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM films;'
        return SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM films;'
        returned = SqlRunner.run(sql)
        returned_as_arr_of_objects = Film.map_to_objects(returned)
        return returned_as_arr_of_objects
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM films WHERE id = $1"
        values = [id]
        returned_film = SqlRunner.run(sql, values)[0]
        return Film.new(returned_film)
    end

    def self.map_to_objects(array)
        return array.map { |hash| Film.new(hash) }
    end 

end