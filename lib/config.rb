require 'yaml'

module Complainatron
  
  class Config
    
    class << self
      
      def connection_string(env)
        value_for_key(env.to_sym, :connection_string)
      end
      
      private
      
      def value_for_key(env, key)
        config[env][key]
      end
      
      def config
        @config ||= load_configuration
      end
      
      def load_configuration
        YAML.load(File.open(File.join(File.dirname(__FILE__), "..", "config.yml"), "r"))
      end
      
    end
    
  end
  
end
