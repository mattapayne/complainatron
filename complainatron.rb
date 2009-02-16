require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), "lib", "boot")

configure do
  set :connection_string => Complainatron::Config.connection_string(Sinatra::Application.environment)
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
    @complaints = Complainatron::Complaint.all(params).to_json
end

get "/api/categories" do
  @categories = Complainatron::Complaint.all.map {|c| c.category }.uniq
  @results = @categories.inject([]) {|array, entry| array << { :category => entry }; array }
  @results.to_json
end

post "/api/complaints/create" do
  @complaint = Complainatron::Complaint.new(params.merge(:date_submitted => Time.now))
  if @complaint.save
    status 201
  else
    status 400
  end
end

post "/api/complaints/vote" do
  if params["id"]
    @complaint = Complainatron::Complaint.find(params["id"])
    if params["vote_for"] == "false"
      @complaint.vote_against
      status 201
    else
      @complaint.vote_for
      status 201
    end
  else
    status 400
  end
end