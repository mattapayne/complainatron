module Complainatron
  
  class Complaint
  
    include Complainatron::Db
  
    attr_accessor :id, :category, :complaint, :date_submitted, 
      :latitude, :longitude, :submitted_by, :votes_for, :votes_against
    
      def initialize(attributes)
        @attributes = attributes
        build(attributes)
      end
    
      class << self
      
        def all(options={})
          all = []
          page = options[:page] ? options[:page].to_i : 1
          per_page = options[:max] ? options[:max].to_i : nil
          with_db do |db|
            if page && per_page
              data = db[table].paginate(page, per_page)
            else
              data = db[table].all
            end
            all = data.inject([]) do |arr, row|
              arr << new(row)
              arr
            end
          end
          all
        end
      
        def find(id)
          found = nil
          with_db do |db|
            data = db[table].filter(:id => id)
            found = new(data.first) if data && data.first
          end
          found
        end
      
        private
      
        def table
          :complaints
        end
      
      end
    
      private
    
      def build(attributes)
        attributes.each do |attr_name, attr_value|
          if attr_value
            attr = attr_name.to_sym
            if self.respond_to?(attr) || self.respond_to?("#{attr}=".to_sym)
              self.instance_variable_set("@#{attr}".to_sym, attr_value)
            end
          end
        end
      end
      
      def to_json(*a)
        @attributes.to_json(*a)
      end
    
  end
  
end