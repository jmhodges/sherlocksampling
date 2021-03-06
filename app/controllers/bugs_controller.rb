class BugsController < ApplicationController
  before_filter :find_sampling, :find_capture
  before_filter :check_bug_params, :except => [:new, :edit, :delete, :destroy, :set_problem_code, :set_line_number]
  
  def new
    @bug = @capture.bugs.build
  end
  
  def create
    unless params[:bug]
      flash[:notice] = "You forgot all the info about the damn bug. "
      redirect_to :back
    end

    @bug = @capture.bugs.build(params[:bug].slice(:line_number, :problem_code))

    if @bug.save
      
      if request.xhr?
        render(:status => 201, 
          :json => @bug.to_json
        ) and return
      else
        redirect_to(sampling_capture_url(@sampling.uuid, @capture))
      end
      
    else
      if request.xhr?
        render(:status => 400,
          :text => "Bug wasn't able to be created. Don't know why."
        ) and return
      else
        flash[:notice] = ""
        @bug.errors.each_full{|e| flash[:notice] += e }
        redirect_to new_sampling_capture_bug_url(@sampling.uuid, @capture)
      end
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
        render(
          :status => 202, 
          :json => @bug.to_json
        ) and return
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
    render(:text => "Does nothing, yet.")
  end
  
  # Needed for that lame InPlaceEditor
  def set_problem_code
    set_attribute_from_in_place_editor(:problem_code)
  end
  
  def set_line_number
    set_attribute_from_in_place_editor(:line_number)
  end
  
  private
  
  def set_attribute_from_in_place_editor(attr_name)
    @bug = @capture.bugs.find_by_id(params[:id])
    
    unless @bug
      render_bug_404 and return
    end
    
    if @bug.update_attribute(attr_name, params[:value])
      if request.xhr?
        render(
          :status => 202, 
          :json => @bug.send(attr_name)
        ) and return
      end
    end
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
    if params[:bug].blank?
      render(:status => 400, 
        :text => "You didn't specify information for the Bug."
      ) and return
    end

    # Don't let anyone just slide in any old capture_id
    # that would override the build below.  
    params[:bug].except!(:capture_id)
  end
end
