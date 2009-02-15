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
  erb :home
end

get "/api/complaints" do
  if params["page"] && params["max"]
    @complaints = Complainatron::Complaint.all(:page => params["page"], :max => params["max"])
  else
    @complaints = Complainatron::Complaint.all
  end
  @complaints.to_json
end

get "/api/categories" do
  @categories = Complainatron::Complaint.all.map {|c| c.category }.uniq
  @results = @categories.inject([]) {|array, entry| array << { :category => entry }; array }
  @results.to_json
end

post "/api/complaints/create" do
  @complaint = Complainatron::Complaint.new()
  @complaint.category = params["category"]
  @complaint.complaint = params["complaint"]
  @complaint.date_submitted = Time.now
  @complaint.submitted_by = params["submitted_by"]
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