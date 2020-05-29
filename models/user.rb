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
end