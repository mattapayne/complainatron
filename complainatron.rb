require 'rubygems'
require 'sinatra'
require File.join(File.dirname(__FILE__), "lib", "boot")

configure do
  set :connection_string => Complainatron::Config.connection_string(Sinatra::Application.environment)
end

get "/" do
  "Coming soon"
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
  Complainatron::Complaint.all.map {|c| {:category => c.category} }.uniq.to_json
end

post "/api/complaints/create" do
  unless params["complaint"]
    status 400
  else
    @complaint = Complainatron::Complaint.new(params["complaint"])
    if @complaint.save
      status 201
    else
      status 400
    end
  end
end

post "/api/complaints/vote" do
  unless params["id"]
    status 401
  else
    @complaint = Complainatron::Complaint.find(params["id"])
    if @complaint
      if params["vote_for"] == "false"
        if @complaint.vote_against
          status 201
        else
          status 400
        end
      else
        if @complaint.vote_for
          status 201
        else
          status 400
        end
      end
    else
      status 404
    end
  end
end