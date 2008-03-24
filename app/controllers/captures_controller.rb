class CapturesController < ApplicationController
  before_filter :find_sampling
  
  def show
    @capture = @sampling.captures.find_by_id(params[:id].to_i)
  end
  
  # Update only allows updates to the Capture's "completed" status
  def update
    @capture = @sampling.captures.find_by_id(params[:id].to_i)
    
    
    unless @capture 
      flash[:notice] = "No Capture with id #{params[:id].to_s.inspect} in this Sampling."
      redirect_to sampling_url(@sampling.uuid) and return
    end
    
    unless params[:capture]
      flash[:notice] = "You didn't provide any info about the Capture!"
      redirect_to sampling_capture_url(@sampling.uuid, @capture) and return
    end
    
    if @capture.completed?
      flash[:notice] = "This Capture was already completed and cannot be updated further."
      redirect_to sampling_capture_url(@sampling.uuid, @capture) and return
    end
    
    if params[:capture][:completed] && @capture.completed!
      flash[:good] = "Capture was completed! Go, you!"
      redirect_to sampling_capture_url(@sampling.uuid, @capture) and return
    else
      logger.error("Status change of capture #{@capture.id} to #{params[:capture]} failed.")
      flash[:notice] = "Welp, something went terrible wrong."
      redirect_to sampling_capture_url(@sampling.uuid, @capture) and return
    end
  end
end
