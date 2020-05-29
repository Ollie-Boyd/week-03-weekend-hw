require_relative('./film')
require_relative('./ticket')
require_relative('./sql_runner')
require_relative('./user')

class Screening
    attr_reader :id, :film_id
    attr_accessor :time, :capacity

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

    def self.delete_all()
        sql = 'DELETE FROM screenings;'
        SqlRunner.run(sql)
    end

    def self.all()
        sql = 'SELECT * FROM screenings;'
        returned = SqlRunner.run(sql)
        returned_as_arr_of_objects = returned.map{ |screening_hash| Screening.new(screening_hash) }
        return returned_as_arr_of_objects
    end
end