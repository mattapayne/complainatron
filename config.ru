require 'rubygems'
require 'sinatra'

local_path = File.dirname(__FILE__)

set :environment,       :production
disable :run, :reload

require File.join(local_path, 'complainatron')

log = File.new("sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application