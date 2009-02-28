require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), "lib", "boot")

configure do
  set :connection_string => Complainatron::Config.connection_string(Sinatra::Application.environment)
end

not_found do
  @error_type = "not_found"
  erb :error
end

error do
  @error_type = "error"
  erb :error
end

helpers do
  include Complainatron::Helpers
end

get "/" do
  @complaint_count = Complainatron::Complaint.count
  @categories = Complainatron::Complaint.categories
  @complaints = Complainatron::Complaint.all(:max => 3)
  erb :home
end

get "/api" do
  erb :api
end

get "/api/complaints" do
  status 200
  @complaints = Complainatron::Complaint.all(params).to_json
end

get "/api/categories" do
  status 200
  @categories = Complainatron::Complaint.categories.to_json
end

post "/api/complaints/create" do
  @complaint = Complainatron::Complaint.new(params.merge(:date_submitted => Time.now))
  if @complaint.save
    #created
    status 201
  else
    #problem - return a JSON-ified collection of errors
    status 400
  end
end

post "/api/complaints/vote" do
  if params["id"]
    @complaint = Complainatron::Complaint.find(params["id"])
    @complaint.vote(params["vote_for"])
    status 201
  else
    status 400
  end
end