require('pg')

require_relative('./film')
require_relative('./ticket')
require_relative('./screening')
require_relative('./user')




class SqlRunner
    def self.run( sql, values = [] )
      begin
        db = PG.connect({ dbname: 'cinema', host: 'localhost' })
        db.prepare("query", sql)
        result = db.exec_prepared( "query", values )
      ensure
        db.close() if db != nil
      end
      return result
    end
end
