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
    
    def self.delete_all()
        sql = 'DELETE FROM tickets;'
        SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM tickets;'
        returned = SqlRunner.run(sql)
        returned_as_arr_of_objects = returned.map{ |ticket_hash| Ticket.new(ticket_hash) }
        return returned_as_arr_of_objects
    end

end