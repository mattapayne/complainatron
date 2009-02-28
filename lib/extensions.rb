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
  
  def symbolize_keys
    tmp = {}
    self.each do |k,v|
      tmp[k.to_sym] = v
    end
    tmp
  end
	
end