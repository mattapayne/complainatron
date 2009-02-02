require 'rubygems'
require 'sequel'
require File.join(File.dirname(__FILE__), "..", "lib", "config")

class CreateComplaints < Sequel::Migration

  def up
    execute "DROP TABLE IF EXISTS Complaints"
    create_table :complaints do
      primary_key :id
      varchar :category, {:size => 255, :null => false}
      text :complaint, {:null => false}
      varchar :longitude
      varchar :latitude
      timestamp :date_submitted
      varchar :submitted_by
      integer :vote_for
      integer :vote_against
    end
  end
  
  def down
    execute "DROP TABLE IF EXISTS Complaints"
  end
  
end

class Setup

  class << self
  
    def migrate(env, direction)
      db = Sequel.open(Complainatron::Config.connection_string(env.to_sym))
      migrations.each {|m| m.apply(db, direction) }
    end
    
    def migrations
      [CreateComplaints]
    end
    
  end
  
end

env = ARGV.first.to_sym
direction = :up
if ARGV.length > 1
  direction = ARGV.last.to_sym || :up
end

Setup.migrate(env, direction)
