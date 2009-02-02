require 'rubygems'
require 'sinatra'

set :env,       :production
disable :run, :reload

require 'complainatron'

run Sinatra.application