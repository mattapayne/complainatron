module Complainatron
  
  class Complaint
  
    include Complainatron::Db
  
    attr_accessor :id, :category, :complaint, :date_submitted, 
      :latitude, :longitude, :submitted_by, :votes_for, :votes_against
    
      def initialize(attributes=nil)
        @attributes = attributes
        build(attributes) if attributes
      end
    
      def save
        self.class.save(self)
      end
      
      def vote_against
        self.votes_against = self.votes_against.to_i + 1
        self.save
      end
      
      def vote_for
        self.votes_for = self.votes_for.to_i + 1
        self.save
      end
      
      def vote(vote_type)
        if vote_type == "false"
          vote_against
        else
          vote_for
        end
      end
      
      def summary
        "#{self.complaint} - Submitted: #{self.date_submitted}"
      end
      
      class << self
        
        def count
          count = 0
          with_db do |db|
            count = db[table].count
          end
          count
        end
        
        def categories
          categories = []
          with_db do |db|
            data = db[table].select(:category)
            categories = data.inject([]) do |arr, rec|
              arr << rec[:category]
              arr
            end
          end
          categories.uniq.inject([]) {|array, entry| array << { :category => entry }; array }
        end
      
        def all(options={})
          options = options.symbolize_keys
          all = []
          page = options[:page] ? options[:page].to_i : 1
          per_page = options[:max] ? options[:max].to_i : nil
          with_db do |db|
            if page && per_page
              data = db[table].paginate(page, per_page)
            elsif per_page
              data = db[table].limit(per_page)
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
        
        def save(obj)
          with_db do |db|
            unless obj.id
              db[table].insert(obj.send(:as_hash))
            else
              db[table].filter(:id => obj.id).update(obj.send(:as_hash))
            end
          end
        end
      
        private
      
        def table
          :complaints
        end
      
      end
    
      private
      
      def as_hash
        {
          :category => self.category, :complaint => self.complaint, :date_submitted => self.date_submitted,
          :submitted_by => self.submitted_by, :latitude => self.latitude, :longitude => self.longitude,
          :votes_for => self.votes_for, :votes_against => self.votes_against
        }
      end
    
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