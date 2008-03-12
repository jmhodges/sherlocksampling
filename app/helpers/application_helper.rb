# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def bug_in_place_editor(sampling, capture, bug, method)
    field_id = "bug_#{method}_#{bug.id}"
    url = set_problem_code_sampling_capture_bug_url(sampling.uuid, capture, bug, {:action => "set_#{method}"})
    ajax_options = {:method => :put}
    in_place_editor field_id, :options => ajax_options.to_json, :url => url
  end
end
