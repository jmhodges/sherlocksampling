class BugsController < ApplicationController
  before_filter :find_sampling, :find_capture
  before_filter :check_bug_params, :except => [:new, :edit, :delete]
  
  def new
    @bug = @capture.bugs.build
  end
  
  def create
    @bug = @capture.bugs.build(params[:bug])

    if @bug.save
      
      if request.xhr?
        render(:status => 201, 
          :json => @bug.to_json
        ) and return
      else
        redirect_to(sampling_capture_url(@sampling.uuid, @capture))
      end
      
    else
      render(:status => 400, 
        :text => "Bug wasn't able to be created. Don't know why."
      ) and return
    end
  end
  
  def edit
    
  end
  
  def update
    @bug = @capture.bugs.find_by_id(params[:id])
    unless @bug
      render_bug_404 and return
    end
    
    if @bug.update_attributes(params[:bug])
      if request.xhr?
        render(:status => 202, :json => @bug.to_json) and return
      end
      
      redirect_to(sampling_capture_url(@sampling.uuid, @capture))
    else
      render(:status => 400, 
        :text => "Bug wasn't able to be updated.  Guess why!"
      ) and return
    end
  end
  
  def delete
    
  end
  
  def destroy
    
  end
  
  def render_bug_404
    render(:status => 404, :text => 
"Bug with id #{params[:id].inspect} wasn't found on \
Capture #{params[:capture_id].inspect} in the \
Sampling #{params[:sampling_id].inspect}"
    )
  end
  # Filters
  def check_bug_params
    unless params[:bug] 
      render(:status => 400, 
        :text => "You didn't specify information for the Bug."
      )
    end

    # Don't let anyone just slide in any old capture_id
    # that would override the build below.  
    params[:bug].except!(:capture_id)
  end
end
