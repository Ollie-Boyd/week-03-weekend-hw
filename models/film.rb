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
        returned_as_arr_of_objects = returned.map{ |film_hash| Film.new(film_hash) }
        return returned_as_arr_of_objects
    end


end