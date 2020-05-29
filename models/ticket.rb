class Ticket
    attr_reader :id, :user_id, :screening_id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @user_id = options['user_id'].to_i 
        @screening_id = options['screening_id'].to_i 
    end
    

end