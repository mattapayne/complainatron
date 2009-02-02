module Complainatron
  
  module Db
    
    def self.included(klazz)
      klazz.extend(Connection)
    end
    
    module Connection
      def with_db
        begin
          return unless block_given?
          db = Sequel.connect(Sinatra::Application.connection_string)
          yield(db)
        ensure
          db.disconnect if db
        end
      end
    end
    
  end
  
end