require 'sequel'
require 'json'

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__))

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

module CollectionExtensions
	
  def self.included(klazz)
    klazz.send(:include, InstanceMethods)
  end
	
  module InstanceMethods
		
    def not_empty?
      !blank?
    end
		
  end
	
end

class Hash
  include CollectionExtensions
	
  def to_html_options
    arr = inject([]) do |a, (k,v)|
      a << "#{k}=\"#{v}\""
      a
    end
    arr.join(" ")
  end
	
end

require 'config'
require 'db'
require 'models'
require 'helpers'
