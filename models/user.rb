require_relative('./sql_runner')
require_relative('./ticket')
require_relative('./screening')
require_relative('./film')

class User
    attr_reader :id
    attr_accessor :name, :funds

    def initalize(options)
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
        returned_as_arr_of_objects = returned.map{ |user_hash| User.new(user_hash) }
        return returned_as_arr_of_objects
    end
end