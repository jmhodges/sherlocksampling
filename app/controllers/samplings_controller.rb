class SamplingsController < ApplicationController
  
  def index
    @latest_samplings = Sampling.find(:all, :limit => 20, :order => "created_at DESC")
  end
  
  def show
    @sampling = Sampling.find_by_uuid(params[:id])
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def new
    @sampling = Sampling.new
    
    respond_to do |wants|
      wants.html
    end
  end
  
  def create
    if params[:sampling][:description].blank?
      render(:status => 400,
        :text => "Hey, you forgot to add a description for your sampling."
      ) and return
    end
    
    params[:sampling][:captures] = [Capture.new, Capture.new] 
    @sampling = Sampling.new(params[:sampling])
    
    @sampling.save
      
    redirect_to(:action => :show, :id => @sampling.uuid)
  end
end
