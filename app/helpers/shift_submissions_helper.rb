module ShiftSubmissionsHelper
  def shift_submission_params
    blank_params = {}
    @period.days.count.times do |num|
      blank_params[num.to_s] = {
        "date" => "",
        "start_time" => "",
        "end_time" => ""
      }
    end
    
    params[:shift_request] || session[:shift_requests] || blank_params
  end
  
  def num_of_displays
    result = 1
    shift_submission_params.values.each_with_index { |value, index| result = index + 1 unless value.values.all?(&:blank?) }
    result
  end
end
