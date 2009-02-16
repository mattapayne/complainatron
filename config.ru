require 'rubygems'
require 'sinatra'

set :env,       :production
disable :run, :reload

require 'complainatron'

log = File.new("sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application