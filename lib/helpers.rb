module Complainatron
  module Helpers
    include Rack::Utils
    
    alias_method :h, :escape_html
    
    def link_to(text, url)
      "<a href=\"#{url}\">#{text}</a>"
    end
    
  end
end