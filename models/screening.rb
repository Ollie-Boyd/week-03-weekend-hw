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
end