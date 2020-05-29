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

end