require('byebug')

require_relative('./sql_runner')
require_relative('./ticket')
require_relative('./screening')
require_relative('./film')
require_relative('./user')

class Reception
    attr_reader :till_balance

    #i didn't have the motivation to make the checks work for a customer buying multiple tickets so it only works for 1 ticket at a time. Also I guess the reception should have a database table with till_balance but again I didn't have the time or energy. 
    def initialize(till_balance)
        @screenings = Screening.all()
        @tickets = Ticket.all()
        @films = Film.all()
        @users = User.all()
        @till_balance = till_balance
    end
    #tested
    def check_screening_has_available_capacity(screening)
        capacity = screening.capacity()
        sold_tickets = screening.tickets.count
        remaining_seats = capacity - sold_tickets
        return true if remaining_seats>=1
    end
    
    def check_customer_can_afford(screening, wallet_balance)
        return true if screening.film.price()<=wallet_balance
    end

    def check_capacity_and_affordability(screening, wallet_balance)
        return true if check_customer_can_afford(screening, wallet_balance) && check_screening_has_available_capacity(screening)
    end

    def increase_till_balance(amount)
        @till_balance += amount
    end

    def balance_exchange(customer, ticket_price)
        customer.reduce_wallet_balance(ticket_price)
        increase_till_balance(ticket_price)
    end

    def create_ticket(screening, customer)
        ticket = Ticket.new({'user_id' => customer.id, 'screening_id' => screening.id})
        ticket.save()
    end

    def print_screenings_to_console()
        sql = "SELECT films.title, screenings.time, films.price, screenings.capacity-count(tickets.screening_id) AS tickets_remaining FROM screenings
        LEFT JOIN tickets ON (tickets.screening_id = screenings.id)
        INNER JOIN films ON films.id = screenings.film_id
        GROUP BY
            screenings.id,
            films.title,
            films.price
        ORDER BY screenings.time
        ; 
        "
        returned_listings = SqlRunner.run(sql)
        line_width = 100
        puts ('Title'.ljust(line_width/4) + 'Time'.ljust(line_width/4) + 'Price'.ljust(line_width/4) + 'Tickets remaining'.rjust(line_width/4))
        
        returned_listings.each do |screening|
            puts "-"*line_width
            puts (screening['title'].ljust(line_width/4) + screening['time'].ljust(line_width/4) + screening['price'].ljust(line_width/4) + screening['tickets_remaining'].rjust(line_width/4))
        end

    end


    def sell_ticket(screening, customer) 
        if check_capacity_and_affordability(screening, wallet_balance)

            ticket_price = screening.film.price()
            balance_exchange(customer, ticket_price)

            create_ticket(screening, customer)
        end
    end



end