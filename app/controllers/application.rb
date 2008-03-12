# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '4e8e724923913dd8b0dc54121d95589c'
  
  def find_sampling
    unless @sampling = Sampling.find_by_uuid(params[:sampling_id])
      render(:status => 400,
        :text => "No such Sampling. Sorry, buddy."
      ) and return
    end
  end
  
  def find_capture
    unless @capture = @sampling.captures.find_by_id(params[:capture_id])
      render(:status => 400,
        :text => "No such Capture in this Sampling"
      ) and return
    end
  end
end
