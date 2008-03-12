class CapturesController < ApplicationController
  before_filter :find_sampling
  
  in_place_edit_for :bug, :problem_code
  def show
    @capture = @sampling.captures.find_by_id(params[:id].to_i)
  end
  
  # Written to only called by Ajax calls
  def update
    @capture = @sampling.captures.find_by_id(params[:id].to_i)
    
    
    unless @capture 
      render(:status => 404, 
        :text => "No Capture with id #{params[:id].to_s.inspect} in this Sampling."
      ) and return
    end
    
    unless params[:capture]
      render(:status => 400, 
        :text => "You didn't provide any info about the Capture!"
      ) and return
    end
    
    # We only allow updates to status.
    params[:capture].slice!(:status)
    
    if @capture.status == Capture::Complete
      render(:status => 409, 
        :text => "This Capture was already completed and cannot be updated further."
      ) and return
    end
    
    if @capture.update_attributes(params[:capture])
      render(:nothing => true)
    else
      render(:status => 400, # FIXME this isn't helpful
        :text => "Whoops, you gave me something bad"
      ) and return
    end
  end
end
